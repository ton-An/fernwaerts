import type { ReactNode } from 'react';
import { HomeLayout } from 'fumadocs-ui/layouts/home';
import { baseOptions } from '@/app/layout.config';

export default function Layout({ children }: { children: ReactNode }) {
  return (
    <HomeLayout
      {...baseOptions}
      // @ts-expect-error: links is (for some reason) not recognized by the type checker
      links={[
        {
          text: 'Documentation',
          url: '/docs',
        },
      ]}
    >
      {children}
    </HomeLayout>
  );
}
