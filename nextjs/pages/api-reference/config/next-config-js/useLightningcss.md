---
title: useLightningcss
description: Enable experimental support for Lightning CSS.
url: "https://nextjs.org/docs/pages/api-reference/config/next-config-js/useLightningcss"
version: 16.1.6
lastUpdated: 2026-02-27
router: Pages Router
prerequisites:
  - "Configuration: /docs/pages/api-reference/config"
  - "next.config.js Options: /docs/pages/api-reference/config/next-config-js"
---



> This feature is currently experimental and subject to change, it is not recommended for production.

Experimental support for using [Lightning CSS](https://lightningcss.dev) with webpack. Lightning CSS is a fast CSS transformer and minifier, written in Rust.

If this option is not set, Next.js on webpack uses [PostCSS](https://postcss.org/) with [`postcss-preset-env`](https://www.npmjs.com/package/postcss-preset-env) by default.

Turbopack uses Lightning CSS by default since Next 14.2. This configuration option has no effect on Turbopack. Turbopack always uses Lightning CSS.

```ts filename="next.config.ts" switcher
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  experimental: {
    useLightningcss: false, // default, ignored on Turbopack
  },
}

export default nextConfig
```

```js filename="next.config.js" switcher
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    useLightningcss: true, // disables PostCSS on webpack
  },
}

module.exports = nextConfig
```

## Version History

| Version  | Changes                                                                                                                                                                                      |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `15.1.0` | Support for `useSwcCss` was removed from Turbopack.                                                                                                                                          |
| `14.2.0` | Turbopack's default CSS processor was changed from `@swc/css` to Lightning CSS. `useLightningcss` became ignored on Turbopack, and a legacy `experimental.turbo.useSwcCss` option was added. |
---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)