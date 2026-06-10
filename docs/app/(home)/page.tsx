import Globe from "./globe";
import Features from "./features";
import Screenshots from "./screenshots";
import SelfHost from "./self_host";
import TextButton from "./text_button";
import Wave from "./wave";
import MapAttribution from "./map_attribution";
import Image from "next/image";
import Footer from "./footer";

export default function HomePage() {
    return (
        <main className="flex flex-1 flex-col justify-center items-center text-center w-full overflow-x-clip">
            <div className="flex flex-col items-center pt-8 sm:pt-16 px-4 sm:px-6 z-1 relative w-full">
                <video
                    src="videos/hero_background.mp4"
                    autoPlay
                    muted
                    loop
                    playsInline
                    className="w-full max-w-5xl aspect-video object-cover rounded-2xl sm:rounded-3xl animate-fadeInOut"
                />
                <div className="w-full max-w-2xl mt-4 sm:mt-[-5rem] lg:mt-0 lg:absolute lg:top-80 px-4 sm:px-8 lg:px-12 py-4 flex flex-col items-center rounded-2xl sm:rounded-3xl shadow-2xl backdrop-blur-2xl bg-white/70 dark:bg-white/10">
                    <Image
                        src="/images/app_icon_transparent.png"
                        width={256}
                        height={256}
                        alt=""
                        priority
                        className="w-36 sm:w-48 lg:w-60 pb-3 sm:pb-4 drop-shadow-xl"
                    />
                    <h1 className="z-1 text-4xl sm:text-5xl font-bold mb-4 text-gray-900/90 dark:text-white">
                        Fernwärts
                    </h1>

                    <Wave className="-translate-y-8 translate-x-8 sm:-translate-y-9 sm:translate-x-12 scale-75 sm:scale-100" />

                    <div className="mt-1 mb-4 w-full px-4 py-5 sm:py-6 rounded-2xl text-base sm:text-xl bg-black/5 dark:bg-white/10 text-black/70 dark:text-white/95 font-regular leading-[1.7]">
                        <p>
                            A privacy-focused, self-hosted location history app
                            powered by Flutter
                        </p>
                        <p className="mt-6 font-semibold text-fernwaerts-primary text-balance">
                            Open source. Local control. Beautiful insights.
                        </p>
                    </div>
                    <div className="flex w-full sm:w-auto flex-col sm:flex-row justify-center gap-3 sm:gap-4 mt-4 sm:mt-6">
                        <TextButton
                            text="📱&nbsp;&nbsp;Download App"
                            isPrimaryButton={true}
                            href="https://github.com/ton-an/fernwaerts"
                        />
                        <TextButton text="Get Started" href="/docs" />
                    </div>
                    <div className="mt-5 mb-3 w-full sm:w-auto px-4 sm:px-5 py-2.5 rounded-2xl sm:rounded-full text-sm bg-black/5 dark:bg-white/10 text-black/60 dark:text-white/70">
                        🚧 In alpha. Follow the{" "}
                        <a
                            href="https://github.com/users/ton-An/projects/1"
                            target="_blank"
                            className="font-semibold text-fernwaerts-primary hover:text-fernwaerts-primary-accent transition-colors duration-300"
                        >
                            Road to Alpha
                        </a>
                    </div>
                </div>
            </div>
            <div className="home-globe-background absolute w-full h-[900px] sm:h-[1200px] lg:h-[1500px] top-[520px] sm:top-[500px] overflow-clip">
                <div className="absolute -right-[520px] sm:-right-[460px] lg:-right-[400px] scale-[0.58] sm:scale-75 lg:scale-100 origin-top-right">
                    {" "}
                    <Globe />
                </div>
            </div>
            <div className="h-24 sm:h-56 lg:h-[500px]"></div>
            <Features />
            <Screenshots />
            <SelfHost />
            <MapAttribution />
            <div className="h-20 sm:h-28"></div>
            <Footer />
        </main>
    );
}
