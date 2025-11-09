import { getVariantPrice } from "./medusa-client"

/**
 * Enrich variant data with pricing information
 * Takes raw variant data from Medusa and adds formatted price data
 */
export async function enrichVariantWithPrice(variant: any) {
  const priceData = await getVariantPrice(variant)

  return {
    id: variant.id,
    title: variant.title,
    sku: variant.sku,
    price: priceData,
    metadata: variant.metadata || {},
    weight: variant.weight,
    length: variant.length,
    width: variant.width,
    height: variant.height,
  }
}

/**
 * Enrich multiple variants with pricing information
 */
export async function enrichVariantsWithPrices(variants: any[]) {
  if (!variants || variants.length === 0) {
    return []
  }

  const enrichedVariants = await Promise.all(
    variants.map((variant) => enrichVariantWithPrice(variant))
  )

  return enrichedVariants
}

/**
 * Format variant options for display
 * Extracts the configuration option (Abierto/Silent) from variant options
 */
export function getVariantConfiguration(variant: any): string {
  if (!variant.options) return ""

  // Look for "Configuración" option
  const configOption = variant.options.find(
    (opt: any) => opt.title === "Configuración"
  )

  return configOption?.value || ""
}

/**
 * Check if a product has meaningful variants
 * (more than one variant, or variants with different configurations)
 */
export function hasVariants(variants: any[]): boolean {
  if (!variants || variants.length <= 1) {
    return false
  }

  // Check if variants actually differ in configuration
  const configs = variants.map((v) => getVariantConfiguration(v))
  const uniqueConfigs = new Set(configs)

  return uniqueConfigs.size > 1
}
