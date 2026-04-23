# PulseBoard - Project Instructions

## Architecture

PulseBoard is a real-time analytics dashboard with a clear frontend/backend separation:

- **Frontend**: Next.js 15 (App Router) with TypeScript and Tailwind CSS, located in `src/frontend/`
- **Backend**: .NET 8 Web API with Controllers pattern, located in `src/backend/PulseBoard.Api/`
- **Communication**: REST API over HTTP/JSON. All endpoints return `ApiResponse<T>` wrapper.

## General Conventions

- Use English for all code, comments, identifiers, and documentation
- Prefer immutability: use `const` in TypeScript, `sealed record` in C# for DTOs
- No abbreviations in public API surfaces. Prefer clarity over brevity
- Every API endpoint must return `ApiResponse<T>` with `data`, `success`, and optional `error`
- Error responses use standard HTTP status codes (400, 404, 500) with the same `ApiResponse<T>` shape

## File Organization

- Frontend components: `src/frontend/components/{ComponentName}.tsx` (PascalCase)
- Frontend utilities: `src/frontend/lib/{name}.ts` (kebab-case)
- Frontend pages: `src/frontend/app/{route}/page.tsx` (Next.js App Router convention)
- Backend controllers: `src/backend/PulseBoard.Api/Controllers/{Name}Controller.cs`
- Backend services: `src/backend/PulseBoard.Api/Services/{Name}Service.cs`
- Backend models: `src/backend/PulseBoard.Api/Models/{Name}.cs`

## AI Team

This project is equipped with specialized AI agents, skills, and automated quality hooks.

### Available Agents
- `@orchestrator` — Plans features and orchestrates implementation across agents. Does not write code.
- `@architect` — Designs features and system architecture. Does not write code. Delegates to dev agents.
- `@frontend-dev` — Implements Next.js UI features. Knows Tailwind, React Server Components, Playwright.
- `@backend-dev` — Implements .NET API features. Knows EF Core, minimal APIs, controller patterns.
- `@reviewer` — Reviews code for quality, security, and conventions. Can interact with GitHub PRs.

### Available Skills
- `component-library` — Create Next.js components following the project design system
- `api-scaffold` — Scaffold .NET controller + service + model in one go
- `e2e-test` — Write Playwright E2E tests
- `database-migration` — Create and manage EF Core migrations
- `api-client` — Generate typed TypeScript API client functions

### Available Prompts
- `/demo` — Run the full agent customizations demo with automated planning and orchestration
- `/new-feature` — Design and implement a complete feature (starts with architect)
- `/dashboard-widget` — Create a new dashboard widget with chart and card
- `/api-endpoint` — Create a new REST API endpoint with full stack support

## Quality Automation

Hooks run automatically during AI interactions:
- **Secret scanning** runs before any file edit to block hardcoded credentials
- **Code formatting** runs after file edits (Prettier for TS/TSX, dotnet format for CS)
- **Test execution** runs after code changes to verify nothing is broken
