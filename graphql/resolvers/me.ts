import { authOptions } from "@/pages/api/auth/[...nextauth]"
import { type MyContext } from "@/pages/api/graphql"
import { getServerSession } from "next-auth"
import { Arg, Ctx, Query, Resolver } from "type-graphql"
import redis from "@/utils/redis"
import { MeQueryResponse } from "../schemas/me/meQueryResponse"
import prisma from "@/utils/prisma"

@Resolver(MeQueryResponse)
export class MeReslover {
  @Query(() => MeQueryResponse)
  async me(
    @Arg("refetch", { nullable: true }) refetch: boolean = false,
    @Ctx() { req, res }: MyContext
  ): Promise<MeQueryResponse> {
    const {
      user: { id: user },
    } = await getServerSession(req, res, authOptions)

    const queryPrisma = async (): Promise<MeQueryResponse> => {
      try {
        // Call MySQL stored procedure
        const result = await prisma.$queryRaw`
          CALL get_user_info(${Number(user)})
        ` as Array<{
          id: number
          username: string
          email: string
          role: number | null
          last_post_id: number | null
          last_post_overview: string | null
          last_post_hours: number | null
          last_post_rating: number | null
          last_post_date: Date | null
        }>

        if (result.length === 0) {
          return {
            error: "not found",
          }
        }

        const userData = result[0]
        const response = {
          me: {
            user: {
              id: String(userData.id),
              username: userData.username,
              email: userData.email,
              role: userData.role || 1,
            },
            lastPost: userData.last_post_id
              ? {
                  id: String(userData.last_post_id),
                  overview: userData.last_post_overview || '',
                  numberCreativeHours: Number(userData.last_post_hours || 0),
                  rating: userData.last_post_rating || 0,
                  createdAt: userData.last_post_date?.toLocaleDateString() || '',
                }
              : null,
          },
        }

        await redis.setex(user, 60 * 15, JSON.stringify(response)) // expires in 15 minutes
        return response
      } catch (e) {
        console.log(e)
        return {
          error: "unhandled error",
        }
      }
    }

    if (refetch) {
      return queryPrisma()
    } else {
      const redisUser = await redis.get(user)
      if (redisUser) return JSON.parse(redisUser)
      else return queryPrisma()
    }
  }
}
