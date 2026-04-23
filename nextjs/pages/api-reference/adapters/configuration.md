---
title: Configuration
description: "Configure `adapterPath` or `NEXT_ADAPTER_PATH` to use a custom deployment adapter."
url: "https://nextjs.org/docs/pages/api-reference/adapters/configuration"
version: 16.2.4
lastUpdated: 2026-04-21
router: Pages Router
prerequisites:
  - "API Reference: /docs/pages/api-reference"
  - "Adapters: /docs/pages/api-reference/adapters"
---


To use an adapter, specify the path to your adapter module in `adapterPath`:

```js filename="next.config.js"
/** @type {import('next').NextConfig} */
const nextConfig = {
  adapterPath: require.resolve('./my-adapter.js'),
}

module.exports = nextConfig
```

Alternatively `NEXT_ADAPTER_PATH` can be set to enable zero-config usage in deployment platforms.
---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)