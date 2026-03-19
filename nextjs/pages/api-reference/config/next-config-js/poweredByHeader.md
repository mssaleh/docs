---
title: poweredByHeader
description: "Next.js will add the `x-powered-by` header by default. Learn to opt-out of it here."
url: "https://nextjs.org/docs/pages/api-reference/config/next-config-js/poweredByHeader"
version: 16.2.0
lastUpdated: 2025-04-15
router: Pages Router
prerequisites:
  - "Configuration: /docs/pages/api-reference/config"
  - "next.config.js Options: /docs/pages/api-reference/config/next-config-js"
---


By default Next.js will add the `x-powered-by` header. To opt-out of it, open `next.config.js` and disable the `poweredByHeader` config:

```js filename="next.config.js"
module.exports = {
  poweredByHeader: false,
}
```
---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)