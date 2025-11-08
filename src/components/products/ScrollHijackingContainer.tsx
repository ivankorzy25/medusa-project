"use client";

import { useEffect, useRef, useState } from "react";

interface ScrollHijackingContainerProps {
  imageContent: React.ReactNode;
  centerContent: React.ReactNode;
  rightContent: React.ReactNode;
}

export function ScrollHijackingContainer({
  imageContent,
  centerContent,
  rightContent,
}: ScrollHijackingContainerProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const imageRef = useRef<HTMLDivElement>(null);
  const contentRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleWheel = (e: WheelEvent) => {
      if (!contentRef.current) return;

      const contentContainer = contentRef.current;
      const hasScrollableContent = contentContainer.scrollHeight > contentContainer.clientHeight;

      if (!hasScrollableContent) return;

      const isAtTop = contentContainer.scrollTop <= 0;
      const isAtBottom = contentContainer.scrollTop + contentContainer.clientHeight >= contentContainer.scrollHeight - 1;

      // Interceptar scroll solo si el contenedor tiene contenido scrolleable
      // y no estamos en los límites intentando seguir en esa dirección
      if ((e.deltaY > 0 && !isAtBottom) || (e.deltaY < 0 && !isAtTop)) {
        e.preventDefault();

        // Scroll suave con easing
        const scrollAmount = e.deltaY * 0.8; // Factor de suavizado
        contentContainer.scrollTop += scrollAmount;
      }
    };

    const container = containerRef.current;
    if (container) {
      container.addEventListener("wheel", handleWheel, { passive: false });
    }

    return () => {
      if (container) {
        container.removeEventListener("wheel", handleWheel);
      }
    };
  }, []);

  return (
    <div ref={containerRef} className="relative">
      {/* Grid estilo MercadoLibre: medidas exactas en px */}
      <div className="flex gap-8 justify-center">
        {/* Left Column - Image Gallery (becomes sticky) - 478px */}
        <div
          ref={imageRef}
          className="lg:sticky lg:top-24 lg:self-start flex-shrink-0"
          style={{ width: '478px', height: '504px' }}
        >
          {imageContent}
        </div>

        {/* Right Side - Scrollable content container */}
        <div
          ref={contentRef}
          className="overflow-y-auto flex-shrink-0"
          style={{
            width: 'calc(100% - 478px - 32px)', // Resto del espacio menos galería y gap
            maxWidth: '819px', // Panel info (descripción + precio) max
            maxHeight: "calc(100vh - 120px)",
            scrollbarWidth: "thin",
            scrollbarColor: "#CBD5E0 transparent",
            scrollBehavior: "auto", // Scroll suave
          }}
        >
          <div className="flex gap-8">
            {/* Center Column - Description - flex para ocupar espacio disponible */}
            <div className="flex-grow space-y-3 min-w-0">
              {centerContent}
            </div>

            {/* Right Column - Price Card - 309px fijo */}
            <div
              className="bg-white border border-[#e0e0e0] rounded-md flex-shrink-0"
              style={{
                width: '309px',
                padding: '25px 16px',
                minHeight: '632px'
              }}
            >
              {rightContent}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
