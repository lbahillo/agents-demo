---
name: component-library
description: "Create Next.js components following PulseBoard's design system: dark theme, Tailwind CSS, consistent card layouts, and proper TypeScript types."
argument-hint: "Describe the component to create (e.g., 'A status badge component with color variants')"
user-invocable: true
disable-model-invocation: false
---

# Component Library Skill

Create Next.js components that follow PulseBoard's design system.

## Design System Tokens

Use these CSS variables and Tailwind classes consistently:

| Token | CSS Variable | Tailwind |
|-------|-------------|----------|
| Primary | `--color-primary` | `indigo-500` / `indigo-400` |
| Success | `--color-success` | `emerald-400` / `emerald-500` |
| Warning | `--color-warning` | `amber-400` / `amber-500` |
| Danger | `--color-danger` | `red-400` / `red-500` |
| Surface | `--color-surface` | `gray-900` |
| Surface Elevated | `--color-surface-elevated` | `gray-800` |
| Border | `--color-border` | `gray-800` |
| Text Primary | — | `white` |
| Text Secondary | — | `gray-400` |
| Text Muted | — | `gray-500` |

## Component Structure

Follow [the component template](./component-template.tsx) for consistent structure.

### Rules

1. **Named exports only** — `export function ComponentName()`, never `export default`
2. **Props interface** — Define `interface ComponentNameProps` above the component
3. **Server Component first** — Only add `"use client"` if the component needs interactivity
4. **Tailwind only** — No inline styles, CSS modules, or styled-components
5. **File location** — `src/frontend/components/{ComponentName}.tsx` (PascalCase)

## Card Pattern

The most common pattern in PulseBoard. Use for any data display container:

```tsx
<div className="rounded-xl border border-gray-800 bg-gray-900 p-6 transition-shadow hover:shadow-lg hover:shadow-indigo-500/5">
  {/* Card content */}
</div>
```

## Interactive States

```tsx
// Buttons
className="rounded-lg bg-indigo-500 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-indigo-400 active:bg-indigo-600"

// Danger button
className="rounded-lg bg-red-500/10 px-4 py-2 text-sm font-medium text-red-400 transition-colors hover:bg-red-500/20"
```

## Reference

See the [styles guide](./styles-guide.md) for complete Tailwind class reference used in this project.
