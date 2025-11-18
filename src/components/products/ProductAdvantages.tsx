"use client";

import React from "react";
import { Award, Star } from "lucide-react";

interface Advantage {
  titulo: string;
  subtitulo: string;
  descripcion: string;
  destacado?: boolean;
}

interface ProductAdvantagesProps {
  advantages: Advantage[];
}

export function ProductAdvantages({ advantages }: ProductAdvantagesProps) {
  if (!advantages || advantages.length === 0) return null;

  return (
    <div className="mt-8">
      <h3 className="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
        <Award className="w-6 h-6 text-[#FF6B00]" />
        Ventajas Competitivas
      </h3>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {advantages.map((adv, idx) => (
          <div
            key={idx}
            className={"bg-white border rounded-lg p-4 hover:shadow-md transition-all " +
              (adv.destacado ? "border-[#FF6B00] bg-orange-50" : "border-gray-200")}
          >
            <div className="flex items-start gap-3">
              <Star className={"w-5 h-5 mt-1 " + (adv.destacado ? "text-[#FF6B00] fill-[#FF6B00]" : "text-gray-400")} />
              <div>
                <h4 className="font-semibold text-gray-900">{adv.titulo}</h4>
                <p className="text-sm text-[#FF6B00] font-medium">{adv.subtitulo}</p>
                <p className="text-sm text-gray-600 mt-1">{adv.descripcion}</p>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
