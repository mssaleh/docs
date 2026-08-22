---
title: turbopackRustReactCompiler
description: Use the native Rust port of the React Compiler with Turbopack instead of the Babel transform.
url: "https://nextjs.org/docs/app/api-reference/config/next-config-js/turbopackRustReactCompiler"
docs_index: /docs/llms.txt
version: 16.3.2
lastUpdated: 2026-06-29
prerequisites:
  - "Configuration: /docs/app/api-reference/config"
  - "next.config.js: /docs/app/api-reference/config/next-config-js"
---


> For an index of all Next.js documentation, see [/docs/llms.txt](/docs/llms.txt).

> This feature is currently experimental and subject to change, it's not recommended for production. Try it out and share your feedback on [GitHub](https://github.com/vercel/next.js/issues).

The `experimental.turbopackRustReactCompiler` option enables the native Rust version of the [React Compiler](/docs/app/api-reference/config/next-config-js/reactCompiler), running it directly inside Turbopack as native code instead of through Node.js as it does with the standard Babel version. This typically results in a noticeable performance improvement.

This option is released as experimental to gather feedback before it becomes the default.

```ts filename="next.config.ts" switcher
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  // Enable the React Compiler
  reactCompiler: true,
  experimental: {
    // Use the Rust port instead of the Babel transform
    turbopackRustReactCompiler: true,
  },
}

export default nextConfig
```

```js filename="next.config.js" switcher
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable the React Compiler
  reactCompiler: true,
  experimental: {
    // Use the Rust port instead of the Babel transform
    turbopackRustReactCompiler: true,
  },
}

module.exports = nextConfig
```

## Good to know

> * This option requires [`reactCompiler`](/docs/app/api-reference/config/next-config-js/reactCompiler) to be enabled. It selects which implementation runs, but does not turn the compiler on by itself.
> * This option is only supported with Turbopack. Using it with webpack will throw an error.
> * When enabled, you do not need to install `babel-plugin-react-compiler`. The Rust compiler runs natively inside Turbopack.

See the [`reactCompiler` option documentation](/docs/app/api-reference/config/next-config-js/reactCompiler) for details on how to use the compiler.

## Version History

| Version   | Changes                                                                                             |
| --------- | --------------------------------------------------------------------------------------------------- |
| `v16.3.0` | Introduced the experimental `turbopackRustReactCompiler` option for the native Rust React Compiler. |
---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)