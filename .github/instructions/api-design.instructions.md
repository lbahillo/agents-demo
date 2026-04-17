---
applyTo: "**/Controllers/**"
---
# API Design Conventions

## REST Principles
- Use nouns for resources: `/api/metrics`, not `/api/getMetrics`
- Use HTTP verbs: GET (read), POST (create), PUT (replace), PATCH (update), DELETE (remove)
- Return `201 Created` with Location header for POST operations
- Return `204 No Content` for successful DELETE operations

## Response Shape

All responses use the `ApiResponse<T>` wrapper:

```json
{
  "data": { ... },
  "success": true,
  "error": null
}
```

Error responses follow the same shape:
```json
{
  "data": null,
  "success": false,
  "error": "Human-readable error message"
}
```

## Pagination

List endpoints accept `page` (1-based) and `pageSize` (default 20, max 100) query parameters.
Paginated responses return:
```json
{
  "data": {
    "items": [...],
    "totalCount": 42
  },
  "success": true
}
```

## Naming
- Controller names are plural: `MetricsController`, `UsersController`
- Route parameters use camelCase: `/api/metrics/{metricId}`
- Query parameters use camelCase: `?pageSize=20&sortBy=name`

## Validation
- Validate input at the controller level using model binding and data annotations
- Return `400 Bad Request` with descriptive error messages for invalid input
- Never trust client input — validate even if the frontend already validates
