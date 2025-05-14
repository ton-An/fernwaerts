"use client";

import R3fGlobe from 'r3f-globe';
import React, { useMemo, useCallback } from "react";
import ReactDOM from "react-dom";
import { Canvas } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';



export default function RealisticGlobe() {
    return <div style={{ width: '1500px', height: '1500px', }}>
        <Canvas flat camera={useMemo(() => ({ fov: 40, position: [0, 0, 350] }), [])}>
            <OrbitControls minDistance={100} maxDistance={1000} dampingFactor={0.1} zoomSpeed={0.3} rotateSpeed={0.3} autoRotate={true} enableRotate={false} enableZoom={false} autoRotateSpeed={.5} />
            <ambientLight color={0xcccccc} intensity={Math.PI} />
            <directionalLight intensity={4 * Math.PI} />
            <GlobeViz />
        </Canvas>
    </div>;
};

function GlobeViz() {
    return <R3fGlobe
        globeImageUrl="//cdn.jsdelivr.net/npm/three-globe/example/img/earth-blue-marble.jpg"
        pointAltitude="size"
        pointColor="color"
        animateIn={true}
    />;
}