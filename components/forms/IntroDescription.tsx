import { Stack, Typography } from "@mui/material"
import React from "react"

export const IntroDescription = () => {
  return (
    <Stack
      className={"animate__animated animate__backInLeft"}
      maxWidth={{ xs: "100%", md: "500px" }}
      spacing={2}
      textAlign={{ xs: "center", md: "left" }}
      px={{ xs: 2, md: 0 }}
      alignItems={{ xs: "center", md: "flex-start" }}
    >
      <Typography
        variant="h2"
        color={"#4162ff"}
        fontWeight={"600"}
        fontSize={{ xs: "2.25rem", sm: "2.75rem", md: "3.5rem" }}
        lineHeight={1.1}
      >
        Unlock Your Productivity Potential
      </Typography>

      <Typography
        variant="h5"
        fontSize={{ xs: "1.1rem", sm: "1.3rem", md: "1.5rem" }}
        color="text.secondary"
      >
        Rate, Reflect, Improve with cracker Powered by Google Cloud AI!
      </Typography>
    </Stack>
  )
}
