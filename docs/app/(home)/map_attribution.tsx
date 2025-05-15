export default function MapAttribution() {
    const aClasses = ''
    return (
        <div className="fixed right-4 bottom-4 px-5 py-3 flex flex-row gap-x-3 items-center text-sm text-black/70 dark:text-white transition-colors duration-300 shadow-2xl backdrop-blur-2xl bg-white/60 dark:bg-white/10 rounded-lg z-2">
            <Link href="https://www.mapbox.com/about/maps" title="© Mapbox" />
            <Divider />
            <Link href="https://www.openstreetmap.org/about/" title="© OpenStreetMap" />
            <Divider />
            <Link href="https://labs.mapbox.com/contribute/#/?q=&l=1.3021%2F32.9547%2F11" title="Improve this map" />
        </div>
    );
}

function Link({ href, title }: { href: string, title: string }) {
    return (
        <a className='hover:text-black/40 transition-color duration-300' target="_blank" href={href}>{title}</a>
    );
}

function Divider() {
    return (
        <div className="w-1 h-1 rounded-2xl bg-black/40 dark:bg-white/40"></div>
    );
}