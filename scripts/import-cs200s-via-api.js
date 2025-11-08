/**
 * =========================================================================
 * IMPORTAR PRODUCTO CS200S VIA MEDUSA ADMIN API
 * =========================================================================
 * Este script crea el producto CS200S completo usando la API de Medusa
 * igual que CS200A, con imágenes, metadata completa y taxonomía.
 */

const Medusa = require("@medusajs/medusa-js").default;
const FormData = require('form-data');
const fs = require('fs');
const path = require('path');

// Cliente Medusa Admin
const medusa = new Medusa({ baseUrl: "http://localhost:9000", maxRetries: 3 });

// Ruta a las imágenes de CS200S
const IMAGES_PATH = "/Users/ivankorzyniewski/Desktop/RECUPERACION_V_DRIVE/GENERADORES/001-GENERADORES/GAUCHO Generadores Cummins - Linea CS/CS200S/IMAGENES-CS 200 S";

// Email y contraseña del admin (ajustar según tu configuración)
const ADMIN_EMAIL = "admin@medusa-test.com";
const ADMIN_PASSWORD = "supersecret";

async function main() {
  try {
    console.log("🚀 Iniciando importación de CS200S...\n");

    // 1. Autenticar
    console.log("🔐 Autenticando...");
    const { customer } = await medusa.admin.auth.createSession({
      email: ADMIN_EMAIL,
      password: ADMIN_PASSWORD,
    });
    console.log("✅ Autenticado\n");

    // 2. Subir imágenes
    console.log("📤 Subiendo imágenes...");
    const images = fs.readdirSync(IMAGES_PATH)
      .filter(file => file.endsWith('.webp'))
      .sort();

    const imageUrls = [];
    for (const imageName of images) {
      const imagePath = path.join(IMAGES_PATH, imageName);
      const formData = new FormData();
      formData.append('files', fs.createReadStream(imagePath));

      try {
        const response = await medusa.admin.uploads.create(formData);
        imageUrls.push(response.uploads[0].url);
        console.log(`  ✅ ${imageName}`);
      } catch (error) {
        console.error(`  ❌ Error subiendo ${imageName}:`, error.message);
      }
    }
    console.log(`✅ ${imageUrls.length} imágenes subidas\n`);

    // 3. Crear producto
    console.log("📦 Creando producto CS200S...");

    const productData = {
      title: "Generador Diesel Cummins CS200S - 200 KVA Silent",
      subtitle: "Generador Diesel Industrial 200/180 KVA con Motor Cummins 6CTA83G2 TDI",
      description: `Generador diesel industrial de 200 kVA con motor Cummins 6CTA83G2 TDI, alternador Stamford UCI274G1 y panel Comap MRS16 con arranque automático. Cabina insonorizada de 71 dB.

El CUMMINS CS200S es un generador diesel de alta gama diseñado para aplicaciones industriales críticas que combina el legendario motor Cummins de 8.3 litros turbo diesel intercooled con 241 HP, alternador brushless Stamford, y sofisticado panel de control Comap con capacidad de arranque automático y monitoreo remoto.

Con tanque de 430 litros proporciona más de 12 horas de autonomía continua, ideal para hospitales, centros de datos, industrias y edificios comerciales donde la continuidad eléctrica es crítica.

CARACTERÍSTICAS PRINCIPALES:
• Motor Cummins 6CTA83G2 TDI - 8.3L Turbo Diesel Intercooled
• Alternador Stamford UCI274G1 Brushless
• 200 KVA Stand-By / 180 KVA Prime
• Panel Comap MRS16 con auto-start
• Cabina Silent Premium - 71 dB @ 7m
• Tanque de combustible: 430 litros
• Autonomía: 12.3 horas @ 75% carga
• Uso continuo 24/7

APLICACIONES:
• Hospitales y clínicas
• Data centers
• Industrias
• Edificios comerciales
• Centros de datos
• Instalaciones críticas`,
      handle: "cummins-cs200s",
      is_giftcard: false,
      status: "published",
      images: imageUrls,
      thumbnail: imageUrls[0],

      // Asignar Type y Collection
      type: {
        value: "Generador Diesel",
        id: "ptype_generador_diesel"
      },
      collection_id: "pcoll_cummins_cs",

      // Asignar categorías
      categories: [
        { id: "pcat_gen_diesel_100_200" }
      ],

      // Asignar tags
      tags: [
        { value: "diesel" },
        { value: "cummins" },
        { value: "industrial" },
        { value: "estacionario" },
        { value: "automatico" },
        { value: "insonorizado" },
        { value: "trifasico" },
        { value: "standby" },
        { value: "prime" },
        { value: "stamford" },
        { value: "100-200kva" }
      ],

      // Variant con metadata de pricing
      variants: [
        {
          title: "CS200S",
          sku: "CS200S",
          manage_inventory: false,
          allow_backorder: false,
          weight: 2450000, // 2450 kg en gramos
          length: 3230, // mm
          height: 1800, // mm
          width: 1170, // mm

          prices: [
            {
              amount: 2870700, // USD 28,707 en centavos
              currency_code: "usd"
            }
          ],

          metadata: {
            pricing_config: {
              precio_lista_usd: 28707,
              currency_type: "usd_blue",
              iva_percentage: 10.5,
              bonificacion_percentage: 11,
              descuento_contado_percentage: 9,
              familia: "Generadores Cummins - Línea CS"
            },
            especificaciones_tecnicas: {
              potencia: {
                standby_kva: 200,
                standby_kw: 160,
                prime_kva: 180,
                prime_kw: 144,
                factor_potencia: 0.8,
                tension: "380/220V",
                frecuencia: "50 Hz"
              },
              motor: {
                marca: "Cummins",
                modelo: "6CTA83G2 TDI",
                tipo: "Diesel 4 tiempos, Turbo Diesel Intercooled",
                cilindros: 6,
                cilindrada_litros: 8.3,
                potencia_hp: 241,
                potencia_kw: 180,
                velocidad_rpm: 1500,
                consumo_75_lh: 35,
                consumo_100_lh: 45,
                capacidad_aceite_litros: 24
              },
              alternador: {
                marca: "Stamford",
                modelo: "UCI274G1",
                tipo: "Brushless",
                regulacion: "±0.5%",
                clase_aislamiento: "H",
                proteccion: "IP23"
              },
              panel_control: {
                marca: "ComAp",
                modelo: "InteliLite MRS16",
                tipo: "Digital LCD",
                arranque_automatico: true
              },
              combustible: {
                tipo: "Diesel",
                capacidad_tanque_litros: 430,
                autonomia_75_horas: 12.3,
                autonomia_100_horas: 10
              },
              insonorizacion: {
                cabina: "Silent Premium",
                nivel_ruido_db: 71,
                distancia_metros: 7
              },
              dimensiones: {
                largo_mm: 3230,
                ancho_mm: 1170,
                alto_mm: 1800,
                peso_kg: 2450,
                peso_operativo_kg: 2880
              }
            }
          }
        }
      ]
    };

    const { product } = await medusa.admin.products.create(productData);
    console.log(`✅ Producto creado: ${product.id}`);
    console.log(`   Handle: ${product.handle}`);
    console.log(`   Título: ${product.title}`);
    console.log(`   Imágenes: ${product.images.length}`);
    console.log(`   Type: ${product.type?.value}`);
    console.log(`   Collection: ${product.collection?.title}`);
    console.log(`   Categorías: ${product.categories?.length || 0}`);
    console.log(`   Tags: ${product.tags?.length || 0}\n`);

    console.log("🎉 ¡Importación completada exitosamente!");
    console.log(`\n📍 Ver producto en Admin: http://localhost:9000/app/products/${product.id}`);
    console.log(`📍 Ver en Frontend: http://localhost:3000/products/${product.handle}`);

  } catch (error) {
    console.error("\n❌ Error durante la importación:", error);
    if (error.response) {
      console.error("Response data:", JSON.stringify(error.response.data, null, 2));
    }
    process.exit(1);
  }
}

main();
