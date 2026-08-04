---
title: partialPrefetching
description: Configure the default link prefetch behavior to fetch only the static parts of each route.
url: "https://nextjs.org/docs/app/api-reference/config/next-config-js/partialPrefetching"
docs_index: /docs/llms.txt
version: 16.3.0
lastUpdated: 2026-07-29
prerequisites:
  - "Configuration: /docs/app/api-reference/config"
  - "next.config.js: /docs/app/api-reference/config/next-config-js"
related:
  - app/api-reference/config/next-config-js/cacheComponents
  - app/api-reference/file-conventions/route-segment-config/prefetch
  - app/api-reference/components/link
  - app/guides/runtime-prefetching
---


> For an index of all Next.js documentation, see [/docs/llms.txt](/docs/llms.txt).
`partialPrefetching` enables Partial Prefetching at the app level. The framework prefetches the static parts of each route by default; opt individual routes into [runtime prefetching](/docs/app/guides/runtime-prefetching) to fetch more.

## Usage

```ts filename="next.config.ts" highlight={5} switcher
import type { NextConfig } from 'next'

const nextConfig: NextConfig = {
  cacheComponents: true,
  partialPrefetching: true,
}

export default nextConfig
```

```js filename="next.config.js" highlight={3} switcher
module.exports = {
  cacheComponents: true,
  partialPrefetching: true,
}
```

`partialPrefetching` requires [`cacheComponents`](/docs/app/api-reference/config/next-config-js/cacheComponents). Without it, `next dev` and `next build` throw at config validation.

## Reference

| Value   | Description                                 |
| ------- | ------------------------------------------- |
| `true`  | Enables Partial Prefetching across the app. |
| `false` | Default. No change to prefetch behavior.    |

## How prefetches resolve

Before Partial Prefetching, Next.js prefetched per visible link: a page with N links to N routes produced ~N route prefetches as those links entered the viewport.

With `partialPrefetching: true`, Next.js prefetches one reusable [App Shell](/docs/app/glossary#app-shell) per route instead. The shell carries the route's rendered output minus per-link data; specifics like params and search-bound data fill in after navigation. Shells are cached on the client, so a route is fetched once even if many links on the page point at it.

The pattern is similar to per-route code splitting in single-page apps: one artifact per route, shared by every link that points to it.

> **Good to know**: Routes that read `cookies()` or `headers()` produce an App Shell that includes session data. The framework auto-detects this and caches the shell per session on the client.

A link can ask for more than the App Shell with [`<Link prefetch={true}>`](/docs/app/api-reference/components/link#prefetch). The prefetch also resolves per-link runtime data like `params`, `searchParams`, and the full URL. See [Runtime prefetching](/docs/app/guides/runtime-prefetching).

> **Good to know**: If you use `<Link prefetch={true}>` to a route that hasn't opted into Partial Prefetching, a dev console error suggests enabling `partialPrefetching` app-wide or `prefetch = 'partial'` on the segment. The [dev warning Insight](/docs/messages/instant-link-prefetch-partial) covers each fix in detail.

## Per-segment overrides

A segment that exports an explicit [`prefetch`](/docs/app/api-reference/file-conventions/route-segment-config/prefetch) value overrides the app-level default for that route.

## Version History

| Version | Change                                                                     |
| ------- | -------------------------------------------------------------------------- |
| 16.3.0  | `partialPrefetching` introduced. Requires `cacheComponents` to be enabled. |
## Related

View related API references and guides.

- [cacheComponents](/docs/app/api-reference/config/next-config-js/cacheComponents)
  - Learn how to enable the cacheComponents flag in Next.js.
- [prefetch](/docs/app/api-reference/file-conventions/route-segment-config/prefetch)
  - API reference for the prefetch route segment config.
- [Link Component](/docs/app/api-reference/components/link)
  - Enable fast client-side navigation with the built-in `next/link` component.
- [Runtime prefetching](/docs/app/guides/runtime-prefetching)
  - Prefetch URL data alongside the App Shell using the prefetch segment config and per-session caching directives.

---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)