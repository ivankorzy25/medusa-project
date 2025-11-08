import { NextResponse } from 'next/server';
import { NextRequest } from 'next/server';

/**
 * API Route para calcular el precio de un producto en ARS
 * Basado en precio USD y tipo de cambio seleccionado
 */
export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const precioUSD = parseFloat(searchParams.get('precio_usd') || '0');
    const tipoCambio = searchParams.get('tipo_cambio') || 'oficial';
    const incluirIva = searchParams.get('incluir_iva') === 'true';

    console.log('[API Route] Calculating price:', { precioUSD, tipoCambio, incluirIva });

    if (!precioUSD || precioUSD <= 0) {
      return NextResponse.json({
        success: false,
        error: 'Precio USD inválido',
      }, { status: 400 });
    }

    // Obtener tipos de cambio
    const ratesResponse = await fetch(
      `${request.nextUrl.origin}/api/exchange-rates`,
      { cache: 'no-store' }
    );
    const ratesData = await ratesResponse.json();

    if (!ratesData.success || !ratesData.data) {
      throw new Error('No se pudieron obtener las cotizaciones');
    }

    // Buscar la cotización del tipo solicitado
    const cotizacion = ratesData.data.find(
      (rate: any) => rate.tipo === tipoCambio
    );

    if (!cotizacion) {
      return NextResponse.json({
        success: false,
        error: `Tipo de cambio '${tipoCambio}' no encontrado`,
      }, { status: 404 });
    }

    // Calcular precio en ARS
    const precioSinIva = precioUSD * cotizacion.venta;
    const iva = incluirIva ? precioSinIva * 0.105 : 0;
    const precioFinal = precioSinIva + iva;

    console.log('[API Route] Price calculated:', {
      precioSinIva,
      iva,
      precioFinal,
    });

    const result = {
      success: true,
      data: {
        precio_base_usd: precioUSD,
        cotizacion: {
          tipo: cotizacion.tipo,
          compra: cotizacion.compra,
          venta: cotizacion.venta,
          fuente: cotizacion.fuente,
          ultima_actualizacion: cotizacion.ultima_actualizacion,
        },
        precio_ars: {
          sin_iva: Math.round(precioSinIva),
          iva: Math.round(iva),
          final: Math.round(precioFinal),
        },
        calculo: {
          formula: incluirIva
            ? 'USD × Venta × (1 + IVA 10.5%)'
            : 'USD × Venta',
          pasos: [
            `Precio base USD: $${precioUSD.toLocaleString('en-US')}`,
            `Cotización ${cotizacion.fuente} vendedor: $${cotizacion.venta.toLocaleString('es-AR')}`,
            `Conversión a ARS: $${precioSinIva.toLocaleString('es-AR')}`,
            ...(incluirIva ? [
              `IVA 10.5%: $${iva.toLocaleString('es-AR')}`,
              `Total final: $${precioFinal.toLocaleString('es-AR')}`
            ] : [
              `Total: $${precioSinIva.toLocaleString('es-AR')}`
            ])
          ],
        },
      },
    };

    return NextResponse.json(result);
  } catch (error: any) {
    console.error('[API Route] Error calculating price:', error);
    return NextResponse.json({
      success: false,
      error: error.message || 'Error al calcular el precio',
    }, { status: 500 });
  }
}
