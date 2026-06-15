import { createMDX } from 'fumadocs-mdx/next';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const withMDX = createMDX();
const docsRoot = dirname(fileURLToPath(import.meta.url));
const repositoryRoot = resolve(docsRoot, '..');

/** @type {import('next').NextConfig} */
const config = {
  reactStrictMode: true,
  turbopack: {
    root: repositoryRoot,
  },
};

export default withMDX(config);
