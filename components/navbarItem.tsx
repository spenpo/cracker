import { Box, Typography } from "@mui/material"
import Link from "next/link"
import { useRouter } from "next/router"
import React from "react"

export const NavbarItem: React.FC<{ title: string, href?: string }> = ({ title, href }) => {
  const router = useRouter()

  return (
    <Box
      component="li"
      px={3}
      py={1}
      m={1}
      borderRadius={"35px"}
      sx={{
        backgroundColor: router.pathname === `/${title}` ? "primary.main" : "white",
        "&:hover": {
          backgroundColor: "#F1F1F1",
        },
      }}
    >
      <Link href={href || `/${title}`} style={{ textDecoration: "none" }}>
        <Typography
          color={router.pathname === `/${title}` ? "#fff" : "#6273b3"}
          letterSpacing={"0.10rem"}
        >
          {title}
        </Typography>
      </Link>
    </Box>
  )
}
