---
description: "Create a new REST API endpoint with controller, service, model, and TypeScript client. Full stack from database to frontend integration."
agent: "backend-dev"
model: "Claude Sonnet 4 (copilot)"
tools:
  - "editFile"
  - "createFile"
  - "codeSearch"
  - "readFile"
  - "runTerminal"
---

# API Endpoint Creator

Create a new REST API endpoint for PulseBoard with full stack support.

## What Gets Created

### Backend (.NET)
1. **Model** — Sealed record DTOs in `src/backend/PulseBoard.Api/Models/`
2. **Service** — Interface + implementation in `src/backend/PulseBoard.Api/Services/`
3. **Controller** — API controller in `src/backend/PulseBoard.Api/Controllers/`
4. **DI Registration** — Service registered in `Program.cs`

### Frontend (TypeScript)
5. **API Client** — Typed functions added to `src/frontend/lib/api-client.ts`

## Steps

1. Use the `api-scaffold` skill to generate the backend files
2. Follow existing patterns in `MetricsController.cs` and `MetricsService.cs`
3. Register the new service in `Program.cs`
4. Use the `api-client` skill to generate TypeScript client functions
5. After backend is complete, hand off to `@frontend-dev` if UI changes are needed

## API Contract

All endpoints must:
- Return `ApiResponse<T>` with `data`, `success`, and optional `error`
- Use proper HTTP verbs and status codes
- Accept `CancellationToken` for cancellation support
- Validate input and return 400 for bad requests

## Endpoint Request

Create an API endpoint for:
