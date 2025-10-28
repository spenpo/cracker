import { authOptions } from "@/pages/api/auth/[...nextauth]"
import { type MyContext } from "@/pages/api/graphql"
import { getServerSession } from "next-auth"
import { Arg, Ctx, Query, Resolver } from "type-graphql"
import redis from "@/utils/redis"
import { BasicDashboardInput, GetWords, Word } from "../schemas/dashboard"
import { CACHE_KEYS } from "@/constants"
import prisma from "@/utils/prisma"
import { PgBasicWord } from "@/types"

@Resolver(GetWords)
export class BasicDashboardWords {
  @Query(() => GetWords)
  async basicDashboardWords(
    @Arg("args", () => BasicDashboardInput) args: BasicDashboardInput,
    @Ctx() { req, res }: MyContext
  ): Promise<GetWords> {
    const {
      user: { id: user },
    } = await getServerSession(req, res, authOptions)

    const cachedMetrics = await redis.hget(
      `${CACHE_KEYS.basicDashboardWords}/${user}`,
      JSON.stringify(args)
    )

    if (cachedMetrics) return JSON.parse(cachedMetrics)

    try {
      // Format rating filter as JSON for MySQL stored procedure
      const ratingFilter = args.rating && args.rating.length > 0
        ? JSON.stringify(args.rating)
        : null

      // Call MySQL stored procedure
      const result = await prisma.$queryRaw`
        CALL get_dashboard_words(
          ${Number(user)},
          ${args.runningAvg},
          ${ratingFilter},
          ${args.minHours},
          ${args.maxHours},
          ${args.sortColumn || 'count'},
          ${args.sortDir || 'asc'}
        )
      ` as PgBasicWord[]

      const words: Word[] = result.map((row) => ({
        word: {
          text: {
            content: row.word,
          },
          mentions: row.days_used,
        },
        count: Number(row.count),
        hide: false,
      }))

      const dashboard = { words }

      await redis.hset(
        `${CACHE_KEYS.basicDashboardWords}/${user}`,
        `${JSON.stringify(args)}`,
        JSON.stringify(dashboard)
      )

      return dashboard
    } catch (e) {
      console.log(e)
      return {
        errors: [
          {
            field: "unknown",
            message: "unhandled error",
          },
        ],
      }
    }
  }
}
