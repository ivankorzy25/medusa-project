import { NextRequest, NextResponse } from "next/server"
import { Pool } from "pg"

// Create a PostgreSQL connection pool
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || "postgresql://ivankorzyniewski@localhost:5432/medusa-store",
})

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    // In Next.js 16, params is a Promise and must be awaited
    const { id: productId } = await params

    // Query the database directly for metadata
    const result = await pool.query(
      "SELECT metadata FROM product WHERE id = $1",
      [productId]
    )

    if (result.rows.length === 0) {
      return NextResponse.json(
        { error: "Product not found" },
        { status: 404 }
      )
    }

    return NextResponse.json({
      metadata: result.rows[0].metadata || {},
    })
  } catch (error) {
    console.error("Error fetching product metadata:", error)
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    )
  }
}
