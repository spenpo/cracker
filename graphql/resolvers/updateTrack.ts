import { Arg, Ctx, Mutation, Resolver } from "type-graphql"
import { UpdateTrackerInput } from "../schemas/track/updateTrackerInput"
import { TrackerResponse } from "../schemas/track/trackerResponse"
import { authOptions } from "@/pages/api/auth/[...nextauth]"
import { type MyContext } from "@/pages/api/graphql"
import { deleteNlpCache } from "@/utils/redis"
import { getServerSession } from "next-auth"
import prisma from "@/utils/prisma"

@Resolver(TrackerResponse)
class UpdateTrackerResolver {
  @Mutation(() => TrackerResponse)
  async updateTrack(
    @Arg("tracker", () => UpdateTrackerInput) tracker: UpdateTrackerInput,
    @Ctx() { req, res }: MyContext
  ): Promise<TrackerResponse> {
    const { overview, numberCreativeHours, rating, id } = tracker
    const {
      user: { id: user },
    } = await getServerSession(req, res, authOptions)
    await deleteNlpCache(user)

    try {
      const updatedTracker = await prisma.tracker.update({
        where: {
          id: Number(id),
        },
        data: {
          overview,
          number_creative_hours: numberCreativeHours,
          rating,
        },
      })

      return {
        track: {
          id: updatedTracker.id.toString(),
          overview: updatedTracker.overview,
          numberCreativeHours: Number(updatedTracker.number_creative_hours),
          rating: updatedTracker.rating,
          user: updatedTracker.user.toString(),
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

export { UpdateTrackerResolver }
