---
name: e2e-test
description: "Write Playwright E2E tests for PulseBoard frontend features. Uses data-testid selectors, Page Object pattern, and consistent test structure."
argument-hint: "Describe the user flow to test (e.g., 'Test that the dashboard loads and shows metric cards')"
user-invocable: true
disable-model-invocation: false
---

# E2E Test Skill

Write Playwright E2E tests for PulseBoard frontend features.

## Test Structure

Follow [the test template](./test-template.spec.ts) for consistent test structure.

### Rules

1. **File location**: `src/frontend/e2e/{feature}.spec.ts`
2. **Selectors**: Always use `data-testid` attributes — never CSS classes or text content
3. **Assertions**: Always use `await expect(...)` — never synchronous assertions
4. **Base URL**: Tests run against `http://localhost:3000`
5. **Independence**: Each test must be independent — no shared state between tests

## Selector Strategy

```typescript
// Good - stable, semantic
await page.getByTestId("dashboard-card-requests");
await page.getByRole("heading", { name: "PulseBoard" });

// Bad - fragile, breaks on style changes
await page.locator(".text-3xl.font-bold");
await page.locator("text=Total Requests");
```

## Common Patterns

### Wait for data loading
```typescript
// Wait for loading spinner to disappear
await expect(page.getByTestId("loading-spinner")).toBeHidden();
// Or wait for content to appear
await expect(page.getByTestId("dashboard-card-requests")).toBeVisible();
```

### Assert card content
```typescript
const card = page.getByTestId("dashboard-card-requests");
await expect(card).toBeVisible();
await expect(card.getByTestId("card-value")).toHaveText("1,284,392");
```

### Screenshot comparison
```typescript
await expect(page).toHaveScreenshot("dashboard-loaded.png", {
  maxDiffPixels: 100,
});
```

## Playwright MCP Integration

When available, use the Playwright MCP server tools to:
- Navigate to pages and interact with elements
- Capture screenshots for visual verification
- Run accessibility audits
