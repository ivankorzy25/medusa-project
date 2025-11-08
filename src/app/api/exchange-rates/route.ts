import { NextResponse } from 'next/server';

/**
 * API Route para obtener tipos de cambio del dólar en Argentina
 * Usa DolarAPI.com - API pública y gratuita
 */
export async function GET() {
  try {
    console.log('[API Route] Fetching exchange rates from DolarAPI.com');

    // Obtener cotizaciones de DolarAPI.com
    const response = await fetch('https://dolarapi.com/v1/dolares', {
      cache: 'no-store',
      next: { revalidate: 300 }, // Revalidar cada 5 minutos
    });

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
    console.error('[API Route] Error fetching exchange rates:', error);

    // Fallback con valores por defecto
    return NextResponse.json({
      success: false,
      error: error.message || 'No se pudieron obtener las cotizaciones',
      data: [{
        tipo: 'oficial',
        compra: 1015.50,
        venta: 1055.50,
        fuente: 'Fallback',
        ultima_actualizacion: new Date().toISOString(),
      }],
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
