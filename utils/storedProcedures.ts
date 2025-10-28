import prisma from "./prisma"

// Utility functions for calling stored procedures with Prisma
export class StoredProcedureService {
  // Execute stored procedure that returns data
  static async callWithResult<T = any>(
    query: TemplateStringsArray | string,
    parameters: any[] = []
  ): Promise<T[]> {
    try {
      return await prisma.$queryRaw<T[]>`
        ${query}
      ` as T[]
    } catch (error) {
      console.error('Stored procedure call failed:', error)
      throw error
    }
  }

  // Execute stored procedure that doesn't return data
  static async callWithoutResult(
    query: TemplateStringsArray | string,
    parameters: any[] = []
  ): Promise<void> {
    try {
      await prisma.$executeRaw`
        ${query}
      `
    } catch (error) {
      console.error('Stored procedure call failed:', error)
      throw error
    }
  }

  // Call stored procedure with fallback to Prisma logic
  static async callWithFallback<T>(
    storedProcedureQuery: string,
    fallbackLogic: () => Promise<T>,
    parameters: any[] = []
  ): Promise<T> {
    try {
      const result = await this.callWithResult(storedProcedureQuery, parameters)
      if (result && result.length > 0) {
        return result[0] as T
      }
    } catch (error) {
      console.warn('Stored procedure failed, falling back to Prisma logic:', error)
    }

    return await fallbackLogic()
  }
}

// Example usage:
// const metrics = await StoredProcedureService.callWithFallback(
//   `SELECT * FROM get_dashboard_metrics(${user}, ${runningAvg})`,
//   async () => calculateMetricsInApplication(user, runningAvg)
// )
