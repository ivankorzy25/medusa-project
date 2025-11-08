"use client";

import { useRef } from "react";

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

        {/* Right Side - Content container */}
        <div
          ref={contentRef}
          className="flex-shrink-0"
          style={{
            width: 'calc(100% - 478px - 32px)',
            maxWidth: '819px',
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
