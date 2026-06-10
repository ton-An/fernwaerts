import Image from 'next/image';
import Wave from './wave';

const screenshots = [
    {
        src: '/images/home.png',
        alt: 'Welcome screen with the Fernwärts logo and a Get Started button',
        title: 'Simple from the start',
        subtitle: 'Connect your server and go',
    },
    {
        src: '/images/map.png',
        alt: "Map view of a single day, with the day's routes drawn across a city map",
        title: 'Every day on a map',
        subtitle: 'Routes, visits, and places at a glance',
    },
    {
        src: '/images/map_modal.png',
        alt: 'Timeline of a day listing visited places with arrival times and the walks between them',
        title: 'Your day as a timeline',
        subtitle: 'Places and the trips between them',
    },
];

export default function Screenshots() {
    return (
        <section className="flex flex-col items-center z-1 relative mt-32">
            <div className="flex flex-col items-center mb-12 px-12 py-8 shadow-lg rounded-3xl backdrop-blur-2xl bg-white/60 dark:bg-white/10">
                <div className="relative">
                    <h2 className="relative text-gray-900/90 dark:text-white text-5xl font-bold text-center z-1">A Peek Inside</h2>
                    <Wave className="absolute -bottom-6 -left-7 z-0" color="stroke-fernwaerts-primary" />
                </div>
            </div>
            <div className="flex flex-row flex-wrap justify-center gap-10 px-6">
                {screenshots.map(({ src, alt, title, subtitle }) => (
                    <figure key={src} className="w-64 flex flex-col items-stretch gap-6">
                        <Image
                            src={src}
                            width={1368}
                            height={2730}
                            alt={alt}
                            className="w-full drop-shadow-2xl"
                        />
                        <figcaption className="px-4 py-5 rounded-2xl shadow-lg backdrop-blur-2xl bg-white/60 dark:bg-white/10">
                            <h3 className="text-xl font-bold text-gray-900/90 dark:text-white">{title}</h3>
                            <p className="pt-1 text-sm text-black/60 dark:text-white/70">{subtitle}</p>
                        </figcaption>
                    </figure>
                ))}
            </div>
        </section>
    );
}
