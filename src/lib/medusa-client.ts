import Medusa from "@medusajs/js-sdk"

// Initialize Medusa client
export const medusa = new Medusa({
  baseUrl: process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL || "http://localhost:9000",
  debug: process.env.NODE_ENV === "development",
  publishableKey: process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || "",
})

// Region IDs
export const REGIONS = {
  EUROPE: "reg_01K9FZ96V1AT4PGR95NE8VYZ8N",      // EUR - Europe
  ARGENTINA: "reg_01JCARGENTINA2025",            // ARS - Argentina
} as const

// Default region ID - Argentina (ARS)
// Cambiar a REGIONS.EUROPE si necesitás usar EUR
const DEFAULT_REGION_ID = REGIONS.ARGENTINA

/**
 * Fetch a product by its handle from Medusa API
 */
export async function getProductByHandle(handle: string, regionId: string = DEFAULT_REGION_ID) {
  try {
    // First get the product with basic info
    const response = await medusa.store.product.list({
      handle,
      region_id: regionId,
      fields: "*variants,*variants.calculated_price,*images",
    })

    if (!response.products || response.products.length === 0) {
      return null
    }

    const product = response.products[0]

    // Medusa v2 doesn't return metadata by default in store API
    // We need to fetch it separately using our custom API route that queries the database directly
    try {
      const metadataResponse = await fetch(`http://localhost:4444/api/product-metadata/${handle}`)

      if (metadataResponse.ok) {
        const data = await metadataResponse.json()
        if (data.metadata) {
          product.metadata = data.metadata
        }
      }
    } catch (metadataError) {
      console.warn("Could not fetch metadata:", metadataError)
      // Continue without metadata rather than failing
    }

    return product
  } catch (error) {
    console.error("Error fetching product:", error)
    return null
  }
}

/**
 * Convert Medusa price from cents to dollars
 */
export function convertCentsToDollars(cents: number): number {
  return cents / 100
}

/**
 * Get the price for a variant (handles calculated_price structure)
 * Fallback: If calculated_price is null, fetch price directly from database
 */
export async function getVariantPrice(variant: any) {
  const calculatedPrice = variant.calculated_price

  // If calculated_price exists, use it
  if (calculatedPrice && calculatedPrice.calculated_amount) {
    const priceWithoutTax = convertCentsToDollars(
      calculatedPrice.calculated_amount || 0
    )
    const priceWithTax = convertCentsToDollars(
      calculatedPrice.calculated_amount_with_tax || calculatedPrice.calculated_amount || 0
    )

    return {
      priceWithoutTax,
      priceWithTax,
      currency: calculatedPrice.currency_code?.toUpperCase() || "USD",
    }
  }

  // Fallback: Fetch price directly from database when calculated_price is null
  // This is needed because Medusa v2 Store API doesn't always return calculated_price
  try {
    const priceResponse = await fetch(`http://localhost:4444/api/product-prices/${variant.id}`)

    if (priceResponse.ok) {
      const priceData = await priceResponse.json()
      if (priceData.amount && priceData.currency_code) {
        const price = convertCentsToDollars(priceData.amount)
        return {
          priceWithoutTax: price,
          priceWithTax: price,
          currency: priceData.currency_code.toUpperCase(),
        }
      }
    }

    // If fetch fails, return zero
    console.warn("Could not fetch price from database for variant:", variant.id)
    return { priceWithoutTax: 0, priceWithTax: 0, currency: "USD" }
  } catch (error) {
    console.error("Error getting variant price:", error)
    return { priceWithoutTax: 0, priceWithTax: 0, currency: "USD" }
  }
}
