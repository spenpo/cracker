import { authOptions } from "@/pages/api/auth/[...nextauth]"
import { type MyContext } from "@/pages/api/graphql"
import { getServerSession } from "next-auth"
import { Arg, Ctx, Query, Resolver } from "type-graphql"
import redis from "@/utils/redis"
import {
  GetSentences,
  BasicSentence,
  BasicDashboardInput,
} from "../schemas/dashboard"
import { CACHE_KEYS } from "@/constants"
import prisma from "@/utils/prisma"
import { PgBasicSentence } from "@/types"

@Resolver(GetSentences)
export class BasicDashboardSentences {
  @Query(() => GetSentences)
  async basicDashboardSentences(
    @Arg("args", () => BasicDashboardInput) args: BasicDashboardInput,
    @Ctx() { req, res }: MyContext
  ): Promise<GetSentences> {
    const {
      user: { id: user },
    } = await getServerSession(req, res, authOptions)

    const cachedMetrics = await redis.hget(
      `${CACHE_KEYS.basicDashboardSentences}/${user}`,
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
        CALL get_dashboard_sentences(
          ${Number(user)},
          ${args.runningAvg},
          ${ratingFilter},
          ${args.minHours},
          ${args.maxHours},
          ${args.sortColumn || 'createdAt'},
          ${args.sortDir || 'desc'}
        )
      ` as PgBasicSentence[]

      const sentences: BasicSentence[] = result.map((row, idx) => ({
        text: {
          content: row.sentence,
        },
        id: idx.toString(),
        rating: row.rating,
        numberCreativeHours: Number(row.number_creative_hours),
        createdAt: row.created_at,
        overview: row.overview,
      }))

      const dashboard = { sentences }

      await redis.hset(
        `${CACHE_KEYS.basicDashboardSentences}/${user}`,
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
