import { Query, Resolver } from "type-graphql"
import { FeatureFlag } from "../schemas"
import prisma from "@/utils/prisma"

@Resolver()
class FeatureFlagsResolver {
  @Query(() => [FeatureFlag])
  async featureFlags(): Promise<FeatureFlag[]> {
    const featureFlags = await prisma.feature_flag.findMany({
      include: {
        role_lookup: true,
      },
    })

    return featureFlags.map((flag) => ({
      id: flag.id.toString(),
      name: flag.name,
      description: flag.description,
      isEnabled: flag.is_enabled,
      requiredRole: flag.required_role,
    }))
  }
}

export { FeatureFlagsResolver }
