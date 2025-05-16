import "reflect-metadata"
import { ApolloServer } from "@apollo/server"
import { startServerAndCreateNextHandler } from "@as-integrations/next"
import { buildSchema } from "type-graphql"
import {
  RegistrationResolver,
  MeReslover,
  TrackerResolver,
  PremiumDashboardReslover,
  DashboardMetricsReslover,
  UploadTrackerResolver,
  UpdateTrackerResolver,
  BasicDashboardWords,
  BasicDashboardSentences,
  WordMentions,
  UpgradeResolver,
  FeatureFlagsResolver,
} from "@/graphql/resolvers"
import { NextApiRequest, NextApiResponse } from "next"
import { PrismaClient } from "@prisma/client"

// Prevent multiple instances of Prisma Client in development
declare global {
  var prisma: PrismaClient | undefined
}

console.log('Initializing Prisma Client...')

const prisma = global.prisma || new PrismaClient({
  log: ['query', 'error', 'info', 'warn'],
  datasources: {
    db: {
      url: process.env.DATABASE_URL
    }
  }
})

// Test the connection
prisma.$connect()
  .then(() => {
    console.log('Successfully connected to MySQL database')
  })
  .catch((e) => {
    console.error('Failed to connect to MySQL database:', e)
  })

if (process.env.NODE_ENV !== 'production') global.prisma = prisma

const schema = await buildSchema({
  resolvers: [
    RegistrationResolver,
    MeReslover,
    TrackerResolver,
    PremiumDashboardReslover,
    DashboardMetricsReslover,
    BasicDashboardWords,
    BasicDashboardSentences,
    WordMentions,
    UploadTrackerResolver,
    UpdateTrackerResolver,
    UpgradeResolver,
    FeatureFlagsResolver,
  ],
  validate: false,
})

const server = new ApolloServer({ 
  schema,
  // Add error handling for serverless environment
  formatError: (error) => {
    console.error('GraphQL Error:', error)
    return {
      message: error.message,
      path: error.path,
      extensions: {
        code: error.extensions?.code || 'INTERNAL_SERVER_ERROR'
      }
    }
  }
})

export type MyContext = {
  req: NextApiRequest
  res: NextApiResponse
  prisma: PrismaClient
}

export default startServerAndCreateNextHandler(server, {
  context: async (req, res): Promise<MyContext> => ({
    req,
    res,
    prisma
  }),
})
