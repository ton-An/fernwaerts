import Link from 'next/link';

export default function HomePage() {
  return (
    <main className="flex flex-1 flex-col justify-center items-center text-center">
      <div className='flex flex-col items-center pt-16'>
        <video src="videos/hero_background.mp4" autoPlay muted loop playsInline className="w-5xl rounded-3xl" />
        <div className="w-2xl px-12 py-4 flex flex-col items-center rounded-3xl -translate-y-7/12 shadow-2xl backdrop-blur-2xl bg-white/60 dark:bg-white/10">
          <img src="images/app_icon_transparent.png" alt="" className='w-60 pb-4 drop-shadow-xl' />
          <h1 className="z-1 text-5xl font-bold mb-4 text-white">Fernwärts</h1>

          <svg width="185" height="46" viewBox="0 0 185 46" fill="none" strokeWidth="8" className='-translate-y-9 translate-x-12 stroke-fernwaerts-secondary' xmlns="http://www.w3.org/2000/svg">
            <path d="M17 22.6938C28.5 15 29.5 11.6938 45 11.6938C69.5 11.6938 73 26.8062 84 25C104 25 95.5 11.6938 119 9.19383C143 9.19383 141.5 27 168.5 25" strokeLinecap="round" />
          </svg>

          <div className='mt-1 mb-4 px-4 py-6 rounded-2xl text-xl bg-black/5 dark:bg-white/10 text-black/70 dark:text-white/95 font-regular leading-[1.7]'>
            <p>A privacy-focused, self-hosted location history app powered by Flutter</p>
            <p className='mt-6 font-semibold bg-clip-text text-fernwaerts-primary'>Open code. Local control. Beautiful insights.</p>
          </div>
        </div>
      </div>
    </main >
  );
}
//style={{ color: '#EDBB32' }