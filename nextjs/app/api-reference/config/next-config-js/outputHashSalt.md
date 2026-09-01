---
title: outputHashSalt
description: Learn how to incorporate a custom salt string into content-addressed output filenames.
url: "https://nextjs.org/docs/app/api-reference/config/next-config-js/outputHashSalt"
docs_index: /docs/llms.txt
version: 16.3.4
lastUpdated: 2026-07-20
prerequisites:
  - "Configuration: /docs/app/api-reference/config"
  - "next.config.js: /docs/app/api-reference/config/next-config-js"
---


> For an index of all Next.js documentation, see [/docs/llms.txt](/docs/llms.txt).
`outputHashSalt` is an option that incorporates a configurable salt string into every content-addressed output filename (chunks, assets). Changing this value forces all output hashes to change, which is useful for invalidating cached assets across deployments without modifying source files.

To configure the output hash salt, set `outputHashSalt` in `next.config.js`:

```js filename="next.config.js"
/** @type {import('next').NextConfig} */
const nextConfig = {
  outputHashSalt: 'my-deployment-salt',
}

module.exports = nextConfig
```

This works with both Webpack and Turbopack bundlers.

The `NEXT_HASH_SALT` environment variable can also be used for the same purpose. When both are set, the values are **concatenated** (`outputHashSalt + NEXT_HASH_SALT`) to form the effective salt. This lets you combine a per-project salt baked into the config with a per-deployment salt injected at build time via environment variable.

```bash filename="Terminal"
NEXT_HASH_SALT=my-deployment-salt next build
```

## Version History

| Version  | Changes                     |
| -------- | --------------------------- |
| `16.3.0` | `outputHashSalt` was added. |
---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)