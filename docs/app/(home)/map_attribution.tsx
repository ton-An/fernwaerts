"use client";

import Image from "next/image";
import * as React from "react";

export default function MapAttribution() {
    const attributionRef = React.useRef<HTMLDivElement>(null);
    const isMapVisibleRef = React.useRef(false);
    const [isMapVisible, setIsMapVisible] = React.useState(false);

    React.useEffect(() => {
        const mapBackground = document.querySelector(".home-globe-background");

        if (!mapBackground) return;

        let animationFrame = 0;

        const updateVisibility = () => {
            const mapRect = mapBackground.getBoundingClientRect();
            const attributionRect =
                attributionRef.current?.getBoundingClientRect();
            const attributionTop =
                attributionRect?.top ?? window.innerHeight - 80;
            const attributionBottom =
                attributionRect?.bottom ?? window.innerHeight;

            const overlap =
                Math.min(mapRect.bottom, attributionBottom) -
                Math.max(mapRect.top, attributionTop);
            const nextIsMapVisible = isMapVisibleRef.current
                ? overlap > -350
                : overlap > 24;

            if (nextIsMapVisible !== isMapVisibleRef.current) {
                isMapVisibleRef.current = nextIsMapVisible;
                setIsMapVisible(nextIsMapVisible);
            }
        };

        const scheduleUpdate = () => {
            cancelAnimationFrame(animationFrame);
            animationFrame = requestAnimationFrame(updateVisibility);
        };

        updateVisibility();
        window.addEventListener("scroll", scheduleUpdate, { passive: true });
        window.addEventListener("resize", scheduleUpdate);

        return () => {
            cancelAnimationFrame(animationFrame);
            window.removeEventListener("scroll", scheduleUpdate);
            window.removeEventListener("resize", scheduleUpdate);
        };
    }, []);

    return (
        <div
            ref={attributionRef}
            className={`home-map-attribution ${isMapVisible ? "home-map-attribution-visible" : ""} fixed left-3 right-3 bottom-3 sm:left-auto sm:right-4 sm:bottom-4 px-4 sm:px-5 py-3 flex-row flex-wrap justify-center gap-x-3 gap-y-1 items-center text-xs sm:text-sm text-black/70 dark:text-white transition-colors duration-300 shadow-2xl backdrop-blur-2xl bg-white/70 dark:bg-white/10 rounded-lg z-2`}
        >
            <a
                className="inline-flex items-center transition-opacity duration-300 hover:opacity-60"
                target="_blank"
                rel="noreferrer"
                href="https://www.mapbox.com/about/maps"
                aria-label="Mapbox"
            >
                <Image
                    src="/images/mapbox-logo-black.svg"
                    width={800}
                    height={180}
                    alt=""
                    className="h-4 w-auto dark:invert"
                />
            </a>
            <Divider />
            <Link href="https://www.mapbox.com/about/maps" title="© Mapbox" />
            <Divider />
            <Link
                href="https://www.openstreetmap.org/about/"
                title="© OpenStreetMap"
            />
            <Divider />
            <Link
                href="https://labs.mapbox.com/contribute/#/?q=&l=1.3021%2F32.9547%2F11"
                title="Improve this map"
            />
        </div>
    );
}

function Link({ href, title }: { href: string; title: string }) {
    return (
        <a
            className="hover:text-black/40 transition-colors duration-300"
            target="_blank"
            href={href}
        >
            {title}
        </a>
    );
}

function Divider() {
    return (
        <div className="w-1 h-1 rounded-2xl bg-black/40 dark:bg-white/40"></div>
    );
}
