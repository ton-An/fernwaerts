export default function Wave({ className, color = 'stroke-fernwaerts-secondary' }: { className?: string, color?: string }) {
    return (<svg width="185" height="46" viewBox="0 0 185 46" fill="none" strokeWidth="8" className={`${className} ${color}`} xmlns="http://www.w3.org/2000/svg">
        <path d="M17 22.6938C28.5 15 29.5 11.6938 45 11.6938C69.5 11.6938 73 26.8062 84 25C104 25 95.5 11.6938 119 9.19383C143 9.19383 141.5 27 168.5 25" strokeLinecap="round" />
    </svg>)
};