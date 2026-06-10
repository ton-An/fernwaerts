"use client";

import { useEffect, useRef, useState } from "react";

export default function Footer() {
    const signatureRef = useRef<HTMLDivElement>(null);
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
            },
        );

        if (signatureRef.current) {
            observer.observe(signatureRef.current);
        }

        return () => observer.disconnect();
    }, []);

    return (
        <a href="https://antons-webfabrik.eu" target="_blank" className="z-2">
            <div className="signature-container">
                <span className={`by-text ${isVisible ? "animate" : ""}`}>
                    BY
                </span>
                <div ref={signatureRef} className={`image-reveal`}>
                    <img
                        id="me"
                        className={`${isVisible ? "animate" : ""}`}
                        src="/images/me.png"
                        alt="Anton's Webfabrik"
                    />
                </div>
            </div>
            <style>
                {`
        .signature-container {
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
        }

        .by-text {
          margin-left: 4px;
          font-size: 32px;
          font-weight: 600;
          color: var(--color-fernwaerts-secondary);
          opacity: 0;
          transform: translateY(20px);
          transition: opacity 0.8s ease-out, transform 0.8s ease-out;
        }

        .by-text.animate {
          opacity: 1;
          transform: translateY(0);
        }

        .image-reveal {
          width: 132px;
          height: 120px;
          margin-top: -20px;
          overflow: hidden;
        }

        #me {
          display: block;
          width: 80px;
          height: 80px;
          margin-inline: auto;
          opacity: 0;
          transform: translateY(105%) scale(1);
          transform-origin: center;
          transition:
            opacity 0.8s ease-out,
            transform 0.8s ease-out;
        }

        #me.animate {
          opacity: 1;
          transform: translateY(0%) scale(1);
        }

        #me:hover {
          opacity: 0.82;
          transform: translateY(0) scale(1.06);
        }


      `}
            </style>
        </a>
    );
}
