import { Box, Typography } from "@mui/material"
import Image from "next/image"
import Link from "next/link"
import github from "../public/images/github.svg"

export default function Footer() {
  return (
    <Box component="footer" width="100%" sx={{ backgroundColor: "#8a8c8e" }} mt="auto">
      <Box
        display="flex"
        flexDirection={{ xs: "column", sm: "row" }}
        alignItems="center"
        justifyContent={{ xs: "center", sm: "space-between" }}
        gap={2}
        width="100%"
        maxWidth="1200px"
        mx="auto"
        px={{ xs: 2, md: 4 }}
        py={3}
        sx={{ boxSizing: "border-box" }}
      >
        <Box
          component="ul"
          sx={{
            listStyleType: "none",
            m: 0,
            p: 0,
            display: "flex",
            justifyContent: "center",
          }}
        >
          <Box component="li">
            <Link
              href="https://github.com/spenpo/cracker"
              target="_blank"
              rel="noreferrer"
            >
              <Image src={github} width={30} height={30} alt="github" />
            </Link>
          </Box>
        </Box>
        <Box textAlign={{ xs: "center", sm: "right" }}>
          <Typography component="span" color="#fff" fontSize={{ xs: "0.9rem", md: "1rem" }}>
            © 2025 The Reflective Hour
          </Typography>
        </Box>
      </Box>
    </Box>
  )
}
