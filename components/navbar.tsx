import { AppBar, Box, Button, Stack, Typography } from "@mui/material"
import { useSession } from "next-auth/react"
import Link from "next/link"
import Image from "next/image"
import { useRouter } from "next/router"
import AvatarMenu from "./avatarMenu"
import cracker from "../public/images/cracker.svg"
import { NavbarItem } from "./navbarItem"

export default function Navbar() {
  const router = useRouter()
  const session = useSession()

  return (
    <AppBar
      className={"animate__animated animate__fadeIn"}
      position="static"
      sx={{ backgroundColor: "white", boxShadow: "none" }}
    >
      <Box
        component="ul"
        display="flex"
        justifyContent={"space-evenly"}
        p={0}
        overflow="hidden"
        sx={{ listStyleType: "none" }}
      >
        <Box display="flex" borderRadius={"35px"} px={2}>
          <Link
            href="/"
            style={{
              textDecoration: "none",
              display: "flex",
              alignItems: "center",
            }}
          >
            <Typography
              variant="h5"
              m={0}
              color="primary.main"
              fontWeight={"600"}
              display={{ xs: "none", sm: "block" }}
            >
              cracker
            </Typography>
            <Image
              src={cracker}
              height={50}
              width={50}
              alt="cracker"
              style={{
                backgroundColor: "#fff",
              }}
            />
          </Link>
        </Box>
        <Stack flexDirection={"row"} alignItems={"center"}>
          <NavbarItem title="track" />
          <NavbarItem title="about" />
          <NavbarItem title="team" />
          <NavbarItem title="docs" href="https://docs.cracker.my.id" />
        </Stack>
        {session.status === "authenticated" && (
          <Box p={1}>
            <AvatarMenu />
          </Box>
        )}
        {session.status === "unauthenticated" && (
          <Button
            size="small"
            variant="outlined"
            onClick={() => router.push("/register")}
            sx={{
              borderRadius: "35px",
              border: "1px solid lightgrey",
              textTransform: "none",
              color: "#F1F1F1",
              margin: 2,
              "&hover": {
                backgroundColor: "#F1F1F1",
              },
            }}
          >
            <Typography color="#6273b3">Get Started</Typography>
          </Button>
        )}
      </Box>
    </AppBar>
  )
}
