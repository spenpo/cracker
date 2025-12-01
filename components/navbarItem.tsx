import { Box, Typography } from "@mui/material"
import Link from "next/link"
import { useRouter } from "next/router"
import React from "react"

export const NavbarItem: React.FC<{
  title: string
  href?: string
  onClick?: () => void
}> = ({ title, href, onClick }) => {
  const router = useRouter()

  return (
    <Box
      component="li"
      px={{ xs: 2, sm: 3 }}
      py={1}
      m={{ xs: 0, sm: 1 }}
      borderRadius={"35px"}
      width={{ xs: "100%", sm: "auto" }}
      textAlign="center"
      onClick={onClick}
      sx={{
        backgroundColor: router.pathname === `/${title}` ? "primary.main" : "white",
        transition: "background-color 150ms ease",
        "&:hover": {
          backgroundColor: "#F1F1F1",
        },
      }}
    >
      <Link
        href={href || `/${title}`}
        style={{
          textDecoration: "none",
          display: "flex",
          justifyContent: "center",
        }}
      >
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
