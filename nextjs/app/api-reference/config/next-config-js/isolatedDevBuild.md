---
title: isolatedDevBuild
description: Use isolated build outputs for development server to prevent conflicts with production builds.
url: "https://nextjs.org/docs/app/api-reference/config/next-config-js/isolatedDevBuild"
version: 16.1.7
lastUpdated: 2026-03-16
prerequisites:
  - "Configuration: /docs/app/api-reference/config"
  - "next.config.js: /docs/app/api-reference/config/next-config-js"
---



> This feature is currently experimental and subject to change, it is not recommended for production.

The experimental `isolatedDevBuild` option separates development and production build outputs into different directories. When enabled, the development server (`next dev`) writes its output to `.next/dev` instead of `.next`, preventing conflicts when running `next dev` and `next build` concurrently.

This is especially helpful when automated tools (for example, AI agents) run `next build` to validate changes while your development server is running, ensuring the dev server is not affected by changes made by the build process.

This feature is **enabled by default** to keep development and production outputs separate and prevent conflicts.

## Configuration

To opt out of this feature, set `isolatedDevBuild` to `false` in your configuration:

```ts filename="next.config.ts" switcher
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  experimental: {
    isolatedDevBuild: false, // defaults to true
  },
}

export default nextConfig
```

```js filename="next.config.mjs" switcher
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    isolatedDevBuild: false, // defaults to true
  },
}

export default nextConfig
```

## Version History

| Version   | Changes                                        |
| --------- | ---------------------------------------------- |
| `v16.0.0` | `experimental.isolatedDevBuild` is introduced. |
---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)