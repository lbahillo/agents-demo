---
description: "Run the full Agent Customizations demo. Executes all 6 customization types step by step with visible results at each phase."
agent: "agent"
model: "Claude Sonnet 4 (copilot)"
tools:
  - "editFile"
  - "createFile"
  - "codeSearch"
  - "readFile"
  - "listDirectory"
  - "runTerminal"
---

# PulseBoard Agent Customizations Demo

You are running a live demo that showcases **every GitHub Copilot Agent Customization type**. Follow each phase in order. After completing each phase, print a clear separator and summary before moving to the next.

Use this format between phases:

```
═══════════════════════════════════════════════════════════
✅ PHASE N COMPLETE: {Phase Name}
   Demonstrated: {customization type}
   What happened: {one-line summary}
═══════════════════════════════════════════════════════════
```

---

## PHASE 1: Instructions in Action

**Demonstrates: Instructions (global + conditional auto-apply)**

1. Read the file `src/backend/PulseBoard.Api/Controllers/MetricsController.cs`
2. Explain which instructions are automatically active for this file and why (mention the `applyTo` glob patterns that match)
3. Now read `src/frontend/components/DashboardCard.tsx`
4. Explain which different instructions are active for this file and why
5. Summarize: the same project has different conventions for different file types, applied automatically without the developer doing anything

---

## PHASE 2: Agent Handoff Workflow

**Demonstrates: Agents + Handoffs**

Act as `@architect` for this step. You have READ-ONLY access — you must NOT create or edit any files.

1. Analyze the current PulseBoard codebase structure
2. Design a new feature: **"Alert System"** — a way to define threshold alerts on metrics (e.g., "notify when error rate > 5%"). Produce a technical spec with:
   - Data model: `Alert` with id, name, metricName, threshold, severity (info/warning/critical), enabled, createdAt
   - API endpoints: GET /api/alerts (list), GET /api/alerts/{id}, POST /api/alerts, DELETE /api/alerts/{id}
   - Frontend: `AlertsBanner` component showing active alerts, `AlertsPage` for managing alerts
   - Integration: alerts evaluate against current metric values
3. Print the complete spec formatted as markdown

Then print:
```
🤝 HANDOFF: Architecture complete. In a real workflow, I would now hand off to @backend-dev and @frontend-dev via handoff buttons.
   For this demo, I'll continue implementing both sides.
```

---

## PHASE 3: Backend Implementation with Skills

**Demonstrates: Skills (api-scaffold) + Instructions (dotnet, api-design)**

Now act as `@backend-dev`. Implement the Alert System backend following the spec from Phase 2.

1. First, read the `api-scaffold` skill: `.github/skills/api-scaffold/SKILL.md` and its templates
2. Also read the active instructions for backend files: `.github/instructions/dotnet.instructions.md` and `.github/instructions/api-design.instructions.md`
3. Following the skill templates and instruction conventions, create:
   - `src/backend/PulseBoard.Api/Models/Alert.cs` — sealed record with required properties, plus `CreateAlertRequest` DTO
   - `src/backend/PulseBoard.Api/Services/AlertsService.cs` — `IAlertsService` interface + implementation with in-memory storage and simulated alert data
   - `src/backend/PulseBoard.Api/Controllers/AlertsController.cs` — full CRUD with ApiResponse<T> wrapping
4. Register `IAlertsService` in `src/backend/PulseBoard.Api/Program.cs`
5. After each file creation, note which instructions and skills guided the implementation

---

## PHASE 4: Frontend Implementation with Skills

**Demonstrates: Skills (component-library, api-client) + Instructions (nextjs)**

Now act as `@frontend-dev`. Implement the Alert System frontend.

1. Read the `component-library` skill: `.github/skills/component-library/SKILL.md`, its template and styles guide
2. Read the `api-client` skill: `.github/skills/api-client/SKILL.md`
3. Read the active Next.js instructions: `.github/instructions/nextjs.instructions.md`
4. Following the skills and instructions:
   - Add alert types and API client functions to `src/frontend/lib/api-client.ts` (following the api-client skill pattern)
   - Create `src/frontend/components/AlertsBanner.tsx` — shows active alerts with severity-colored badges, following the component-library design system (card pattern, color tokens, named export)
   - Create `src/frontend/app/alerts/page.tsx` — alerts management page with list, create form, and delete
5. Integrate the `AlertsBanner` into the main dashboard at `src/frontend/app/page.tsx` (add it above the metrics grid)
6. After each file, note which skill templates and design tokens were applied

---

## PHASE 5: Secret Scan Hook Demo

**Demonstrates: Hooks (PreToolUse — secret-scan.ps1)**

This phase shows how hooks act as automated quality gates.

1. Explain that a `PreToolUse` hook runs `scripts/secret-scan.ps1` before every file edit
2. Read the hook configuration from `.github/hooks/hooks.json`
3. Read the secret scan script `scripts/secret-scan.ps1` and explain how it works (regex patterns, exit code 2 = block)
4. NOW, intentionally create a file `src/backend/PulseBoard.Api/Services/NotificationService.cs` that contains a hardcoded secret:

```csharp
namespace PulseBoard.Api.Services;

public sealed class NotificationService
{
    private const string ApiKey = "sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234";

    public async Task SendAlertNotification(string alertName, string severity)
    {
        // This should be blocked by the secret scan hook!
        var client = new HttpClient();
        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {ApiKey}");
        await client.PostAsync("https://api.notifications.example.com/send", null);
    }
}
```

5. Whether the hook blocks it or not, explain what SHOULD happen: the `secret-scan.ps1` detects the pattern `sk-[A-Za-z0-9]{48}` and returns exit code 2, blocking the edit with a message about using environment variables instead.
6. Then create the CORRECT version without the hardcoded secret:

```csharp
namespace PulseBoard.Api.Services;

public sealed class NotificationService(IConfiguration configuration)
{
    public async Task SendAlertNotification(string alertName, string severity)
    {
        var apiKey = configuration["Notifications:ApiKey"]
            ?? throw new InvalidOperationException("Notifications:ApiKey is not configured");

        var client = new HttpClient();
        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
        await client.PostAsync("https://api.notifications.example.com/send", null);
    }
}
```

---

## PHASE 6: Code Review

**Demonstrates: Agents (reviewer role) + review checklist**

Now act as `@reviewer`. You have READ-ONLY access.

1. Read the reviewer agent definition: `.github/agents/reviewer.agent.md`
2. Review ALL the files created in Phases 3-5 against the review checklist from the agent definition
3. For each file, provide structured feedback using severity levels: `nit:`, `suggestion:`, `issue:`, `blocker:`
4. Provide a final verdict: APPROVE or REQUEST CHANGES with reasoning
5. Mention that in a real workflow, this review would be posted as GitHub PR comments via the GitHub MCP server

---

## PHASE 7: E2E Test with Skill

**Demonstrates: Skills (e2e-test)**

1. Read the `e2e-test` skill: `.github/skills/e2e-test/SKILL.md` and its template
2. Create `src/frontend/e2e/alerts.spec.ts` — a Playwright E2E test for the alerts feature:
   - Test that the alerts page loads
   - Test that the alerts banner appears on the dashboard
   - Test creating a new alert
   - Test deleting an alert
   - Follow the template: beforeEach, data-testid selectors, await expect assertions
3. Note how the testing instructions from `.github/instructions/testing.instructions.md` auto-apply to this file

---

## PHASE 8: Hook Scripts Overview

**Demonstrates: Hooks (all 4 hooks)**

1. Read all 4 hook scripts and `.github/hooks/hooks.json`
2. Create a summary table showing:
   - Hook event → script → what it does → when it fires → demo impact
3. Explain how the `format-check.ps1` (PostToolUse) has been running after every file edit in Phases 3-5
4. Explain how the `test-runner.ps1` (PostToolUse) looks for matching test files after edits
5. Explain how `session-welcome.ps1` (SessionStart) showed the project status at the beginning

---

## PHASE 9: MCP Servers

**Demonstrates: MCP Servers configuration**

1. Read `.vscode/mcp.json`
2. Explain the two configured MCP servers:
   - **GitHub MCP** (HTTP): Used by `@reviewer` to read PRs, leave comments, approve/reject — enables code review directly from chat
   - **Playwright MCP** (stdio): Used by `@frontend-dev` for browser automation, screenshots, accessibility audits — enables visual testing from chat
3. Show how agents reference MCP tools in their definitions (read relevant sections from `reviewer.agent.md` and `frontend-dev.agent.md`)

---

## FINAL SUMMARY

Print a comprehensive summary:

```
╔══════════════════════════════════════════════════════════════════╗
║              AGENT CUSTOMIZATIONS DEMO — COMPLETE               ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  ✅ Phase 1: INSTRUCTIONS     — Auto-applied by file type        ║
║  ✅ Phase 2: AGENTS           — Architect designed with handoffs ║
║  ✅ Phase 3: SKILLS (backend) — api-scaffold created full stack  ║
║  ✅ Phase 4: SKILLS (frontend)— component-library + api-client   ║
║  ✅ Phase 5: HOOKS            — Secret scan blocked bad code     ║
║  ✅ Phase 6: AGENTS (reviewer)— Code review with checklist       ║
║  ✅ Phase 7: SKILLS (e2e-test)— Playwright test from template    ║
║  ✅ Phase 8: HOOKS (all)      — 4 automated quality gates        ║
║  ✅ Phase 9: MCP SERVERS      — GitHub + Playwright connected    ║
║                                                                  ║
║  Files created: ~8 new files                                     ║
║  Customizations exercised: 6/6                                   ║
║  Agents used: architect, frontend-dev, backend-dev, reviewer     ║
║  Skills used: api-scaffold, component-library, api-client,       ║
║               e2e-test                                           ║
║  Hooks fired: secret-scan (blocked), format-check, test-runner,  ║
║               session-welcome                                    ║
║  MCP servers: GitHub (reviewer), Playwright (frontend-dev)       ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

List all files that were created or modified during the demo.
