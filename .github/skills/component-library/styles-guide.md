# PulseBoard Tailwind Styles Guide

## Layout

| Pattern | Classes |
|---------|---------|
| Page container | `min-h-screen p-8` |
| Section spacing | `mb-8` |
| Card grid (responsive) | `grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4` |
| Centered loading | `flex h-screen items-center justify-center` |
| Flex between | `flex items-center justify-between` |
| Flex baseline gap | `flex items-baseline gap-2` |

## Cards & Containers

| Pattern | Classes |
|---------|---------|
| Standard card | `rounded-xl border border-gray-800 bg-gray-900 p-6` |
| Card hover | `transition-shadow hover:shadow-lg hover:shadow-indigo-500/5` |
| Accent card | `rounded-xl border border-indigo-500/20 bg-indigo-500/5 p-6` |
| Danger card | `rounded-xl border border-red-500/20 bg-red-500/5 p-6` |
| Empty state | `flex h-64 items-center justify-center rounded-xl border border-gray-800 bg-gray-900` |

## Typography

| Pattern | Classes |
|---------|---------|
| Page title | `text-3xl font-bold tracking-tight` |
| Section title | `text-xl font-semibold` |
| Card title | `text-lg font-semibold` |
| Subtitle | `text-sm font-medium text-gray-400` |
| Large value | `text-3xl font-bold tracking-tight` |
| Muted text | `text-sm text-gray-500` |
| Tiny label | `text-xs text-gray-500` |

## Colors (Semantic)

| Meaning | Text | Background |
|---------|------|------------|
| Primary/Accent | `text-indigo-400` | `bg-indigo-500` |
| Success/Positive | `text-emerald-400` | `bg-emerald-500` |
| Warning | `text-amber-400` | `bg-amber-500` |
| Danger/Negative | `text-red-400` | `bg-red-500` |
| Muted | `text-gray-400` | `bg-gray-800` |

## Interactive Elements

| Pattern | Classes |
|---------|---------|
| Primary button | `rounded-lg bg-indigo-500 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-indigo-400 active:bg-indigo-600` |
| Ghost button | `rounded-lg px-4 py-2 text-sm font-medium text-gray-400 transition-colors hover:bg-gray-800 hover:text-white` |
| Danger button | `rounded-lg bg-red-500/10 px-4 py-2 text-sm font-medium text-red-400 transition-colors hover:bg-red-500/20` |
| Loading spinner | `h-8 w-8 animate-spin rounded-full border-2 border-indigo-500 border-t-transparent` |

## Chart Bars

| Pattern | Classes |
|---------|---------|
| Bar default | `w-full rounded-t bg-indigo-500/80` |
| Bar hover | `transition-colors group-hover:bg-indigo-400` |
