export default function Features() {
    return (
        <main>
            <div className='grid grid-cols-3 gap-4 z-1'>
                <SmallFeature icon="🔒" title="Privacy First" description="Your data is stored locally" />
                <SmallFeature icon="🎇" title="Beautiful Insights" description="Visualize your location" />
                <SmallFeature icon="🌐" title="Open Source" description="The app is open source." />
            </div>
        </main>
    )
}

function SmallFeature({ icon, title, description }: { icon: string, title: string; description: string }) {
    return (
        <div className="w-56 h-56 p-4 flex flex-col items-center justify-center rounded-3xl shadow-lg backdrop-blur-2xl bg-white/60 dark:bg-white/10">
            <h1 className='text-5xl'>{icon}</h1>
            <h2 className='text-3xl font-bold'>{title}</h2>
            <p>{description}</p>
        </div>
    )
}