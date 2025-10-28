import { authOptions } from "@/pages/api/auth/[...nextauth]"
import { type MyContext } from "@/pages/api/graphql"
import { deleteNlpCache } from "@/utils/redis"
import { getServerSession } from "next-auth"
import { Arg, Ctx, Mutation, Resolver } from "type-graphql"
import { TrackerInput } from "../schemas/track/trackerInput"
import { TrackerResponse } from "../schemas/track/trackerResponse"
import prisma from "@/utils/prisma"

@Resolver(TrackerResponse)
class TrackerResolver {
  @Mutation(() => TrackerResponse)
  async track(
    @Arg("tracker", () => TrackerInput) tracker: TrackerInput,
    @Ctx() { req, res }: MyContext
  ): Promise<TrackerResponse> {
    const { overview, numberCreativeHours, rating } = tracker
    const {
      user: { id: user },
    } = await getServerSession(req, res, authOptions)
    await deleteNlpCache(user)

    try {
      const newTracker = await prisma.tracker.create({
        data: {
          overview,
          number_creative_hours: numberCreativeHours,
          rating,
          user: Number(user),
        },
      })

      return {
        track: {
          id: newTracker.id.toString(),
          overview: newTracker.overview,
          numberCreativeHours: Number(newTracker.number_creative_hours),
          rating: newTracker.rating,
          user: newTracker.user.toString(),
        },
      }
    } catch (e: any) {
      console.log(e)
      if (e.code === "P2003") {
        // Foreign key constraint failed
        return {
          errors: [
            {
              field: "user",
              message: "User does not exist",
            },
          ],
        }
      }
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

export { TrackerResolver }
