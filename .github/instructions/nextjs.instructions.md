---
applyTo: "src/frontend/**/*.tsx"
---
# Next.js Frontend Conventions

## Framework & Version
- Next.js 15 with App Router
- TypeScript with strict mode
- Tailwind CSS for all styling (no CSS modules, no styled-components)

## Component Patterns
- Default to **Server Components**. Only add `"use client"` when the component needs interactivity, hooks, or browser APIs.
- Export components as **named exports** (not default exports) from component files
- One component per file. File name matches component name in PascalCase.

## Styling
- Use Tailwind utility classes exclusively
- Design tokens are defined as CSS variables in `globals.css` (e.g., `--color-primary`)
- Dark theme by default (gray-950 background, white text)
- Use `rounded-xl border border-gray-800 bg-gray-900` for card-style containers

## Data Fetching
- Use the typed API client from `@/lib/api-client.ts` for all backend calls
- In client components, fetch data in `useEffect` with proper loading and error states
- In server components, call API client functions directly (no useEffect)

## File Organization
- Pages: `app/{route}/page.tsx`
- Layouts: `app/{route}/layout.tsx`
- Components: `components/{ComponentName}.tsx`
- Utilities & API client: `lib/{name}.ts`

## TypeScript
- Define interfaces for all component props
- Export shared types from `lib/api-client.ts`
- Use `type` imports when importing only types: `import type { X } from "..."`
