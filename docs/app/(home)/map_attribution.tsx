export default function MapAttribution() {
    return (
        <div className="fixed left-3 right-3 bottom-3 sm:left-auto sm:right-4 sm:bottom-4 px-4 sm:px-5 py-3 flex flex-row flex-wrap justify-center gap-x-3 gap-y-1 items-center text-xs sm:text-sm text-black/70 dark:text-white transition-colors duration-300 shadow-2xl backdrop-blur-2xl bg-white/70 dark:bg-white/10 rounded-lg z-2">
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
        <a className='hover:text-black/40 transition-colors duration-300' target="_blank" href={href}>{title}</a>
    );
}

function Divider() {
    return (
        <div className="w-1 h-1 rounded-2xl bg-black/40 dark:bg-white/40"></div>
    );
}
