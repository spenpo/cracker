import { PrismaClient } from "@prisma/client"
import argon2 from "argon2"
import { Arg, Mutation, Resolver } from "type-graphql"
import { UserInput, RegisterResponse } from "../schemas"

const prisma = new PrismaClient()

@Resolver(RegisterResponse)
class RegistrationResolver {
  @Mutation(() => RegisterResponse)
  async register(
    @Arg("user", () => UserInput) user: UserInput
  ): Promise<RegisterResponse> {
    const hashedPassword = await argon2.hash(user.password)
    
    try {
      const newUser = await prisma.user.create({
        data: {
          email: user.email,
          username: user.username,
          password: hashedPassword,
        },
      })

      const { id, username, email, role } = newUser
      return {
        user: {
          id: id.toString(),
          username,
          email,
          role: role || 1, // Default to role 1 if null
        },
      }
    } catch (e: any) {
      if (e.code === 'P2002') {
        // Prisma's unique constraint violation error code
        const field = e.meta?.target?.[0] || 'unknown'
        return {
          errors: [
            {
              field,
              message: `individual with username: ${user.username} and email: ${user.email} is a duplicate member. ${field} is already in use.`,
            },
          ],
        }
      } else {
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
}

export { RegistrationResolver }
