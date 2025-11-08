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
    const { id: variantId } = await params

    // Query the database directly for variant prices
    const result = await pool.query(
      `SELECT
        pr.amount,
        pr.currency_code
      FROM product_variant v
      JOIN product_variant_price_set pvps ON v.id = pvps.variant_id
      JOIN price_set ps ON pvps.price_set_id = ps.id
      JOIN price pr ON ps.id = pr.price_set_id
      WHERE v.id = $1
      LIMIT 1`,
      [variantId]
    )

    if (result.rows.length === 0) {
      return NextResponse.json(
        { error: "Variant not found or no price set" },
        { status: 404 }
      )
    }

    const price = result.rows[0]

    return NextResponse.json({
      amount: price.amount,
      currency_code: price.currency_code,
    })
  } catch (error) {
    console.error("Error fetching variant price:", error)
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    )
  }
}
