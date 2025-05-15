'use client';

import Globe from './globe'
import Features from './features'
import TextButton from './text_button';
import Wave from './wave';
import MapAttribution from './map_attribution';
import Image from 'next/image';

export default function HomePage() {
  return (
    <main className="flex flex-1 flex-col justify-center items-center text-center">
      <div className='flex flex-col items-center pt-16 z-1 relative'>
        <video src="videos/hero_background.mp4" autoPlay muted loop playsInline className="w-5xl rounded-3xl animate-fadeInOut" />
        <div className="w-2xl absolute top-80 px-12 py-4 flex flex-col items-center rounded-3xl  shadow-2xl backdrop-blur-2xl bg-white/60 dark:bg-white/10">
          <Image src="images/app_icon_transparent.png" alt="" className='w-60 pb-4 drop-shadow-xl' />
          <h1 className="z-1 text-5xl font-bold mb-4 text-white">Fernwärts</h1>

          <Wave className='-translate-y-9 translate-x-12' />

          <div className='mt-1 mb-4 px-4 py-6 rounded-2xl text-xl bg-black/5 dark:bg-white/10 text-black/70 dark:text-white/95 font-regular leading-[1.7]'>
            <p>A privacy-focused, self-hosted location history app powered by Flutter</p>
            <p className='mt-6 font-semibold bg-clip-text text-fernwaerts-primary'>Open source. Local control. Beautiful insights.</p>

          </div>
          <div className='flex flex-row justify-center gap-4 my-6'>
            <TextButton text="📲&nbsp;&nbsp;Download App" isPrimaryButton={true} onClick={() => window.open('https://github.com/ton-an/fernwaerts')} />
            <TextButton text="Get Started" onClick={() => window.open('/docs')} />
          </div>
        </div>
      </div>
      <div className='w-full h-[500px] relative overflow-x-clip'>
        <div className='absolute -right-[400px]'> <Globe /></div>
      </div>
      <Features />
      <MapAttribution />
    </main >
  );
}
