---
description: "Verify the results of the Agent Customizations demo. Checks that all phases produced expected output."
agent: "agent"
model: "Claude Sonnet 4 (copilot)"
tools:
  - "codeSearch"
  - "readFile"
  - "listDirectory"
---

# Demo Verification Checklist

You are verifying the results of the `/run-demo` execution. Check each item and report pass/fail with details.

## Verification Format

For each check, print:
```
[PASS] or [FAIL] — Check description
   Details: what was found / what was expected
```

---

## Phase 3 Checks: Backend Implementation

### Check 1 — Alert model exists
- File: `src/backend/PulseBoard.Api/Models/Alert.cs`
- Must be `sealed record` with `required` properties
- Must have: Id, Name, MetricName, Threshold, Severity (enum or string), Enabled, CreatedAt
- Must also have a `CreateAlertRequest` DTO

### Check 2 — Alerts service exists
- File: `src/backend/PulseBoard.Api/Services/AlertsService.cs`
- Must define `IAlertsService` interface
- Must have implementation class `AlertsService`
- All async methods must have `CancellationToken` parameter
- Must have methods for: List, GetById, Create, Delete (at minimum)

### Check 3 — Alerts controller exists
- File: `src/backend/PulseBoard.Api/Controllers/AlertsController.cs`
- Must use `[ApiController]` attribute
- Must use primary constructor with `IAlertsService`
- Must return `ApiResponse<T>` wrapper on all endpoints
- Must have routes: GET /api/alerts, GET /api/alerts/{id}, POST /api/alerts, DELETE /api/alerts/{id}     
- 404 responses must use `ApiResponse<T>` with `Success = false`

### Check 4 — DI registration
- File: `src/backend/PulseBoard.Api/Program.cs`
- Must contain `IAlertsService` registration (AddSingleton, AddScoped, or AddTransient)

---

## Phase 4 Checks: Frontend Implementation

### Check 5 — API client updated
- File: `src/frontend/lib/api-client.ts`
- Must have `Alert` interface with all fields
- Must have `CreateAlertRequest` interface
- Must have functions: `listAlerts`, `getAlertById`, `createAlert`, `deleteAlert` (or similar names)
- Functions must use `fetchApi` helper and `encodeURIComponent` for parameters

### Check 6 — AlertsBanner component
- File: `src/frontend/components/AlertsBanner.tsx`
- Must use **named export** (not default)
- Must follow dark theme: uses classes like `border-gray-800`, `bg-gray-900`, `rounded-xl`
- Must show severity with color coding (emerald/amber/red for info/warning/critical)
- Must have a props interface defined

### Check 7 — Alerts page
- File: `src/frontend/app/alerts/page.tsx`
- Must exist as a valid Next.js page component
- Must fetch alerts data
- Must handle loading and error states

### Check 8 — Dashboard integration
- File: `src/frontend/app/page.tsx`
- Must import and render `AlertsBanner` component
- `AlertsBanner` should appear in the page layout

---

## Phase 5 Checks: Secret Scan

### Check 9 — NotificationService exists (clean version)
- File: `src/backend/PulseBoard.Api/Services/NotificationService.cs`
- Must NOT contain hardcoded API keys, tokens, or secrets
- Must use `IConfiguration` for secret retrieval
- Must use primary constructor pattern

---

## Phase 7 Checks: E2E Test

### Check 10 — Alerts E2E test
- File: `src/frontend/e2e/alerts.spec.ts`
- Must import from `@playwright/test`
- Must use `test.describe` and `test` blocks
- Must use `data-testid` selectors (not CSS classes or text)
- Must use `await expect(...)` for assertions
- Must have `beforeEach` with page navigation
- Must test: page load, banner visibility, create alert, delete alert

---

## Convention Compliance

### Check 11 — .NET conventions followed
Verify across all new `.cs` files:
- [ ] File-scoped namespaces (`namespace X;`)
- [ ] Sealed records for DTOs
- [ ] Primary constructors for DI
- [ ] `CancellationToken` on async methods
- [ ] `ApiResponse<T>` return types on controller actions

### Check 12 — Next.js conventions followed
Verify across all new `.tsx` files:
- [ ] Named exports (no `export default` on components)
- [ ] Props defined as TypeScript interfaces
- [ ] Tailwind classes only (no inline styles)
- [ ] Dark theme colors (gray-900, gray-800, etc.)
- [ ] `"use client"` directive only when needed

### Check 13 — API design conventions followed
- [ ] REST resource naming (nouns, plural: `/api/alerts`)
- [ ] Proper HTTP verbs (GET/POST/DELETE)
- [ ] `ApiResponse<T>` wrapper on all responses
- [ ] Pagination support on list endpoint (page, pageSize params)
- [ ] 404 with error message for not-found cases

---

## Final Verdict

Print a summary table:

```
╔══════════════════════════════════════════════════════════╗
║            DEMO VERIFICATION RESULTS                     ║
╠════╦══════════════════════════════════╦══════════════════╣
║  # ║ Check                           ║ Result           ║
╠════╬══════════════════════════════════╬══════════════════╣
║  1 ║ Alert model                     ║ [PASS] / [FAIL]  ║
║  2 ║ Alerts service                  ║ [PASS] / [FAIL]  ║
║  3 ║ Alerts controller               ║ [PASS] / [FAIL]  ║
║  4 ║ DI registration                 ║ [PASS] / [FAIL]  ║
║  5 ║ API client updated              ║ [PASS] / [FAIL]  ║
║  6 ║ AlertsBanner component          ║ [PASS] / [FAIL]  ║
║  7 ║ Alerts page                     ║ [PASS] / [FAIL]  ║
║  8 ║ Dashboard integration           ║ [PASS] / [FAIL]  ║
║  9 ║ NotificationService (no secrets)║ [PASS] / [FAIL]  ║
║ 10 ║ Alerts E2E test                 ║ [PASS] / [FAIL]  ║
║ 11 ║ .NET conventions                ║ [PASS] / [FAIL]  ║
║ 12 ║ Next.js conventions             ║ [PASS] / [FAIL]  ║
║ 13 ║ API design conventions          ║ [PASS] / [FAIL]  ║
╠════╬══════════════════════════════════╬══════════════════╣
║    ║ TOTAL                           ║ X / 13 passed    ║
╚════╩══════════════════════════════════╩══════════════════╝
```

If any check fails, explain exactly what went wrong and what the expected result was.
