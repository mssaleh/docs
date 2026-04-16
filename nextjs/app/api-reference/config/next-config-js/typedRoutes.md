---
title: typedRoutes
description: Enable support for statically typed links.
url: "https://nextjs.org/docs/app/api-reference/config/next-config-js/typedRoutes"
version: 16.2.4
lastUpdated: 2026-04-15
prerequisites:
  - "Configuration: /docs/app/api-reference/config"
  - "next.config.js: /docs/app/api-reference/config/next-config-js"
---


> **Note**: This option has been marked as stable, so you should use `typedRoutes` instead of `experimental.typedRoutes`.

Support for [statically typed links](/docs/app/api-reference/config/typescript#statically-typed-links). This feature requires using TypeScript in your project.

```js filename="next.config.js"
/** @type {import('next').NextConfig} */
const nextConfig = {
  typedRoutes: true,
}

module.exports = nextConfig
```
---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)