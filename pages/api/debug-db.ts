// pages/api/debug-db.ts
import { NextApiRequest, NextApiResponse } from "next";

export default function handler(_req: NextApiRequest, res: NextApiResponse) {
    res.json({ hasDatabaseUrl: !!process.env.DATABASE_URL });
}