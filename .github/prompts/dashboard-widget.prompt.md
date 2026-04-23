---
description: "Create a new dashboard widget with a metric card and chart visualization. Generates the component, integrates with the API client, and adds it to the dashboard page."
agent: "frontend-dev"
model: "Claude Sonnet 4 (copilot)"
tools:
  - "editFile"
  - "createFile"
  - "codeSearch"
  - "readFile"
---

# Dashboard Widget Creator

Create a new dashboard widget for PulseBoard.

## What to Build

A dashboard widget consists of:

1. **Metric Card** — A `DashboardCard` showing the key metric value with trend indicator
2. **Chart Component** — A visualization component showing the metric over time
3. **API Integration** — Typed client function to fetch the widget's data
4. **Dashboard Integration** — Add the widget to the main dashboard page

## Steps

1. Check existing components in `src/frontend/components/` for patterns to follow
2. Use the `component-library` skill for consistent styling
3. Use the `api-client` skill to generate the typed API client function
4. Create the new chart/visualization component
5. Add the widget to `src/frontend/app/page.tsx`
6. Add `data-testid` attributes for E2E testing

## Design System Quick Reference

- Card: `rounded-xl border border-gray-800 bg-gray-900 p-6`
- Chart bar: `bg-indigo-500/80 transition-colors group-hover:bg-indigo-400`
- Trend positive: `text-emerald-400`
- Trend negative: `text-red-400`

## Widget Request

Create a dashboard widget for:
