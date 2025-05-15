import Wave from "./wave";

export default function Features() {
    return (
        <main>

            <div className="flex flex-col items-center mb-6 py-8 shadow-lg rounded-3xl backdrop-blur-2xl bg-white/60 dark:bg-white/10">
                <div className="relative">
                    <h1 className='relative text-gray-900/90 dark:text-white text-5xl font-bold text-center z-1'>The Gist</h1>
                    <Wave className="absolute -bottom-6 -left-7 z-0" color="stroke-fernwaerts-primary" /></div>

            </div>
            <div className='grid grid-cols-3 gap-6 z-1'>
                <SmallFeature icon="🔒" title="Privacy First" description="Your data is stored by you. We can't touch it." />
                <SmallFeature icon="🎉" title="Vivid Insights" description="Visualize your history. See where you've been." />
                <SmallFeature icon="🌐" title="Open Source" description="The app is open source. You can contribute too!" />
            </div>
        </main >
    )
}

function SmallFeature({ icon, title, description }: { icon: string, title: string; description: string }) {
    return (
        <div className="w-64 h-64 p-4 flex flex-col items-center rounded-3xl shadow-lg backdrop-blur-2xl bg-white/60 dark:bg-white/10">
            <h1 className='pt-8 text-5xl'>{icon}</h1>
            <h2 className='pt-8 text-3xl font-bold'>{title}</h2>
            <p className="pt-2 text-base">{description}</p>
        </div>
    )
}