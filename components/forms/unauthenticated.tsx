import { Typography, Button, Stack, Box } from "@mui/material"
import React from "react"
import { SignIn } from "./signIn"
import { IntroDescription } from "./IntroDescription"
import { useRouter } from "next/router"

export const Unauthenticated: React.FC = () => {
  const router = useRouter()

  return (
    <Stack
      direction={{ xs: "column", md: "row" }}
      spacing={{ xs: 4, md: 8 }}
      alignItems={{ xs: "center", md: "flex-start" }}
      justifyContent="center"
    >
      <IntroDescription />
      <Box
        className={"animate__animated animate__backInRight"}
        mt={{ xs: 2, md: 5 }}
        width={{ xs: "100%", sm: "80%", md: "auto" }}
        maxWidth={420}
      >
        <SignIn />
        <Typography textAlign={{ xs: "center", md: "left" }} mt={2}>
          not a member?{" "}
          <Button onClick={() => router.push("/register")}>sign up</Button>
        </Typography>
      </Box>
    </Stack>
  )
}
