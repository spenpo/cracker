import { Arg, Int, Query, Resolver } from "type-graphql"
import { GetMentions } from "../schemas/dashboard"
import { Track } from "../schemas"
import prisma from "@/utils/prisma"

@Resolver(GetMentions)
export class WordMentions {
  @Query(() => GetMentions)
  async getWordMentions(
    @Arg("mentions", () => [Int]) mentions: number[]
  ): Promise<GetMentions> {
    try {
      const trackers = await prisma.tracker.findMany({
        where: {
          id: {
            in: mentions,
          },
        },
      })

      const wordMentions: Track[] = trackers.map((tracker) => ({
        id: tracker.id.toString(),
        overview: tracker.overview,
        rating: tracker.rating,
        numberCreativeHours: Number(tracker.number_creative_hours),
        createdAt: tracker.created_at?.toISOString() || "",
      }))

      return { mentions: wordMentions }
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
