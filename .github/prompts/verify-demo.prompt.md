---
description: "Verify the results of the Agent Customizations demo. Checks that all demo phases produced expected output."
tools:
  - "codeSearch"
  - "readFile"
  - "listDirectory"
---

# Demo Verification Checklist

You are verifying the results of the `/demo` execution. Check each item and report pass/fail with details.

## Verification Format

For each check, print:
```
[PASS] or [FAIL] — Check description
   Details: what was found / what was expected
```

---

## Phase 1 Checks: Backend API (`@backend-dev`)

### Check 1 — Alert model exists
- File: `src/backend/PulseBoard.Api/Models/Alert.cs`
- Must be `sealed record` with `required` properties
- Must have: Id, Name, MetricName, Threshold, Severity (enum or string), Enabled/IsEnabled, CreatedAt
- Must also have a `CreateAlertRequest` DTO
- Must NOT redefine `ApiResponse<T>` (already in Metric.cs)

### Check 2 — Alerts service exists
- File: `src/backend/PulseBoard.Api/Services/AlertsService.cs`
- Must define `IAlertsService` interface
- Must have implementation class `AlertsService`
- All async methods must have `CancellationToken` parameter with `= default`
- Must have methods for: List, GetById, Create, Delete (at minimum)
- Must use `Async` suffix on method names

### Check 3 — Alerts controller exists
- File: `src/backend/PulseBoard.Api/Controllers/AlertsController.cs`
- Must use `[ApiController]` and `[Route("api/[controller]")]` attributes
- Must use primary constructor with `IAlertsService`
- Must return `ApiResponse<T>` wrapper on all endpoints
- Must have routes: GET /api/alerts, GET /api/alerts/{id}, POST /api/alerts, DELETE /api/alerts/{id}
- 404 responses must use `ApiResponse<T>` with `Success = false`

### Check 4 — DI registration
- File: `src/backend/PulseBoard.Api/Program.cs`
- Must contain `IAlertsService` registration (AddSingleton, AddScoped, or AddTransient)

---

## Phase 2 Checks: Secret Scan (`@backend-dev`)

### Check 5 — No hardcoded secrets in AlertsService
- File: `src/backend/PulseBoard.Api/Services/AlertsService.cs`
- Must NOT contain any string matching `sk-[A-Za-z0-9]{48}` or other API key patterns
- Must use `IConfiguration` for any secret retrieval (primary constructor injection)
- The hook should have blocked the initial attempt — verify `IConfiguration` is present

---

## Phase 3 Checks: Frontend Components (`@frontend-dev`)

### Check 6 — API client updated
- File: `src/frontend/lib/api-client.ts`
- Must have `Alert` interface with all fields
- Must have `CreateAlertRequest` interface
- Must have functions: `listAlerts`, `getAlertById`, `createAlert`, `deleteAlert` (or similar names)
- Functions must use `fetchApi` helper and `encodeURIComponent` for path parameters

### Check 7 — AlertsBanner component
- File: `src/frontend/components/AlertsBanner.tsx`
- Must use **named export** (not default)
- Must follow dark theme: uses classes like `border-gray-800`, `bg-gray-900`, `rounded-xl`
- Must show severity with color coding (red for critical, amber for warning, indigo/blue for info)
- Must have `data-testid="alerts-banner"` on root element

### Check 8 — Dashboard integration
- File: `src/frontend/app/page.tsx`
- Must import and render `AlertsBanner` component

### Check 9 — Navigation added
- File: `src/frontend/app/layout.tsx`
- Must have navigation links for Dashboard (`/`) and Alerts (`/alerts`)
- Must use Next.js `Link` component

---

## Phase 4 Checks: Alerts Page (`@frontend-dev`)

### Check 10 — Alerts management page
- File: `src/frontend/app/alerts/page.tsx`
- Must exist as a valid Next.js page component
- Must fetch alerts data
- Must handle loading and error states
- Must have create form with `data-testid` attributes on inputs
- Must have delete functionality with `data-testid="delete-alert-button"`

---

## Phase 5 Checks: E2E Tests (`@frontend-dev`)

### Check 11 — Alerts E2E test
- File: `src/frontend/e2e/alerts.spec.ts`
- Must import from `@playwright/test`
- Must use `test.describe` and `test` blocks
- Must use `data-testid` selectors exclusively (via `getByTestId`)
- Must use `await expect(...)` for assertions
- Must test: banner visibility, alert list, create alert, delete alert

---

## Convention Compliance

### Check 12 — .NET conventions followed
Verify across all new `.cs` files:
- [ ] File-scoped namespaces (`namespace X;`)
- [ ] Sealed records for DTOs
- [ ] Primary constructors for DI
- [ ] `CancellationToken` on async methods
- [ ] `ApiResponse<T>` return types on controller actions

### Check 13 — Next.js conventions followed
Verify across all new `.tsx` files:
- [ ] Named exports for components (not `export default`, except pages)
- [ ] Tailwind classes only (no inline styles)
- [ ] Dark theme colors (gray-900, gray-800, etc.)
- [ ] `"use client"` directive only when needed
- [ ] `data-testid` attributes on interactive elements

### Check 14 — API design conventions followed
- [ ] REST resource naming (nouns, plural: `/api/alerts`)
- [ ] Proper HTTP verbs (GET/POST/DELETE)
- [ ] `ApiResponse<T>` wrapper on all responses
- [ ] Pagination support on list endpoint (page, pageSize params)
- [ ] 404 with error message for not-found cases

---

## Final Verdict

Print a summary table:

```
+======+===================================+==========+
|  #   | Check                             | Result   |
+======+===================================+==========+
|  1   | Alert model                       | PASS/FAIL|
|  2   | Alerts service                    | PASS/FAIL|
|  3   | Alerts controller                 | PASS/FAIL|
|  4   | DI registration                   | PASS/FAIL|
|  5   | No hardcoded secrets              | PASS/FAIL|
|  6   | API client updated                | PASS/FAIL|
|  7   | AlertsBanner component            | PASS/FAIL|
|  8   | Dashboard integration             | PASS/FAIL|
|  9   | Navigation added                  | PASS/FAIL|
| 10   | Alerts management page            | PASS/FAIL|
| 11   | Alerts E2E test                   | PASS/FAIL|
| 12   | .NET conventions                  | PASS/FAIL|
| 13   | Next.js conventions               | PASS/FAIL|
| 14   | API design conventions            | PASS/FAIL|
+======+===================================+==========+
TOTAL: X / 14 passed
```

If any check fails, explain exactly what went wrong and what the expected result was.
