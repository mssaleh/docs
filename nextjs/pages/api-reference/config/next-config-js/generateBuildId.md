---
title: generateBuildId
description: Configure the build id, which is used to identify the current build in which your application is being served.
url: "https://nextjs.org/docs/pages/api-reference/config/next-config-js/generateBuildId"
version: 16.2.3
lastUpdated: 2026-04-08
router: Pages Router
prerequisites:
  - "Configuration: /docs/pages/api-reference/config"
  - "next.config.js Options: /docs/pages/api-reference/config/next-config-js"
---


Next.js generates an ID during `next build` to identify which version of your application is being served. The same build should be used and boot up multiple containers.

If you are rebuilding for each stage of your environment, you will need to generate a consistent build ID to use between containers. Use the `generateBuildId` command in `next.config.js`:

```jsx filename="next.config.js"
module.exports = {
  generateBuildId: async () => {
    // This could be anything, using the latest git hash
    return process.env.GIT_HASH
  },
}
```
---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)