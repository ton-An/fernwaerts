"use client";

import * as React from "react";
import MapGL, { MapEvent, MapRef } from "react-map-gl/mapbox";
import type { Map as MapboxMap } from "mapbox-gl";
import "mapbox-gl/dist/mapbox-gl.css";

const easeOutCubic = (t: number) => 1 - Math.pow(1 - t, 3);

// Fictional journeys drawn as animated traces on the globe. Endpoints are
// well-known city coordinates, not user data.
const traceJourneys: [number, number][][] = [
    [
        [-122.42, 37.77],
        [-104.99, 39.74],
        [-87.62, 41.88],
        [-73.99, 40.73],
    ], // SF -> Denver -> Chicago -> NYC
    [
        [-9.14, 38.72],
        [-3.7, 40.42],
        [2.35, 48.86],
        [13.4, 52.52],
    ], // Lisbon -> Madrid -> Paris -> Berlin
    [
        [72.88, 19.08],
        [77.21, 28.61],
        [85.32, 27.72],
    ], // Mumbai -> Delhi -> Kathmandu
    [
        [139.69, 35.68],
        [126.98, 37.57],
        [121.47, 31.23],
        [103.85, 1.29],
    ], // Tokyo -> Seoul -> Shanghai -> Singapore
];

const traceArcSegments = 32;
const traceDrawDuration = 6000;
const traceHoldDuration = 3000;

// Trace starts synced to the intro rotation: each journey begins drawing as
// the rotation brings its part of the world into view (derived by inverting
// the rotation easing for the journey's longitude band).
const journeyIntroStarts = [0, 2500, 6500, 12000];
// Journeys still visible once the rotation settles over Asia; only these
// keep looping afterwards.
const restJourneyIndices = [2, 3];
const restStaggerDelay = 2400;
const introDuration = 23000; // rotation plus a short hold before the loop

const traceCoreColor = "#2BD968";
const traceGlowColor = "#23C35B";

const pingDuration = 1400;

const rotationDuration = 20000;

/** Interpolates between two lng/lat points along the great circle. */
const interpolateGreatCircle = (
    from: [number, number],
    to: [number, number],
    t: number,
): [number, number] => {
    const toRad = Math.PI / 180;
    const toVec = ([lng, lat]: [number, number]) => [
        Math.cos(lat * toRad) * Math.cos(lng * toRad),
        Math.cos(lat * toRad) * Math.sin(lng * toRad),
        Math.sin(lat * toRad),
    ];
    const a = toVec(from);
    const b = toVec(to);
    const omega = Math.acos(
        Math.min(1, Math.max(-1, a[0] * b[0] + a[1] * b[1] + a[2] * b[2])),
    );
    if (omega === 0) return from;
    const f = Math.sin((1 - t) * omega) / Math.sin(omega);
    const g = Math.sin(t * omega) / Math.sin(omega);
    const v = [f * a[0] + g * b[0], f * a[1] + g * b[1], f * a[2] + g * b[2]];
    return [
        Math.atan2(v[1], v[0]) / toRad,
        Math.atan2(v[2], Math.sqrt(v[0] * v[0] + v[1] * v[1])) / toRad,
    ];
};

/** Expands a journey's waypoints into a smooth great-circle path. */
const buildTracePath = (journey: [number, number][]): [number, number][] => {
    const path: [number, number][] = [];
    for (let leg = 0; leg < journey.length - 1; leg++) {
        for (let step = 0; step < traceArcSegments; step++) {
            path.push(
                interpolateGreatCircle(
                    journey[leg],
                    journey[leg + 1],
                    step / traceArcSegments,
                ),
            );
        }
    }
    path.push(journey[journey.length - 1]);
    return path;
};

/**
 * Moment at which a trace head reaches a waypoint, relative to the journey's
 * start, derived by inverting the easeOutCubic used to grow the line.
 */
const waypointHitTime = (
    journeyStart: number,
    journey: [number, number][],
    waypointIndex: number,
): number => {
    const pathProgress = waypointIndex / (journey.length - 1);
    const drawProgress = 1 - Math.cbrt(1 - pathProgress);
    return journeyStart + drawProgress * traceDrawDuration;
};

/**
 * Journey start times for the current phase: every journey once during the
 * intro rotation (timed to its part of the world facing the camera), then
 * only the journeys visible over the resting view, staggered and looping.
 */
const journeySchedule = (elapsed: number): Map<number, number> => {
    const schedule = new Map<number, number>();
    if (elapsed < introDuration) {
        journeyIntroStarts.forEach((start, index) =>
            schedule.set(index, start),
        );
    } else {
        restJourneyIndices.forEach((journeyIndex, order) =>
            schedule.set(journeyIndex, order * restStaggerDelay),
        );
    }
    return schedule;
};

const tracesGeoJson = (paths: [number, number][][]) => ({
    type: "FeatureCollection" as const,
    features: paths.map((coordinates) => ({
        type: "Feature" as const,
        properties: {},
        geometry: { type: "LineString" as const, coordinates },
    })),
});

const pointsGeoJson = (
    points: { coordinates: [number, number]; progress: number }[],
) => ({
    type: "FeatureCollection" as const,
    features: points.map(({ coordinates, progress }) => ({
        type: "Feature" as const,
        properties: { progress },
        geometry: { type: "Point" as const, coordinates },
    })),
});

const allWaypoints = () =>
    traceJourneys.flatMap((journey) =>
        journey.map((coordinates) => ({ coordinates, progress: 0 })),
    );

const prefersReducedMotion = () =>
    typeof window !== "undefined" &&
    window.matchMedia("(prefers-reduced-motion: reduce)").matches;

export default function RealisticGlobe() {
    const mapRef = React.useRef<MapRef>(null);

    /**
     * Draws the journey traces with a glow under a bright core line, marks
     * visited waypoints with dots, and ripples a ping when a trace reaches
     * one. Shares `animationStart` with the intro rotation so each journey
     * draws while its part of the world is facing the camera.
     */
    const animateTraces = (
        map: MapboxMap,
        reduceMotion: boolean,
        animationStart: number,
    ) => {
        const paths = traceJourneys.map(buildTracePath);

        map.addSource("journey-traces", {
            type: "geojson",
            data: tracesGeoJson(reduceMotion ? paths : paths.map(() => [])),
        });
        map.addSource("journey-points", {
            type: "geojson",
            data: pointsGeoJson(reduceMotion ? allWaypoints() : []),
        });
        map.addSource("journey-pings", {
            type: "geojson",
            data: pointsGeoJson([]),
        });

        map.addLayer({
            id: "journey-traces-glow",
            type: "line",
            source: "journey-traces",
            layout: { "line-cap": "round", "line-join": "round" },
            paint: {
                "line-color": traceGlowColor,
                "line-width": 12,
                "line-blur": 8,
                "line-opacity": 0.55,
            },
        });
        map.addLayer({
            id: "journey-traces",
            type: "line",
            source: "journey-traces",
            layout: { "line-cap": "round", "line-join": "round" },
            paint: {
                "line-color": traceCoreColor,
                "line-width": 4.5,
                "line-opacity": 1,
            },
        });
        map.addLayer({
            id: "journey-pings",
            type: "circle",
            source: "journey-pings",
            paint: {
                "circle-color": "transparent",
                "circle-radius": [
                    "interpolate",
                    ["linear"],
                    ["get", "progress"],
                    0,
                    3,
                    1,
                    26,
                ],
                "circle-stroke-color": traceCoreColor,
                "circle-stroke-width": [
                    "interpolate",
                    ["linear"],
                    ["get", "progress"],
                    0,
                    3,
                    1,
                    0.5,
                ],
                "circle-stroke-opacity": [
                    "interpolate",
                    ["linear"],
                    ["get", "progress"],
                    0,
                    0.9,
                    1,
                    0,
                ],
            },
        });
        map.addLayer({
            id: "journey-points",
            type: "circle",
            source: "journey-points",
            paint: {
                "circle-color": traceCoreColor,
                "circle-radius": 4,
                "circle-stroke-color": "#FFFFFF",
                "circle-stroke-width": 1.5,
            },
        });

        if (reduceMotion) return;

        const traceSource = map.getSource("journey-traces");
        const pointSource = map.getSource("journey-points");
        const pingSource = map.getSource("journey-pings");
        if (
            traceSource?.type !== "geojson" ||
            pointSource?.type !== "geojson" ||
            pingSource?.type !== "geojson"
        ) {
            return;
        }

        const restLoopDuration =
            traceDrawDuration +
            traceHoldDuration +
            restStaggerDelay * (restJourneyIndices.length - 1);

        const drawFrame = () => {
            if (!map.getStyle()) return; // Map was removed.

            const total = Date.now() - animationStart;
            const elapsed =
                total < introDuration
                    ? total
                    : (total - introDuration) % restLoopDuration;
            const schedule = journeySchedule(total);

            const partialPaths = paths.map((path, index) => {
                const start = schedule.get(index);
                if (start === undefined) return [];
                const t = (elapsed - start) / traceDrawDuration;
                if (t <= 0) return [];
                const headIndex = Math.ceil(
                    easeOutCubic(Math.min(1, t)) * (path.length - 1),
                );
                return path.slice(0, headIndex + 1);
            });

            const visited: {
                coordinates: [number, number];
                progress: number;
            }[] = [];
            const pings: { coordinates: [number, number]; progress: number }[] =
                [];
            traceJourneys.forEach((journey, journeyIndex) => {
                const start = schedule.get(journeyIndex);
                if (start === undefined) return;
                journey.forEach((coordinates, waypointIndex) => {
                    const age =
                        elapsed -
                        waypointHitTime(start, journey, waypointIndex);
                    if (age < 0) return;
                    visited.push({ coordinates, progress: 0 });
                    if (age <= pingDuration) {
                        pings.push({
                            coordinates,
                            progress: easeOutCubic(age / pingDuration),
                        });
                    }
                });
            });

            traceSource.setData(tracesGeoJson(partialPaths));
            pointSource.setData(pointsGeoJson(visited));
            pingSource.setData(pointsGeoJson(pings));
            requestAnimationFrame(drawFrame);
        };

        drawFrame();
    };

    const handleMapLoad = (event: MapEvent) => {
        const map = event.target;
        const reduceMotion = prefersReducedMotion();
        const animationStart = Date.now();

        animateTraces(map, reduceMotion, animationStart);

        if (reduceMotion) return;

        const rotate = () => {
            const elapsed = Date.now() - animationStart;

            if (elapsed < rotationDuration) {
                const t = elapsed / rotationDuration;
                const easedProgress = easeOutCubic(t);
                const newLongitude = (-100 + easedProgress * 200) % 360;
                map.setCenter({ lng: newLongitude, lat: 40 });
                requestAnimationFrame(rotate);
            }
        };

        rotate();
    };
    const mapboxToken = process.env.NEXT_PUBLIC_MAPBOX_API_KEY;

    return (
        <div className="home-globe-map">
            <MapGL
                ref={mapRef}
                onLoad={handleMapLoad}
                initialViewState={{
                    longitude: -100,
                    latitude: 40,
                    zoom: 2.5,
                }}
                mapboxAccessToken={mapboxToken}
                style={{ width: 1500, height: 1800 }}
                mapStyle="mapbox://styles/antonswebfabrikeu/cmq7vq1bm001v01sehwdi0662"
                projection={"globe"}
                dragRotate={false}
                dragPan={false}
                touchZoomRotate={false}
                scrollZoom={false}
                doubleClickZoom={false}
                logoPosition="bottom"
                attributionControl={false}
                light={{
                    anchor: "viewport",
                    color: "#FFB700",
                    intensity: 1,
                    position: [1, 120, 120],
                }}
            />
        </div>
    );
}
