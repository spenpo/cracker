import { PgQueryError, PgQueryResponse } from "@/types"
import { pool } from "@/utils/postgres"
import { postgresErrorDetails } from "@/utils/stringUtils"
import argon2 from "argon2"
import { Arg, Mutation, Resolver } from "type-graphql"
import { UserInput, RegisterResponse, User } from "../schemas"

@Resolver(RegisterResponse)
class RegistrationResolver {
  @Mutation(() => RegisterResponse)
  async register(
    @Arg("user", () => UserInput) user: UserInput
  ): Promise<RegisterResponse> {
    const hashedPassword = await argon2.hash(user.password, {
      type: argon2.argon2id, // Explicitly set to argon2id
      memoryCost: 65536, // 64MB
      timeCost: 3,
      parallelism: 4,
      hashLength: 32, // 32 bytes (256 bits)
      saltLength: 16, // 16 bytes (standard argon2 salt length)
    })
    const res: Promise<RegisterResponse> = await pool
      .query(
        `INSERT INTO "user" (email, username, password)
       VALUES (
        $1,
        $2,
        $3
        ) RETURNING *;`,
        [user.email, user.username, hashedPassword]
      )
      .then((queryRes: PgQueryResponse<User>) => {
        const { id, username, email, role } = queryRes.rows[0]
        return {
          user: {
            id,
            username,
            email,
            role,
          },
        }
      })
      .catch((e: PgQueryError) => {
        if (e.code === "23505") {
          const details = postgresErrorDetails(e.detail)
          return {
            errors: [
              {
                field: details[1],
                message: `individual with username: ${user.username} and email: ${user.email} is a duplicate member. ${details[1]} ${details[3]} is already in use.`,
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
      })
    return res
  }
}

export { RegistrationResolver }
