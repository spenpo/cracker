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
        const foundUser = await prisma.user.findUnique({
          where: { id: Number(user) },
          include: {
            tracker_tracker_userTouser: {
              orderBy: { created_at: 'desc' },
              take: 1,
            },
            role_lookup: true,
          },
        })

        if (!foundUser) {
          return {
            error: "not found",
          }
        }

        const lastPost = foundUser.tracker_tracker_userTouser[0]
        const response = {
          me: {
            user: {
              id: String(foundUser.id),
              username: foundUser.username,
              email: foundUser.email,
              role: foundUser.role || 1,
            },
            lastPost: lastPost
              ? {
                  id: String(lastPost.id),
                  overview: lastPost.overview,
                  numberCreativeHours: Number(lastPost.number_creative_hours),
                  rating: lastPost.rating,
                  createdAt: lastPost.created_at?.toLocaleDateString() || '',
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
