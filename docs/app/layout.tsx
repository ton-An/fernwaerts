import './global.css';
import { RootProvider } from 'fumadocs-ui/provider/next';
import localFont from 'next/font/local'
import type { Viewport } from 'next';
import type { ReactNode } from 'react';

const inter = localFont({
  src: './fonts/inter.ttf',
  variable: '--font-myfont',
  display: 'swap',
});

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
};

export default function Layout({ children }: { children: ReactNode }) {
  return (
    <html lang="en" className={inter.className} suppressHydrationWarning>
      <body className="flex flex-col min-h-screen">
        <RootProvider>{children}</RootProvider>
      </body>
    </html>
  );
}
