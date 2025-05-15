"use client";

import * as React from 'react';
import MapGL from 'react-map-gl/mapbox';


const easeOutCubic = (t: number) => 1 - Math.pow(1 - t, 3);

export default function RealisticGlobe() {
    const mapRef = React.useRef<any>(null);

    const handleMapLoad = (event: any) => {
        const map = event.target;
        let startTime = Date.now();

        const rotate = () => {
            const elapsed = Date.now() - startTime;
            const duration = 20000

            if (elapsed < duration) {
                const t = elapsed / duration;
                const easedProgress = easeOutCubic(t);
                const newLongitude = (-100 + easedProgress * 200) % 360;
                map.setCenter({ lng: newLongitude, lat: 40 });
                requestAnimationFrame(rotate);
            }
        };

        rotate();
    };
    const mapboxToken = process.env.NEXT_PUBLIC_MAPBOX_API_KEY;

    return <MapGL
        ref={mapRef}
        onLoad={handleMapLoad}
        initialViewState={{
            longitude: -100,
            latitude: 40,
            zoom: 2.5
        }}
        mapboxAccessToken={mapboxToken}
        style={{ width: 1500, height: 1500 }}
        mapStyle="mapbox://styles/antonheu/cmap4824h01ki01sl8mkr9rgu"
        projection={'globe'}
        dragRotate={false}
        dragPan={false}
        touchZoomRotate={false}
        scrollZoom={false}
        doubleClickZoom={false}
        attributionControl={false}
        light={
            { anchor: 'viewport', color: '#FFB700', intensity: 1, position: [1, 120, 120] }
        }
    />;
};

