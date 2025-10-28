import { authOptions } from "@/pages/api/auth/[...nextauth]"
import { type MyContext } from "@/pages/api/graphql"
import { getServerSession } from "next-auth"
import { Arg, Ctx, Mutation, Resolver } from "type-graphql"
import { TrackerInput, UploadTrackerResponse } from "../schemas/track"
import { deleteNlpCache } from "@/utils/redis"
import prisma from "@/utils/prisma"

@Resolver(UploadTrackerResponse)
class UploadTrackerResolver {
  @Mutation(() => UploadTrackerResponse)
  async uploadTracker(
    @Arg("data", () => [TrackerInput]) data: TrackerInput[],
    @Ctx() { req, res }: MyContext
  ): Promise<UploadTrackerResponse> {
    const {
      user: { id: user },
    } = await getServerSession(req, res, authOptions)
    await deleteNlpCache(user)

    try {
      await prisma.$transaction(async (tx) => {
        for (let idx = 0; idx < data.length; idx++) {
          const item = data[idx]
          const { overview, numberCreativeHours, rating } = item
          const today = new Date()
          today.setDate(today.getDate() - (idx + 1))

          await tx.tracker.create({
            data: {
              overview,
              number_creative_hours: numberCreativeHours,
              rating,
              created_at: today,
              user: Number(user),
            },
          })
        }
      })

      return {
        uploaded: `successfully uploaded ${data.length} days worth of data`,
      }
    } catch (e: any) {
      console.log(e)
      if (e.code === "P2003") {
        // Foreign key constraint failed
        return {
          errors: [
            {
              field: "user",
              message: `User does not exist`,
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

export { UploadTrackerResolver }
