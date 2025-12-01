import { AppBar, Box, Button, Stack, Typography, IconButton, Drawer, Divider } from "@mui/material"
import MenuIcon from "@mui/icons-material/Menu"
import CloseIcon from "@mui/icons-material/Close"
import { useSession } from "next-auth/react"
import Link from "next/link"
import Image from "next/image"
import { useRouter } from "next/router"
import { useState } from "react"
import AvatarMenu from "./avatarMenu"
import cracker from "../public/images/cracker.svg"
import { NavbarItem } from "./navbarItem"

export default function Navbar() {
  const router = useRouter()
  const session = useSession()
  const [mobileOpen, setMobileOpen] = useState(false)

  const navLinks = [
    { title: "track" },
    { title: "about" },
    { title: "docs", href: "https://docs.cracker.my.id" },
    { title: "team" },
  ]

  const handleDrawerToggle = () => {
    setMobileOpen((prev) => !prev)
  }

  const closeDrawer = () => setMobileOpen(false)

  const renderAuthControls = (variant: "desktop" | "mobile") => {
    if (session.status === "authenticated") {
      return (
        <Box
          p={variant === "desktop" ? 1 : 0}
          display="flex"
          justifyContent={variant === "desktop" ? "flex-end" : "center"}
        >
          <AvatarMenu />
        </Box>
      )
    }

    return (
      <Button
        size="small"
        variant="outlined"
        onClick={() => {
          router.push("/register")
          if (variant === "mobile") closeDrawer()
        }}
        fullWidth={variant === "mobile"}
        sx={{
          borderRadius: "35px",
          border: "1px solid lightgrey",
          textTransform: "none",
          color: "#6273b3",
          "&:hover": {
            backgroundColor: "#F1F1F1",
          },
        }}
      >
        <Typography color="#6273b3">Get Started</Typography>
      </Button>
    )
  }

  return (
    <AppBar
      className={"animate__animated animate__fadeIn"}
      position="static"
      sx={{ backgroundColor: "white", boxShadow: "none", borderBottom: "1px solid #f0f0f0" }}
    >
      <Box
        component="nav"
        display="flex"
        alignItems="center"
        justifyContent="space-between"
        flexWrap="wrap"
        maxWidth="1200px"
        mx="auto"
        px={{ xs: 2, md: 4 }}
        py={{ xs: 2, md: 1 }}
        gap={2}
        sx={{ width: "100%", boxSizing: "border-box" }}
      >
        <Box display="flex" borderRadius={"35px"} px={2} alignItems="center">
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
        <Stack
          component="ul"
          display={{ xs: "none", md: "flex" }}
          flexDirection={{ xs: "column", sm: "row" }}
          alignItems={{ xs: "stretch", sm: "center" }}
          justifyContent="center"
          spacing={{ xs: 1, sm: 0 }}
          sx={{
            listStyleType: "none",
            p: 0,
            m: 0,
            width: { xs: "100%", md: "auto" },
          }}
        >
          {navLinks.map((link) => (
            <NavbarItem key={link.title} title={link.title} href={link.href} />
          ))}
        </Stack>
        <Box
          display="flex"
          alignItems="center"
          justifyContent="flex-end"
          width={{ xs: "100%", md: "auto" }}
          sx={{ display: { xs: "none", md: "flex" } }}
        >
          {renderAuthControls("desktop")}
        </Box>
        <IconButton
          edge="end"
          aria-label="open navigation"
          onClick={handleDrawerToggle}
          sx={{ display: { xs: "flex", md: "none" }, marginLeft: "auto" }}
        >
          <MenuIcon htmlColor="#6273b3" />
        </IconButton>
      </Box>
      <Drawer
        anchor="right"
        open={mobileOpen}
        onClose={closeDrawer}
        ModalProps={{ keepMounted: true }}
        PaperProps={{
          sx: {
            width: 300,
            px: 3,
            py: 2,
            display: "flex",
            flexDirection: "column",
            gap: 2,
            height: "100%",
            boxSizing: "border-box",
            pb: "calc(env(safe-area-inset-bottom, 0px) + 16px)",
          },
        }}
      >
        <Box display="flex" alignItems="center" justifyContent="space-between">
          <Typography variant="h6" color="primary.main" fontWeight={600}>
            cracker
          </Typography>
          <IconButton aria-label="close navigation" onClick={closeDrawer}>
            <CloseIcon />
          </IconButton>
        </Box>
        <Stack
          component="ul"
          spacing={1}
          sx={{
            listStyleType: "none",
            p: 0,
            m: 0,
            flexGrow: 1,
            overflowY: "auto",
          }}
        >
          {navLinks.map((link) => (
            <NavbarItem
              key={`mobile-${link.title}`}
              title={link.title}
              href={link.href}
              onClick={closeDrawer}
            />
          ))}
        </Stack>
        <Divider />
        {renderAuthControls("mobile")}
      </Drawer>
    </AppBar>
  )
}
