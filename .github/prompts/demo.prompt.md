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

**Important**: Include a phase where `@backend-dev` intentionally writes a hardcoded API key (`sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234`) into a service file to trigger and demonstrate the PreToolUse secret-scan hook blocking the edit.
