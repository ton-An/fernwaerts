import Globe from './globe'
import Features from './features'
import Screenshots from './screenshots';
import SelfHost from './self_host';
import TextButton from './text_button';
import Wave from './wave';
import MapAttribution from './map_attribution';
import Image from 'next/image';
import Footer from './footer';

export default function HomePage() {
  return (
    <main className="flex flex-1 flex-col justify-center items-center text-center">
      <div className='flex flex-col items-center pt-16 z-1 relative'>
        <video src="videos/hero_background.mp4" autoPlay muted loop playsInline className="w-5xl rounded-3xl animate-fadeInOut" />
        <div className="w-2xl absolute top-80 px-12 py-4 flex flex-col items-center rounded-3xl  shadow-2xl backdrop-blur-2xl bg-white/60 dark:bg-white/10">
          <Image src="/images/app_icon_transparent.png" width={256} height={256} alt="" priority className='w-60 pb-4 drop-shadow-xl' />
          <h1 className="z-1 text-5xl font-bold mb-4 text-white">Fernwärts</h1>

          <Wave className='-translate-y-9 translate-x-12' />

          <div className='mt-1 mb-4 px-4 py-6 rounded-2xl text-xl bg-black/5 dark:bg-white/10 text-black/70 dark:text-white/95 font-regular leading-[1.7]'>
            <p>A privacy-focused, self-hosted location history app powered by Flutter</p>
            <p className='mt-6 font-semibold text-fernwaerts-primary'>Open source. Local control. Beautiful insights.</p>

          </div>
          <div className='flex flex-row justify-center gap-4 mt-6'>
            <TextButton text="📲&nbsp;&nbsp;Download App" isPrimaryButton={true} href="https://github.com/ton-an/fernwaerts" />
            <TextButton text="Get Started" href="/docs" />
          </div>
          <div className='mt-5 mb-3 px-5 py-2.5 rounded-full text-sm bg-black/5 dark:bg-white/10 text-black/60 dark:text-white/70'>
            🚧 In alpha. Follow the{' '}
            <a
              href="https://github.com/users/ton-An/projects/1"
              target="_blank"
              className='font-semibold text-fernwaerts-primary hover:text-fernwaerts-primary-accent transition-colors duration-300'
            >
              Road to Alpha
            </a>
          </div>
        </div>
      </div>
      <div className='absolute  w-full h-[1500px] top-[500px] overflow-clip'>
        <div className='absolute -right-[400px]'> <Globe /></div>
      </div>
      <div className='h-[500px]'></div>
      <Features />
      <Screenshots />
      <SelfHost />
      <MapAttribution />
      <div className='h-[300px]'></div>
      <Footer />
    </main >
  );
}
