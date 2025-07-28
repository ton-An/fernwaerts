'use client';

import { useEffect, useRef, useState } from 'react';

export default function Footer() {
  const signatureRef = useRef<SVGSVGElement>(null);
  const [isVisible, setIsVisible] = useState<boolean>(false);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
          observer.disconnect(); // Stop observing once animation starts
        }
      },
      {
        threshold: 0.5, // Trigger when 50% of the element is visible
      }
    );

    if (signatureRef.current) {
      observer.observe(signatureRef.current);
    }

    return () => observer.disconnect();
  }, []);

  return (
    <a href="https://antons-webfabrik.eu" target="_blank" className="z-2">
      <div className="signature-container">
        <span className={`by-text ${isVisible ? 'animate' : ''}`}>BY</span>
        <svg
          ref={signatureRef}
          id="signature"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 700 400"
          className={isVisible ? 'animate' : ''}
        >
          <path style={{ animationDelay: '0.5s', animationDuration: '1.2s' }} d="M93.36,373.66c7.59-3.18,14.45-5.44,20.05-10.67,9.31-9.46,26.34-28.26,49.62-54.1,48.26-53.86,102.56-114.82,138.98-158.55,7.43-8.76,12.35-16.82,19.36-26.05,9.67-12.69,44.74-56.14,61.35-53.41,1.18.76.11,2.64-1.23,4.38-.81,1.08-1.53,1.99-2.39,3.11-22.99,29.81-89.33,115.33-126.25,166.13-28.61,38.66-58.48,94-81.68,125.44-3.7,4.6-10.64,10.97-12.58,3.52-1-9.56,6.18-24.15,14.28-30.69,32.24-24.62,112.91-76.07,165.03-87.26" />
          <path style={{ animationDelay: '1.45s', animationDuration: '.5s' }} d="M282.26,321.58s-7,4.97,0,5.39" />
          <path style={{ animationDelay: '2s', animationDuration: '1.5s' }} d="M478.84,76.96c-21.51,36.62-38.8,75.35-55.41,114.37-15.78,37.09-36.98,75.68-46.3,114.94-4.72,19.9,15.77-10.7,17.88-14.19,10.79-17.89,21.62-35.75,32.6-53.52,21.96-35.52,44.54-70.68,68.62-104.82,4.78-6.78,26.93-42.18,38.7-35.43,5.84,3.35-2.29,14.29-4.92,18.10-18.94,27.47-33.37,60.3-49.09,89.73-21.16,39.62-41.11,79.88-59.82,120.72" />
          <path style={{ animationDelay: '3s', animationDuration: '.5s' }} d="M401.52,284.21s129.29-52.81,145.52-53.11" />
          <path style={{ animationDelay: '3.37s', animationDuration: '.5s' }} d="M482.26,321.58s-7,4.97,0,5.39" />
        </svg>
      </div>
      <style>
        {`
        .signature-container {
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          gap: 8px;
        }

        .by-text {
        position: absolute;
          font-size: 32px;
          font-weight: 500;
          color: #e1e1e1;
          opacity: 0;
          transform: translateY(20px);
          transition: all 0.8s ease-out;
        }

        .by-text.animate {
          opacity: 1;
          transform: translateY(0);
        }

        #signature {
          width: 130px;
          opacity: 0;
        }
        
        #signature.animate {
          animation: fadeIn 0.5s ease-in-out 0.3s forwards;
        }
        
        #signature path {
          fill: none;
          stroke: var(--color-fd-primary);
          stroke-linecap: round;
          stroke-miterlimit: 10;
          stroke-width: 13px;
          stroke-dasharray: 1300;
          stroke-dashoffset: 1300;
          opacity: 0;
        }

        #signature.animate path {
          animation: fadeIn 0.1s ease-out forwards, draw 1.5s ease-in-out forwards;
        }

        #signature:hover path {
          stroke: var(--color-fd-accent);
        }

        @keyframes draw {
          to {
            stroke-dashoffset: 0;
          }
        }

        @keyframes fadeIn {
          to {
            opacity: 1;
          }
        }
      `}
      </style>
    </a>
  );
}