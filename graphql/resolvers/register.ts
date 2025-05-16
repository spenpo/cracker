import type { MyContext } from "@/pages/api/graphql"
import argon2 from "argon2"
import { Arg, Ctx, Mutation, Resolver } from "type-graphql"
import { UserInput, RegisterResponse } from "../schemas"

@Resolver(RegisterResponse)
class RegistrationResolver {
  @Mutation(() => RegisterResponse)
  async register(
    @Arg("user", () => UserInput) user: UserInput,
    @Ctx() { prisma }: MyContext
  ): Promise<RegisterResponse> {
    console.log('Starting registration process...')
    const hashedPassword = await argon2.hash(user.password)
    
    try {
      console.log('Attempting to create user...')
      const newUser = await prisma.user.create({
        data: {
          email: user.email,
          username: user.username,
          password: hashedPassword,
        },
      })
      console.log('User created successfully')

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
      console.error('Registration error:', {
        code: e.code,
        message: e.message,
        meta: e.meta
      })
      
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
