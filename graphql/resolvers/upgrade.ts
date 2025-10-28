import { authOptions } from "@/pages/api/auth/[...nextauth]"
import { type MyContext } from "@/pages/api/graphql"
import { deleteNlpCache } from "@/utils/redis"
import { getServerSession } from "next-auth"
import { Ctx, Mutation, Resolver } from "type-graphql"
import prisma from "@/utils/prisma"

@Resolver(String)
class UpgradeResolver {
  @Mutation(() => String)
  async upgrade(@Ctx() { req, res }: MyContext): Promise<string> {
    const {
      user: { id: user },
    } = await getServerSession(req, res, authOptions)
    await deleteNlpCache(user)

    try {
      await prisma.user.update({
        where: {
          id: Number(user),
        },
        data: {
          role: 2,
        },
      })
      return "Your account has been upgraded to premium!"
    } catch (e) {
      console.log(e)
      return "Something is wrong. Please contact us."
    }
  }
}

export { UpgradeResolver }
