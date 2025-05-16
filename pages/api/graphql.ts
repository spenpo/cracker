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

const server = new ApolloServer({ schema })

export type MyContext = {
  req: NextApiRequest
  res: NextApiResponse
}

export default startServerAndCreateNextHandler(server, {
  context: async (req, res): Promise<MyContext> => ({
    req,
    res,
  }),
})
