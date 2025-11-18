import { NextResponse } from 'next/server';

/**
 * API Route para obtener tipos de cambio del dólar en Argentina
 * Usa DolarAPI.com - API pública y gratuita
 */
export async function GET() {
  // Valores de fallback actualizados
  const fallbackRates = [
    {
      tipo: 'oficial',
      compra: 1050.00,
      venta: 1100.00,
      fuente: 'Banco Nación (Fallback)',
      ultima_actualizacion: new Date().toISOString(),
    },
    {
      tipo: 'blue',
      compra: 1180.00,
      venta: 1200.00,
      fuente: 'Dólar Blue (Fallback)',
      ultima_actualizacion: new Date().toISOString(),
    },
    {
      tipo: 'mep',
      compra: 1140.00,
      venta: 1160.00,
      fuente: 'Dólar MEP (Fallback)',
      ultima_actualizacion: new Date().toISOString(),
    },
  ];

  try {
    console.log('[API Route] Fetching exchange rates from DolarAPI.com');

    // Obtener cotizaciones de DolarAPI.com con timeout
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 5000);

    const response = await fetch('https://dolarapi.com/v1/dolares', {
      cache: 'no-store',
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (!response.ok) {
      throw new Error(`DolarAPI error: ${response.status}`);
    }

    const data = await response.json();
    console.log('[API Route] Exchange rates fetched successfully from DolarAPI');

    // Mapear a nuestro formato
    const exchangeRates = data.map((item: any) => ({
      tipo: mapDolarApiToType(item.casa),
      compra: item.compra,
      venta: item.venta,
      fuente: item.nombre,
      ultima_actualizacion: item.fechaActualizacion,
    }));

    return NextResponse.json({
      success: true,
      data: exchangeRates,
    });
  } catch (error: any) {
    console.error('[API Route] Error fetching exchange rates:', error.message);
    console.log('[API Route] Using fallback exchange rates');

    // Devolver fallback con success: true para que calculate-price funcione
    return NextResponse.json({
      success: true,
      data: fallbackRates,
      fallback: true,
      error_message: error.message,
    });
  }
}

/**
 * Mapea los nombres de DolarAPI a nuestros tipos
 */
function mapDolarApiToType(casa: string): string {
  const mapping: Record<string, string> = {
    oficial: 'oficial',
    blue: 'blue',
    bolsa: 'mep',
    contadoconliqui: 'ccl',
    mayorista: 'mayorista',
    cripto: 'cripto',
    tarjeta: 'tarjeta',
  };

  return mapping[casa.toLowerCase()] || casa.toLowerCase();
}
