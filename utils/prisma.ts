import { PrismaClient as EdgePrismaClient } from '@prisma/client/edge'
import { PrismaClient as RegularPrismaClient } from '@prisma/client'
import { withAccelerate } from '@prisma/extension-accelerate'

// Learn more about instantiating PrismaClient in Next.js here: https://www.prisma.io/docs/data-platform/accelerate/getting-started

const prismaClientSingleton = () => {
  if (process.env.NODE_ENV === 'production') {
    const client = new EdgePrismaClient()
    return client.$extends(withAccelerate()) as unknown as RegularPrismaClient
  }
  return new RegularPrismaClient()
}

declare const globalThis: {
  prismaGlobal: RegularPrismaClient
} & typeof global

const prisma = globalThis.prismaGlobal ?? prismaClientSingleton()

export default prisma

if (process.env.NODE_ENV !== 'production') globalThis.prismaGlobal = prisma
