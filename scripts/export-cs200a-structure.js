/**
 * Export complete CS200A product structure via Medusa Admin API
 * This will show us the REAL data that the admin interface displays
 */

const Medusa = require("@medusajs/medusa-js").default;
const fs = require('fs');

const medusa = new Medusa({ baseUrl: "http://localhost:9000", maxRetries: 3 });

const ADMIN_EMAIL = "admin@medusa-test.com";
const ADMIN_PASSWORD = "supersecret";

async function main() {
  try {
    console.log("🔐 Autenticando...");
    await medusa.admin.auth.createSession({
      email: ADMIN_EMAIL,
      password: ADMIN_PASSWORD,
    });
    console.log("✅ Autenticado\n");

    console.log("📦 Obteniendo CS200A completo...");
    const { product } = await medusa.admin.products.retrieve(
      "prod_cs200a_73150acc-b0b6-413b-8f55-2497142ba4f0"
    );

    console.log("\n=== PRODUCTO CS200A COMPLETO ===");
    console.log(`ID: ${product.id}`);
    console.log(`Título: ${product.title}`);
    console.log(`Handle: ${product.handle}`);
    console.log(`\nVariants: ${product.variants.length}`);

    if (product.variants.length > 0) {
      const variant = product.variants[0];
      console.log(`\n--- VARIANT ---`);
      console.log(`ID: ${variant.id}`);
      console.log(`Título: ${variant.title}`);
      console.log(`SKU: ${variant.sku}`);
      console.log(`Weight: ${variant.weight}`);
      console.log(`Length: ${variant.length}`);
      console.log(`Height: ${variant.height}`);
      console.log(`Width: ${variant.width}`);

      if (variant.metadata) {
        const metadataKeys = Object.keys(variant.metadata);
        console.log(`\n--- METADATA (${metadataKeys.length} keys) ---`);
        console.log(JSON.stringify(metadataKeys, null, 2));

        // Guardar metadata completa a archivo
        fs.writeFileSync(
          '/Users/ivankorzyniewski/medusa-storefront-product-template-20251106/scripts/cs200a-metadata.json',
          JSON.stringify(variant.metadata, null, 2)
        );
        console.log("\n✅ Metadata completa guardada en: scripts/cs200a-metadata.json");
      } else {
        console.log("\n⚠️  Metadata vacía o null");
      }
    }

    // Guardar producto completo
    fs.writeFileSync(
      '/Users/ivankorzyniewski/medusa-storefront-product-template-20251106/scripts/cs200a-complete.json',
      JSON.stringify(product, null, 2)
    );
    console.log("✅ Producto completo guardado en: scripts/cs200a-complete.json");

  } catch (error) {
    console.error("\n❌ Error:", error.message);
    if (error.response) {
      console.error("Response:", error.response.data);
    }
    process.exit(1);
  }
}

main();
