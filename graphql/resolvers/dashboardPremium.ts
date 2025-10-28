import { authOptions } from "@/pages/api/auth/[...nextauth]"
import { type MyContext } from "@/pages/api/graphql"
import { getServerSession } from "next-auth"
import { Arg, Ctx, Query, Resolver } from "type-graphql"
import { PremiumDashboardResponse } from "../schemas/dashboard"
import { Track } from "../schemas/track"
import language from "@google-cloud/language"
import redis from "@/utils/redis"
import { CACHE_KEYS } from "@/constants"
import prisma from "@/utils/prisma"

@Resolver(PremiumDashboardResponse)
export class PremiumDashboardReslover {
  @Query(() => PremiumDashboardResponse)
  async dashboard(
    @Arg("runningAvg", () => String!) runningAvg: string,
    @Ctx() { req, res }: MyContext
  ): Promise<PremiumDashboardResponse> {
    const {
      user: { id: user },
    } = await getServerSession(req, res, authOptions)

    const fetchRawData = async (): Promise<Track[]> => {
      try {
        // Calculate the date X days ago
        const daysAgo = new Date()
        daysAgo.setDate(daysAgo.getDate() - parseInt(runningAvg))

        const trackers = await prisma.tracker.findMany({
          where: {
            user: Number(user),
            created_at: {
              gt: daysAgo,
            },
          },
        })

        return trackers.map((tracker) => ({
          numberCreativeHours: Number(tracker.number_creative_hours),
          rating: Number(tracker.rating),
          overview: tracker.overview.toLowerCase(),
          createdAt: tracker.created_at?.toISOString() || "",
          id: tracker.id.toString(),
        }))
      } catch (e) {
        console.log(e)
        return []
      }
    }

    const rawData = await fetchRawData()

    const fetchNlpData = async () => {
      let credentials = null

      if (process.env.GCP_CRED)
        credentials = JSON.parse(
          Buffer.from(process.env.GCP_CRED, "base64").toString()
        )

      const client = new language.LanguageServiceClient({ credentials })

      const overviews = rawData.map((track) => track.overview).join(" ")

      const document = {
        content: overviews,
        type: "PLAIN_TEXT" as "PLAIN_TEXT",
      }

      const features = {
        extractSyntax: true,
        extractEntities: true,
        extractDocumentSentiment: true,
        extractEntitySentiment: true,
      }

      const [annotate] = await client.annotateText({ document, features })

      const nlpData = {
        sentences: annotate.sentences,
        tokens: annotate.tokens,
        entities: annotate.entities,
      }

      await redis.set(
        `${CACHE_KEYS.premiumDashboard}/${user}/${runningAvg}`,
        JSON.stringify(nlpData)
      )

      return nlpData
    }

    const cachedNlpData = await redis.get(
      `${CACHE_KEYS.premiumDashboard}/${user}/${runningAvg}`
    )

    if (cachedNlpData) {
      const nlpData = JSON.parse(cachedNlpData)
      return {
        dashboard: {
          rawData,
          sentences: nlpData.sentences,
          entities: nlpData.entities,
          tokens: nlpData.tokens,
        },
      }
    } else {
      const { sentences, entities, tokens } = await fetchNlpData()
      return {
        dashboard: {
          rawData,
          sentences,
          entities,
          tokens,
        },
      }
    }
  }
}
