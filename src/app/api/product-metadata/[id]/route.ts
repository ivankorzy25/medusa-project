import { NextRequest, NextResponse } from "next/server"
import { Pool } from "pg"

// Create a PostgreSQL connection pool
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
})

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    // In Next.js 16, params is a Promise and must be awaited
    const { id: identifier } = await params

    // Query by ID or handle
    const result = await pool.query(
      "SELECT id, handle, title, metadata FROM product WHERE id = $1 OR handle = $1",
      [identifier]
    )

    if (result.rows.length === 0) {
      return NextResponse.json(
        { error: "Product not found", identifier },
        { status: 404 }
      )
    }

    const product = result.rows[0]
    const metadata = product.metadata || {}

    // Return structured response with categories
    return NextResponse.json({
      success: true,
      product: {
        id: product.id,
        handle: product.handle,
        title: product.title,
      },
      metadata: metadata,
      // Helper: list of available categories
      categorias: Object.keys(metadata).filter(k => typeof metadata[k] === 'object'),
      // Helper: count of fields
      total_campos: countFields(metadata),
    })
  } catch (error) {
    console.error("Error fetching product metadata:", error)
    return NextResponse.json(
      { error: "Internal server error", details: String(error) },
      { status: 500 }
    )
  }
}

// Helper function to count all fields recursively
function countFields(obj: Record<string, unknown>, count = 0): number {
  for (const key in obj) {
    if (typeof obj[key] === 'object' && obj[key] !== null && !Array.isArray(obj[key])) {
      const nested = obj[key] as Record<string, unknown>
      if (nested.valor !== undefined) {
        count++
      } else {
        count = countFields(nested, count)
      }
    }
  }
  return count
}
