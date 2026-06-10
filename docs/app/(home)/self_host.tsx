import Link from 'next/link';
import Wave from './wave';

const selfHostSteps = [
    {
        icon: '🐳',
        title: 'Spin up the server',
        description: 'One compose file on your own box. Supabase, sync, and all.',
    },
    {
        icon: '🔗',
        title: 'Connect the app',
        description: 'Point Fernwärts at your server and sign in.',
    },
    {
        icon: '🥾',
        title: 'Go places',
        description: 'Your history starts recording, synced only to you.',
    },
];

export default function SelfHost() {
    return (
        <section className="flex flex-col items-center z-1 relative mt-24 sm:mt-32 w-full px-4 sm:px-6">
            <div className="flex flex-col items-center mb-10 sm:mb-12 w-full max-w-sm sm:w-auto sm:max-w-none px-6 sm:px-12 py-6 sm:py-8 shadow-lg rounded-2xl sm:rounded-3xl backdrop-blur-2xl bg-white/60 dark:bg-white/10">
                <div className="relative">
                    <h2 className="relative text-gray-900/90 dark:text-white text-4xl sm:text-5xl font-bold text-center z-1">Run It Yourself</h2>
                    <Wave className="absolute -bottom-6 -left-7 z-0 scale-75 sm:scale-100" color="stroke-fernwaerts-primary" />
                </div>
            </div>
            <div className="max-w-2xl w-full px-5 sm:px-12 py-7 sm:py-10 flex flex-col gap-7 sm:gap-8 rounded-2xl sm:rounded-3xl shadow-lg backdrop-blur-2xl bg-white/60 dark:bg-white/10 text-left">
                {selfHostSteps.map(({ icon, title, description }) => (
                    <div key={title} className="flex flex-row items-start gap-4 sm:gap-5">
                        <span className="text-3xl sm:text-4xl shrink-0" aria-hidden="true">{icon}</span>
                        <div>
                            <h3 className="text-xl sm:text-2xl font-bold text-gray-900/90 dark:text-white">{title}</h3>
                            <p className="pt-1 text-base sm:text-lg leading-[1.7] text-black/70 dark:text-white/95">{description}</p>
                        </div>
                    </div>
                ))}
                <code className="px-4 sm:px-5 py-4 rounded-2xl bg-black/80 dark:bg-black/60 text-sm sm:text-base text-white/90 overflow-x-auto whitespace-nowrap">
                    <span className="text-fernwaerts-secondary-accent select-none">$ </span>docker compose up -d
                </code>
                <p className="text-base sm:text-lg leading-[1.7] text-black/70 dark:text-white/95">
                    The{' '}
                    <Link
                        href="/docs"
                        className="font-semibold text-fernwaerts-primary hover:text-fernwaerts-primary-accent transition-colors duration-300"
                    >
                        setup guide
                    </Link>{' '}
                    walks you through the rest.
                </p>
            </div>
        </section>
    );
}
