import { NextRequest, NextResponse } from "next/server"
import { Pool } from "pg"

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || "postgresql://postgres:postgres123@localhost:5432/medusa-backend",
})

// GET /api/product-filters - Returns all filterable fields across products
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const category = searchParams.get('category') // Optional filter by category

    // Get all products with metadata
    const result = await pool.query(
      "SELECT handle, metadata FROM product WHERE status = 'published' AND metadata IS NOT NULL"
    )

    if (result.rows.length === 0) {
      return NextResponse.json({ filters: {}, products_count: 0 })
    }

    // Extract filterable fields
    const filters: Record<string, Set<string>> = {}

    for (const row of result.rows) {
      const metadata = row.metadata
      if (!metadata) continue

      // Process each category
      for (const catKey in metadata) {
        if (category && catKey !== category) continue
        
        const catData = metadata[catKey]
        if (typeof catData !== 'object') continue

        // Process fields in category
        for (const fieldKey in catData) {
          const field = catData[fieldKey]
          if (typeof field !== 'object' || !field.filtrable) continue

          const filterKey = `${catKey}.${fieldKey}`
          if (!filters[filterKey]) {
            filters[filterKey] = new Set()
          }

          // Add classification value or actual value
          const value = field.clasificacion || field.valor
          if (value !== undefined && value !== null) {
            filters[filterKey].add(String(value))
          }
        }
      }
    }

    // Convert Sets to arrays and sort
    const filterArrays: Record<string, string[]> = {}
    for (const key in filters) {
      filterArrays[key] = Array.from(filters[key]).sort()
    }

    return NextResponse.json({
      success: true,
      filters: filterArrays,
      products_count: result.rows.length,
      categories: category ? [category] : [...new Set(result.rows.flatMap(r => Object.keys(r.metadata || {})))],
    })
  } catch (error) {
    console.error("Error fetching filters:", error)
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    )
  }
}
