import { Stack } from "@mui/material"
import React from "react"
import spencer from "../public/images/spencer.jpeg"
import chris from "../public/images/chris.jpg"
import { Teammate, TeammateProps } from "@/components/teammate"

const TEAMMATES: TeammateProps[] = [
  {
    name: "Spencer",
    role: "Lead Developer",
    img: spencer,
    links: [
      {
        id: "github",
        href: "https://github.com/spenpo",
      },
      {
        id: "twitter",
        href: "https://twitter.com/sp3npo",
      },
      {
        id: "web",
        href: "https://spenpo.com",
      },
      {
        id: "mail",
        href: "mailto:spenpo@spenpo.com",
      },
    ],
  },
  {
    name: "Chris",
    role: "Developer",
    img: chris,
    links: [
      {
        id: "github",
        href: "https://github.com/ChrisShep98",
      }
    ],
  },
]

export default function Team() {
  return (
    <Stack
      direction={{ md: "row", sm: "column-reverse", xs: "column-reverse" }}
      rowGap={5}
      justifyContent="center"
      py={8}
      columnGap={10}
    >
      {TEAMMATES.map((teammate) => (
        <Teammate key={teammate.name} {...teammate} />
      ))}
    </Stack>
  )
}
