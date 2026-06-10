import Wave from "./wave";

export default function Features() {
    return (
        <section className="flex flex-col items-center z-1 relative">

            <div className="flex flex-col items-center mb-6 px-12 py-8 shadow-lg rounded-3xl backdrop-blur-2xl bg-white/60 dark:bg-white/10">
                <div className="relative">
                    <h2 className='relative text-gray-900/90 dark:text-white text-5xl font-bold text-center z-1'>The Gist</h2>
                    <Wave className="absolute -bottom-6 -left-7 z-0" color="stroke-fernwaerts-primary" /></div>

            </div>
            <div className='flex flex-row flex-wrap justify-center gap-6 z-1'>
                <SmallFeature icon="🔒" title="Privacy First" description="Your data is stored by you. We can't touch it." />
                <SmallFeature icon="🎉" title="Vivid Insights" description="Visualize your history. See where you've been." />
                <SmallFeature icon="🌐" title="Open Source" description="The app is open source. You can contribute too!" />
            </div>
        </section>
    )
}

function SmallFeature({ icon, title, description }: { icon: string, title: string; description: string }) {
    return (
        <div className="w-72 h-74 p-4 flex flex-col justify-end items-center rounded-3xl shadow-lg backdrop-blur-2xl bg-white/60 dark:bg-white/10">

            <div className="h-full flex flex-col justify-center"><h3 className='text-6xl'>{icon}</h3></div>
            <div className='px-4 py-6 rounded-2xl bg-black/5 dark:bg-white/10 text-black/70 dark:text-white/95'>
                <h3 className='text-3xl font-bold'>{title}</h3>
                <p className="pt-2 text-base">{description}</p>
            </div>

        </div>
    )
}
