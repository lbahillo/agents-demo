---
name: api-client
description: "Generate typed TypeScript API client functions for PulseBoard frontend. Creates fetch wrappers with proper types, error handling, and ApiResponse unwrapping."
argument-hint: "The API endpoint to create a client for (e.g., 'GET /api/alerts with pagination')"
user-invocable: true
disable-model-invocation: false
---

# API Client Generator Skill

Generate typed TypeScript API client functions for the PulseBoard frontend.

## Where to Add

All API client functions live in `src/frontend/lib/api-client.ts`. Add new functions to the existing file — do not create separate files per resource.

## Template

Follow [the client template](./client-template.ts) for consistent function structure.

## Rules

1. **Type everything** — Define TypeScript interfaces for all request/response shapes
2. **Use the `fetchApi` helper** — It handles base URL, headers, error checking, and `ApiResponse<T>` unwrapping
3. **URL encode parameters** — Always use `encodeURIComponent()` for path and query parameters
4. **Export interfaces** — Other components will import these types

## Function Pattern

```typescript
// 1. Define the response type
export interface Alert {
  id: string;
  title: string;
  severity: "info" | "warning" | "critical";
  createdAt: string;
  resolvedAt: string | null;
}

// 2. Create the client function
export async function getAlertById(id: string): Promise<Alert> {
  return fetchApi<Alert>(`/api/alerts/${encodeURIComponent(id)}`);
}

// 3. For list endpoints, include pagination
export async function listAlerts(
  page: number = 1,
  pageSize: number = 20
): Promise<{ items: Alert[]; totalCount: number }> {
  return fetchApi(`/api/alerts?page=${page}&pageSize=${pageSize}`);
}
```

## Conventions

- Function names: `get{Resource}`, `list{Resources}`, `create{Resource}`, `update{Resource}`, `delete{Resource}`
- All functions are `async` and return a `Promise<T>` (not `Promise<ApiResponse<T>>` — the wrapper is unwrapped by `fetchApi`)
- Query parameters use default values where sensible
- The `api-client.ts` file is the single source of truth for all API types and functions
