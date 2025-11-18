"use client";

import React from "react";
import { Check, X, Info } from "lucide-react";

interface PriceSummaryProps {
  incluye?: string[];
  noIncluye?: string[];
  fechaActualizacion?: string;
}

export function PriceSummary({ incluye, noIncluye, fechaActualizacion }: PriceSummaryProps) {
  if (!incluye && !noIncluye) return null;

  return (
    <div className="mt-6 bg-gray-50 rounded-lg p-4 border border-gray-200">
      <div className="flex items-center justify-between mb-3">
        <h4 className="font-semibold text-gray-900 flex items-center gap-2">
          <Info className="w-4 h-4 text-[#FF6B00]" />
          Detalle del Precio
        </h4>
        {fechaActualizacion && (
          <span className="text-xs text-gray-500">
            Actualizado: {fechaActualizacion}
          </span>
        )}
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {incluye && incluye.length > 0 && (
          <div>
            <p className="text-sm font-medium text-green-700 mb-2">Incluye:</p>
            <ul className="space-y-1">
              {incluye.map((item, idx) => (
                <li key={idx} className="text-sm text-gray-700 flex items-start gap-2">
                  <Check className="w-4 h-4 text-green-600 flex-shrink-0 mt-0.5" />
                  {item}
                </li>
              ))}
            </ul>
          </div>
        )}
        
        {noIncluye && noIncluye.length > 0 && (
          <div>
            <p className="text-sm font-medium text-red-700 mb-2">No incluye:</p>
            <ul className="space-y-1">
              {noIncluye.map((item, idx) => (
                <li key={idx} className="text-sm text-gray-700 flex items-start gap-2">
                  <X className="w-4 h-4 text-red-500 flex-shrink-0 mt-0.5" />
                  {item}
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </div>
  );
}
