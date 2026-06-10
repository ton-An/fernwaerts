import Link from 'next/link';

export default function TextButton({ text, href, isPrimaryButton = false }: { text: string, href: string, isPrimaryButton?: boolean }) {
    const baseClasses =
        "inline-block px-6 py-3 text-xl font-medium text-white rounded-xl focus:outline-none focus:ring-2 focus:ring-offset-2 transition-colors duration-300";

    const primaryClasses =
        "bg-fernwaerts-primary hover:bg-fernwaerts-primary-accent focus:ring-fernwaerts-primary";
    const secondaryClasses =
        "bg-fernwaerts-secondary hover:bg-fernwaerts-secondary-accent focus:ring-fernwaerts-secondary";

    const classes = `${baseClasses} ${isPrimaryButton ? primaryClasses : secondaryClasses}`;

    if (href.startsWith('http')) {
        return (
            <a className={classes} href={href} target="_blank">
                {text}
            </a>
        );
    }

    return (
        <Link className={classes} href={href}>
            {text}
        </Link>
    );
}
