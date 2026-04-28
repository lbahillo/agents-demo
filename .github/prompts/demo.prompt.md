---
description: "Run the full Copilot Agent Customizations demo — automated planning followed by orchestrated implementation."
agent: "orchestrator"
---

# Demo: Build an Alert System for PulseBoard

PulseBoard needs a threshold-based **Alert System**. Users should be able to define alerts that trigger when a metric exceeds a configurable threshold (e.g., "notify when error rate > 5%").

## Feature Requirements

- **Alert entity**: name, metric name, threshold value, severity (info/warning/critical), enabled flag, created timestamp
- **CRUD API endpoints**: following the existing `MetricsController` + `MetricsService` + `Metric` pattern
- **AlertsBanner component**: on the dashboard showing active alerts with severity-colored badges
- **Alerts management page**: at `/alerts` for creating and deleting alerts
- **Typed API client functions**: added to the existing `api-client.ts`
- **E2E tests**: Playwright tests for the alerts feature

## Demo Objectives

This demo should showcase **all 6 GitHub Copilot Agent Customizations** working together. Structure the plan so that each phase demonstrates different customization types:

1. **Instructions** — auto-apply based on file type (.cs gets dotnet rules, .tsx gets nextjs rules)
2. **Agents** — use `@backend-dev` for API, `@frontend-dev` for UI, `@reviewer` for quality
3. **Skills** — api-scaffold, component-library, api-client, e2e-test
4. **Hooks** — secret-scan blocking a hardcoded API key, format-check auto-formatting, test-runner
5. **MCP Servers** — Playwright for E2E tests
6. **Prompts** — this prompt as the single entry point

## Phase Structure for the Demo

Structure the plan with these phases in this order, and include a **"Watch for"** audience callout in each phase so the live audience knows what Copilot customization to observe:

1. **Backend API** (`@backend-dev`) — Create Alert model, service, controller. Register in DI. Watch for: api-scaffold skill guiding the structure + dotnet/api-design instructions auto-applying + PostToolUse hooks (format-check, test-runner) firing after every file write.

2. **Secret Scan** (`@backend-dev`) — Intentionally write a hardcoded API key `sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234` into AlertsService.cs. Watch for: the PreToolUse secret-scan hook BLOCKING the edit with exit code 2. Then fix it with IConfiguration.

3. **Frontend Components** (`@frontend-dev`) — Create AlertsBanner component, update api-client.ts with Alert types and functions, integrate banner into dashboard page.tsx, add navigation to layout.tsx. Watch for: component-library and api-client skills + nextjs instructions auto-applying + PostToolUse format-check.

4. **Alerts Page** (`@frontend-dev`) — Create the full /alerts management page with create form and delete functionality. Watch for: component-library skill enforcing design tokens + data-testid attributes being added (required by testing instructions for the next phase).

5. **E2E Tests** (`@frontend-dev`) — Write Playwright E2E tests for the alerts feature. Watch for: e2e-test skill + testing instructions auto-applying + Playwright MCP server available.

6. **Code Review** (`@reviewer`) — Review all changes from phases 1-5. Watch for: specialized read-only reviewer agent + structured review checklist + security verification that no secrets remain.

For phases where existing files must be modified (Program.cs, api-client.ts, page.tsx, layout.tsx), include explicit notes in the plan that the executor must read current file content and pass it to the subagent for a full-file rewrite.
