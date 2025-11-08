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
    let ticking = false;

    const handleWheel = (e: WheelEvent) => {
      if (!containerRef.current || !imageRef.current || !contentRef.current) return;

      if (!ticking) {
        window.requestAnimationFrame(() => {
          const imageRect = imageRef.current!.getBoundingClientRect();
          const contentContainer = contentRef.current!;

          // Verificar si la imagen está completamente visible y sticky
          const imageIsSticky = imageRect.top <= 96 && imageRect.top >= 0; // 96px = top-24 (6rem)
          const imageFullyVisible = imageRect.bottom > 0 && imageRect.top < window.innerHeight;

          // Verificar si el contenido tiene scroll disponible
          const hasScrollableContent = contentContainer.scrollHeight > contentContainer.clientHeight;
          const isAtTop = contentContainer.scrollTop <= 0;
          const isAtBottom = contentContainer.scrollTop + contentContainer.clientHeight >= contentContainer.scrollHeight - 5;

          // Solo hijack si la imagen está sticky y hay contenido para scrollear
          if (imageIsSticky && imageFullyVisible && hasScrollableContent) {
            // Scrolleando hacia abajo y no está al final
            if (e.deltaY > 0 && !isAtBottom) {
              e.preventDefault();
              contentContainer.scrollTop += e.deltaY;
            }
            // Scrolleando hacia arriba y no está al principio
            else if (e.deltaY < 0 && !isAtTop) {
              e.preventDefault();
              contentContainer.scrollTop += e.deltaY;
            }
          }

          ticking = false;
        });

        ticking = true;
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
