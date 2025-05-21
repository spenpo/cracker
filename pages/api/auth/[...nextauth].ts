import prisma from "@/utils/prisma"
import argon2 from "argon2"
import NextAuth from "next-auth"
import CredentialsProvider from "next-auth/providers/credentials"

export const authOptions = {
  // Configure one or more authentication providers
  providers: [
    CredentialsProvider({
      // The name to display on the sign in form (e.g. 'Sign in with...')
      name: "Credentials",
      // The credentials is used to generate a suitable form on the sign in page.
      // You can specify whatever fields you are expecting to be submitted.
      // e.g. domain, username, password, 2FA token, etc.
      // You can pass any HTML attribute to the <input> tag through the object.
      credentials: {
        username: { label: "Username", type: "text" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        try {
          const user = await prisma.user.findUnique({
            where: {
              username: credentials?.username,
            },
            select: {
              id: true,
              password: true,
              role: true,
            },
          })

          if (!user) return null

          const correctPassword = await argon2.verify(
            user.password,
            credentials!.password
          )
          if (!correctPassword) return null

          return {
            id: user.id.toString(),
            role: user.role,
          }
        } catch (error) {
          console.error(error)
          return null
        }
      },
    }),
    // ...add more providers here
  ],
  callbacks: {
    async redirect({ baseUrl }: any) {
      // Allows relative callback URLs
      // Allows callback URLs on the same origin
      return baseUrl
    },
    async jwt({ token, user }: any) {
      if (user) token.user = user
      return token
    },
    async session({ session, token }: any) {
      session.user = token.user
      return session
    },
  },
  pages: {
    signIn: "/",
  },
}
export default NextAuth(authOptions)
