---
title: httpAgentOptions
description: Next.js will automatically use HTTP Keep-Alive by default. Learn more about how to disable HTTP Keep-Alive here.
url: "https://nextjs.org/docs/pages/api-reference/config/next-config-js/httpAgentOptions"
version: 16.2.0
lastUpdated: 2025-04-15
router: Pages Router
prerequisites:
  - "Configuration: /docs/pages/api-reference/config"
  - "next.config.js Options: /docs/pages/api-reference/config/next-config-js"
---


In Node.js versions prior to 18, Next.js automatically polyfills `fetch()` with [undici](/docs/architecture/supported-browsers#polyfills) and enables [HTTP Keep-Alive](https://developer.mozilla.org/docs/Web/HTTP/Headers/Keep-Alive) by default.

To disable HTTP Keep-Alive for all `fetch()` calls on the server-side, open `next.config.js` and add the `httpAgentOptions` config:

```js filename="next.config.js"
module.exports = {
  httpAgentOptions: {
    keepAlive: false,
  },
}
```
---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)