/**
 * Script para configurar el sistema de pricing multi-canal en Medusa
 *
 * Este script crea:
 * 1. Customer Groups (MercadoLibre, Público, Mayorista)
 * 2. Price Lists para cada grupo
 * 3. Metadata de configuración en productos
 *
 * Ejecutar: npx tsx scripts/setup-pricing-system.ts
 */

import Medusa from "@medusajs/js-sdk"

const MEDUSA_BACKEND_URL = process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL || "http://localhost:9000"
const MEDUSA_PUBLISHABLE_KEY = process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || ""

// IDs conocidos del producto CS200A
const CS200A_PRODUCT_ID = "prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0"
const CS200A_VARIANT_ID = "variant_9173cb95160e3448"

// Configuración de pricing según PDF
const CS200A_CONFIG = {
  precio_lista_usd: 26411,       // Precio del PDF (página 8)
  currency_type: "usd_bna",      // Dólar BNA oficial
  iva_percentage: 10.5,          // Generadores tienen 10.5%
  bonificacion_percentage: 11,   // Cummins CS: 11%
  contado_descuento_percentage: 9, // Cummins CS: 9%
  familia: "Generadores Cummins - Línea CS"
}

async function main() {
  console.log("🚀 Iniciando configuración del sistema de pricing multi-canal\n")

  const medusa = new Medusa({
    baseUrl: MEDUSA_BACKEND_URL,
    debug: true,
    publishableKey: MEDUSA_PUBLISHABLE_KEY,
  })

  console.log("📋 PASO 1: Crear Customer Groups")
  console.log("=" .repeat(60))

  const customerGroups = [
    {
      name: "MercadoLibre",
      metadata: {
        description: "Clientes de MercadoLibre - Precio competitivo",
        channel: "mercadolibre",
        discount_type: "promotional"
      }
    },
    {
      name: "Público General",
      metadata: {
        description: "Clientes de web pública - Precio lista",
        channel: "web",
        discount_type: "none"
      }
    },
    {
      name: "Mayorista",
      metadata: {
        description: "Clientes mayoristas - Contacto directo",
        channel: "direct",
        discount_type: "wholesale"
      }
    }
  ]

  const createdGroups: any = {}

  for (const group of customerGroups) {
    try {
      console.log(`\n📌 Creando grupo: ${group.name}`)

      // Intentar crear el grupo
      // Nota: Necesitaremos auth de admin, por ahora solo mostramos la estructura
      console.log(`   Metadata: ${JSON.stringify(group.metadata, null, 2)}`)
      console.log(`   ⚠️  NOTA: Requiere autenticación de admin - crear manualmente en Admin UI`)
      console.log(`   Admin URL: http://localhost:9000/app/settings/customer-groups`)

    } catch (error: any) {
      console.log(`   ⚠️  Error: ${error.message}`)
    }
  }

  console.log("\n\n📋 PASO 2: Calcular precios para cada grupo")
  console.log("=".repeat(60))

  const precios = {
    mercadolibre: {
      // Precio competitivo para ML (Lista menos un pequeño descuento)
      usd: Math.round(CS200A_CONFIG.precio_lista_usd * 0.95), // 5% desc
      descripcion: "Precio promocional MercadoLibre"
    },
    publico: {
      // Precio lista completo
      usd: CS200A_CONFIG.precio_lista_usd,
      descripcion: "Precio de lista público"
    },
    mayorista_contado: {
      // Precio con bonificación + descuento contado
      usd: Math.round(
        CS200A_CONFIG.precio_lista_usd *
        (1 - CS200A_CONFIG.bonificacion_percentage / 100) *
        (1 - CS200A_CONFIG.contado_descuento_percentage / 100)
      ),
      descripcion: "Precio mayorista con descuento por pago contado"
    },
    mayorista_financiado: {
      // Precio con solo bonificación (sin descuento contado)
      usd: Math.round(
        CS200A_CONFIG.precio_lista_usd *
        (1 - CS200A_CONFIG.bonificacion_percentage / 100)
      ),
      descripcion: "Precio mayorista financiado"
    }
  }

  console.log("\n💰 Precios calculados para CS200A:\n")
  console.log(`Precio Lista (PDF):     USD ${CS200A_CONFIG.precio_lista_usd.toLocaleString()}`)
  console.log(`Bonificación:           ${CS200A_CONFIG.bonificacion_percentage}%`)
  console.log(`Descuento Contado:      ${CS200A_CONFIG.contado_descuento_percentage}%`)
  console.log(`IVA:                    ${CS200A_CONFIG.iva_percentage}%\n`)

  Object.entries(precios).forEach(([tipo, data]) => {
    const ahorro = CS200A_CONFIG.precio_lista_usd - data.usd
    const porcentaje = ((ahorro / CS200A_CONFIG.precio_lista_usd) * 100).toFixed(1)
    console.log(`${tipo.toUpperCase()}:`)
    console.log(`  USD ${data.usd.toLocaleString()} (${porcentaje}% off)`)
    console.log(`  ${data.descripcion}\n`)
  })

  console.log("\n📋 PASO 3: Estructura de Price Lists a crear")
  console.log("=".repeat(60))

  const priceLists = [
    {
      title: "Precios MercadoLibre - CS200A",
      description: "Precios competitivos para canal MercadoLibre",
      type: "override",
      status: "active",
      prices: [{
        variant_id: CS200A_VARIANT_ID,
        amount: precios.mercadolibre.usd * 100, // En centavos
        currency_code: "usd",
        min_quantity: 1,
        max_quantity: null,
        rules: {
          customer_group_id: "[MERCADOLIBRE_GROUP_ID]"
        }
      }]
    },
    {
      title: "Precios Público - CS200A",
      description: "Precio lista para público general",
      type: "override",
      status: "active",
      prices: [{
        variant_id: CS200A_VARIANT_ID,
        amount: precios.publico.usd * 100,
        currency_code: "usd",
        min_quantity: 1,
        max_quantity: null,
        rules: {
          customer_group_id: "[PUBLICO_GROUP_ID]"
        }
      }]
    },
    {
      title: "Precios Mayorista Contado - CS200A",
      description: "Precio mayorista con pago contado",
      type: "override",
      status: "active",
      prices: [{
        variant_id: CS200A_VARIANT_ID,
        amount: precios.mayorista_contado.usd * 100,
        currency_code: "usd",
        min_quantity: 1,
        max_quantity: null,
        rules: {
          customer_group_id: "[MAYORISTA_GROUP_ID]",
          payment_method: "cash"
        }
      }]
    },
    {
      title: "Precios Mayorista Financiado - CS200A",
      description: "Precio mayorista financiado",
      type: "override",
      status: "active",
      prices: [{
        variant_id: CS200A_VARIANT_ID,
        amount: precios.mayorista_financiado.usd * 100,
        currency_code: "usd",
        min_quantity: 1,
        max_quantity: null,
        rules: {
          customer_group_id: "[MAYORISTA_GROUP_ID]",
          payment_method: "financed"
        }
      }]
    }
  ]

  console.log("\n📝 Price Lists a crear:\n")
  priceLists.forEach((pl, i) => {
    console.log(`${i + 1}. ${pl.title}`)
    console.log(`   Precio: USD ${(pl.prices[0].amount / 100).toLocaleString()}`)
    console.log(`   Grupo: ${pl.prices[0].rules.customer_group_id}`)
    if (pl.prices[0].rules.payment_method) {
      console.log(`   Método pago: ${pl.prices[0].rules.payment_method}`)
    }
    console.log()
  })

  console.log("\n📋 PASO 4: Metadata de producto a agregar")
  console.log("=".repeat(60))

  const productMetadata = {
    pricing_config: {
      precio_lista_usd: CS200A_CONFIG.precio_lista_usd,
      currency_type: CS200A_CONFIG.currency_type,
      iva_percentage: CS200A_CONFIG.iva_percentage,
      bonificacion_percentage: CS200A_CONFIG.bonificacion_percentage,
      contado_descuento_percentage: CS200A_CONFIG.contado_descuento_percentage,
      familia: CS200A_CONFIG.familia,

      // Precios calculados para referencia
      precios_calculados: {
        mercadolibre_usd: precios.mercadolibre.usd,
        publico_usd: precios.publico.usd,
        mayorista_contado_usd: precios.mayorista_contado.usd,
        mayorista_financiado_usd: precios.mayorista_financiado.usd
      }
    }
  }

  console.log("\n📄 Metadata JSON para producto CS200A:")
  console.log(JSON.stringify(productMetadata, null, 2))

  console.log("\n\n" + "=".repeat(60))
  console.log("✅ CONFIGURACIÓN GENERADA")
  console.log("=".repeat(60))

  console.log("\n📋 PRÓXIMOS PASOS MANUALES:\n")
  console.log("1. Abrir Medusa Admin: http://localhost:9000/app")
  console.log("2. Ir a Settings → Customer Groups")
  console.log("3. Crear los 3 grupos de clientes manualmente")
  console.log("4. Copiar los IDs de cada grupo creado")
  console.log("5. Ir a Settings → Price Lists")
  console.log("6. Crear cada Price List con los precios mostrados arriba")
  console.log("7. Actualizar metadata del producto CS200A vía Admin o SQL")

  console.log("\n📝 SQL ALTERNATIVO para metadata:")
  console.log(`
UPDATE product
SET metadata = '${JSON.stringify(productMetadata)}'::jsonb
WHERE id = '${CS200A_PRODUCT_ID}';
  `.trim())

  console.log("\n\n💡 NOTA: Este script genera la estructura. La creación real")
  console.log("   requiere autenticación de admin de Medusa.")
  console.log("\n🔗 Documentación: https://docs.medusajs.com/resources/commerce-modules/pricing")
}

main()
  .then(() => {
    console.log("\n✨ Script completado\n")
    process.exit(0)
  })
  .catch((error) => {
    console.error("\n❌ Error:", error)
    process.exit(1)
  })
