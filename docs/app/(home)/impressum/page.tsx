import type { Metadata } from "next";

export const metadata: Metadata = {
    title: "Impressum",
};

export default function ImpressumPage() {
    return (
        <main className="flex flex-1 flex-col items-center w-full px-4 sm:px-6 py-12 sm:py-20">
            <article className="w-full max-w-2xl">
                <h1 className="text-3xl sm:text-4xl font-bold mb-8 text-gray-900/90 dark:text-white">
                    Impressum
                </h1>

                <section className="mb-8">
                    <h2 className="text-xl font-semibold mb-2 text-gray-900/90 dark:text-white">
                        Angaben gemäß § 5 TMG
                    </h2>
                    <p className="text-black/70 dark:text-white/80 leading-[1.7]">
                        Anton Heuchert
                        <br />
                        Regensburger Str. 21a
                        <br />
                        85055 Ingolstadt
                    </p>
                </section>

                <section className="mb-8">
                    <h2 className="text-xl font-semibold mb-2 text-gray-900/90 dark:text-white">
                        Kontakt
                    </h2>
                    <p className="text-black/70 dark:text-white/80 leading-[1.7]">
                        Telefon: +49 173 5442286
                        <br />
                        E-Mail:{" "}
                        <a
                            href="mailto:anton@antons-webfabrik.eu"
                            className="font-medium text-fernwaerts-primary hover:text-fernwaerts-primary-accent transition-colors duration-300"
                        >
                            anton@antons-webfabrik.eu
                        </a>
                    </p>
                </section>

                <section className="mb-8">
                    <h2 className="text-xl font-semibold mb-2 text-gray-900/90 dark:text-white">
                        EU-Streitschlichtung
                    </h2>
                    <p className="text-black/70 dark:text-white/80 leading-[1.7]">
                        Die Europäische Kommission stellt eine Plattform zur
                        Online-Streitbeilegung (OS) bereit:{" "}
                        <a
                            href="https://ec.europa.eu/consumers/odr/"
                            target="_blank"
                            rel="noreferrer"
                            className="font-medium text-fernwaerts-primary hover:text-fernwaerts-primary-accent transition-colors duration-300"
                        >
                            https://ec.europa.eu/consumers/odr/
                        </a>
                        . Unsere E-Mail-Adresse finden Sie oben im Impressum.
                    </p>
                </section>

                <section className="mb-8">
                    <h2 className="text-xl font-semibold mb-2 text-gray-900/90 dark:text-white">
                        Verbraucherstreitbeilegung/Universalschlichtungsstelle
                    </h2>
                    <p className="text-black/70 dark:text-white/80 leading-[1.7]">
                        Wir sind nicht bereit oder verpflichtet, an
                        Streitbeilegungsverfahren vor einer
                        Verbraucherschlichtungsstelle teilzunehmen.
                    </p>
                </section>

                <p className="text-sm text-black/50 dark:text-white/50">
                    Quelle:{" "}
                    <a
                        href="https://www.e-recht24.de"
                        target="_blank"
                        rel="noreferrer"
                        className="hover:text-fernwaerts-primary transition-colors duration-300"
                    >
                        https://www.e-recht24.de
                    </a>
                </p>
            </article>
        </main>
    );
}
