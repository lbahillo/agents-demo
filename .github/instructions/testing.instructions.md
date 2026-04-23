---
applyTo: "**/*.test.*,**/*.spec.*,**/tests/**,**/e2e/**"
---
# Testing Conventions

## Test Frameworks
- **Frontend E2E**: Playwright — tests live in `src/frontend/e2e/`
- **Frontend Unit**: Vitest — tests live next to source files as `{name}.test.ts(x)`
- **Backend Unit**: xUnit — tests live in `src/backend/PulseBoard.Api.Tests/`

## Playwright E2E Tests
- Use Page Object pattern for complex pages
- Test files: `{feature}.spec.ts`
- Always `await expect(...)` for assertions (no synchronous assertions)
- Use `data-testid` attributes for stable selectors — never select by CSS class or text content
- Run against local dev server: `http://localhost:3000`

## Vitest Unit Tests
- Use `describe` / `it` blocks
- Prefer `toEqual` for deep comparisons, `toBe` for primitives
- Mock API calls using `vi.mock()` on the api-client module

## xUnit Backend Tests
- Class name: `{ClassUnderTest}Tests`
- Method name: `{MethodName}_When{Condition}_Should{Expected}`
- Use `Arrange / Act / Assert` pattern with blank line separators
- Use NSubstitute for mocking interfaces

## General
- Tests must be deterministic — no reliance on real time, network, or random values
- Each test must be independent — no shared mutable state between tests
- Name test files clearly so the tested module is obvious from the filename
