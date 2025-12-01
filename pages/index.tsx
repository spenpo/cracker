import React, { useState } from "react"
import Head from "next/head"
import { useSession } from "next-auth/react"
import { Box } from "@mui/material"
import PremiumDashboard from "@/components/dashboard/premium"
import BasicDashboard from "@/components/dashboard/basic"
import { Unauthenticated } from "@/components/forms"
import redis from "@/utils/redis"
import { DashboardFilters } from "@/types"
import { NextApiRequest, NextApiResponse } from "next"
import { getServerSession } from "next-auth/next"
import { authOptions } from "./api/auth/[...nextauth]"
import { DashboardFilterContextProvider } from "@/components/dashboard/context"

export async function getServerSideProps({
  req,
  res,
}: {
  req: NextApiRequest
  res: NextApiResponse
}) {
  let dashboardFilters = {}
  const session = await getServerSession(req, res, authOptions)
  if (session)
    dashboardFilters = await redis.hgetall(`dashboardFilters/${session.user.id}`)
  return { props: { dashboardFilters } }
}

export default function Home({
  dashboardFilters,
}: {
  dashboardFilters: DashboardFilters
}) {
  const session = useSession()
  const [premium, setPremium] = useState(
    JSON.parse(dashboardFilters.cachedPremium || "false")
  )

  return (
    <>
      <Head>
        <title>creativity tracker</title>
      </Head>
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        flexDirection="column"
        maxWidth="1200px"
        px={{ xs: 2, md: 4 }}
        py={{ xs: 4, md: 8 }}
        m="auto"
        sx={{ width: "100%", boxSizing: "border-box" }}
      >
        {session.status === "authenticated" ? (
          <DashboardFilterContextProvider
            {...dashboardFilters}
            premium={[premium, setPremium]}
          >
            {premium ? <PremiumDashboard /> : <BasicDashboard />}
          </DashboardFilterContextProvider>
        ) : (
          <Unauthenticated />
        )}
      </Box>
    </>
  )
}
