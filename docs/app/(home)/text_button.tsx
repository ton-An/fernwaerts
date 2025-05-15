'use client';

export default function TextButton({ text, isPrimaryButton = false, onClick }: { text: string, isPrimaryButton?: boolean, onClick: () => void }) {
    const baseClasses =
        "px-6 py-3 text-xl font-medium text-white rounded-xl focus:outline-none focus:ring-2 focus:ring-offset-2  transition-color duration-300";

    const primaryClasses =
        "bg-fernwaerts-primary hover:bg-fernwaerts-primary-accent focus:ring-fernwaerts-primary";
    const secondaryClasses =
        "bg-fernwaerts-secondary hover:bg-fernwaerts-secondary-accent focus:ring-fernwaerts-secondary";


    return (
        <button
            className={`${baseClasses} ${isPrimaryButton ? primaryClasses : secondaryClasses
                }`}
            onClick={onClick}
        >
            {text}
        </button>
    );
}