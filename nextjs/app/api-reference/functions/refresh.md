---
title: refresh
description: API Reference for the refresh function.
url: "https://nextjs.org/docs/app/api-reference/functions/refresh"
docs_index: /docs/llms.txt
version: 16.3.2
lastUpdated: 2026-06-25
prerequisites:
  - "API Reference: /docs/app/api-reference"
  - "Functions: /docs/app/api-reference/functions"
related:
  - app/guides/server-actions
---


> For an index of all Next.js documentation, see [/docs/llms.txt](/docs/llms.txt).
`refresh` allows you to refresh the client router from within a [Server Action](/docs/app/guides/server-actions).

## Usage

`refresh` can **only** be called from within Server Actions. It cannot be used in Route Handlers, Client Components, or any other context.

## Parameters

```tsx
refresh(): void;
```

## Returns

`refresh` does not return a value.

## Examples

```ts filename="app/actions.ts" switcher
'use server'

import { refresh } from 'next/cache'

export async function createPost(formData: FormData) {
  const title = formData.get('title')
  const content = formData.get('content')

  // Create the post in your database
  const post = await db.post.create({
    data: { title, content },
  })

  refresh()
}
```

```js filename="app/actions.js" switcher
'use server'

import { refresh } from 'next/cache'

export async function createPost(formData) {
  const title = formData.get('title')
  const content = formData.get('content')

  // Create the post in your database
  const post = await db.post.create({
    data: { title, content },
  })

  refresh()
}
```

### Error when used outside Server Actions

```ts filename="app/api/posts/route.ts" switcher
import { refresh } from 'next/cache'

export async function POST() {
  // This will throw an error
  refresh()
}
```
- [Server Actions](/docs/app/guides/server-actions)
  - How Server Actions work in Next.js, including the single-roundtrip response model, sequential dispatch, security, and caching integration.

---

For a semantic overview of all documentation, see [/docs/sitemap.md](/docs/sitemap.md)

For an index of all available documentation, see [/docs/llms.txt](/docs/llms.txt)