"use client";

import React from "react";
import { Plus, DollarSign } from "lucide-react";

interface Optional {
  item: string;
  descripcion: string;
  precio_desde?: number;
  precio_hasta?: number;
  moneda?: string;
  categoria?: string;
}

interface ProductOptionalsProps {
  optionals: Optional[];
}

export function ProductOptionals({ optionals }: ProductOptionalsProps) {
  if (!optionals || optionals.length === 0) return null;

  return (
    <div className="mt-8">
      <h3 className="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
        <Plus className="w-6 h-6 text-[#FF6B00]" />
        Opcionales Disponibles
      </h3>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {optionals.map((opt, idx) => (
          <div
            key={idx}
            className="bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md hover:border-[#FF6B00] transition-all group"
          >
            <h4 className="font-semibold text-gray-900 group-hover:text-[#FF6B00] transition-colors">
              {opt.item}
            </h4>
            <p className="text-sm text-gray-600 mt-1">{opt.descripcion}</p>
            {opt.precio_desde && (
              <div className="flex items-center gap-1 mt-3 text-[#FF6B00] font-semibold">
                <DollarSign className="w-4 h-4" />
                <span>
                  {opt.moneda || "USD"} {opt.precio_desde.toLocaleString()}
                  {opt.precio_hasta && " - " + opt.precio_hasta.toLocaleString()}
                </span>
              </div>
            )}
            {opt.categoria && (
              <span className="inline-block mt-2 text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded">
                {opt.categoria}
              </span>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
