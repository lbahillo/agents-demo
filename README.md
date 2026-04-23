# PulseBoard — Agent Customizations Showcase

A real-time analytics dashboard built with **Next.js 15** + **.NET 8** that demonstrates every GitHub Copilot Agent Customization working together as a cohesive AI-powered development workflow.

> **This project is a showcase.** The app code is a minimal prop — the agent customizations are the star.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        PulseBoard Workspace                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   INSTRUCTIONS        AGENTS            SKILLS          PROMPTS         │
│   ┌───────────┐     ┌───────────┐     ┌──────────┐   ┌──────────┐     │
│   │ Global     │     │@architect │     │component │   │/new-     │     │
│   │ .NET       │     │@frontend  │────▶│-library  │   │ feature  │     │
│   │ Next.js    │     │@backend   │────▶│api-      │   │/dashboard│     │
│   │ Testing    │     │@reviewer  │     │ scaffold │   │ -widget  │     │
│   │ API Design │     │           │     │e2e-test  │   │/api-     │     │
│   └───────────┘     └─────┬─────┘     │db-migrate│   │ endpoint │     │
│         │                 │           │api-client│   └──────────┘     │
│         ▼                 │           └──────────┘                     │
│   Auto-apply by          │                                             │
│   file glob pattern       ▼                                             │
│                     ┌───────────┐     ┌──────────┐                     │
│                     │ HANDOFFS  │     │MCP SERVER│                     │
│                     │           │     │          │                     │
│                     │ architect │     │ GitHub   │◀── @reviewer        │
│                     │  ──▶ devs │     │Playwright│◀── @frontend-dev   │
│                     │ devs ──▶  │     │          │                     │
│                     │  reviewer │     └──────────┘                     │
│                     └───────────┘                                       │
│                                                                         │
│   HOOKS (Automated Quality Gates)                                       │
│   ┌─────────────────────────────────────────────────────────────┐       │
│   │ SessionStart ──▶ session-welcome.ps1 (project status)       │       │
│   │ PreToolUse   ──▶ secret-scan.ps1     (blocks secrets)       │       │
│   │ PostToolUse  ──▶ format-check.ps1    (auto-format)          │       │
│   │ PostToolUse  ──▶ test-runner.ps1     (auto-test)            │       │
│   └─────────────────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Customization Inventory

### 📋 Instructions (5 files)

| File | Scope | Auto-applies to |
|------|-------|-----------------|
| `.github/copilot-instructions.md` | Global | All conversations |
| `.github/instructions/dotnet.instructions.md` | .NET | `src/backend/**/*.cs` |
| `.github/instructions/nextjs.instructions.md` | Next.js | `src/frontend/**/*.tsx` |
| `.github/instructions/testing.instructions.md` | Testing | `**/*.test.*`, `**/*.spec.*` |
| `.github/instructions/api-design.instructions.md` | API Design | `**/Controllers/**` |

**What to show:** Open a `.cs` file — the .NET instructions auto-apply. Open a `.tsx` file — the Next.js instructions auto-apply. Each context gets specialized guidance without manual configuration.

---

### 🤖 Agents (4 agents)

| Agent | Role | Tools | Handoffs to |
|-------|------|-------|-------------|
| `@architect` | Solutions Architect | Read-only (codeSearch, readFile) | frontend-dev, backend-dev, reviewer |
| `@frontend-dev` | Next.js Developer | Full access + Playwright MCP | reviewer, backend-dev |
| `@backend-dev` | .NET Developer | Full access | reviewer, frontend-dev |
| `@reviewer` | Code Reviewer | Read-only + GitHub MCP | architect, frontend-dev, backend-dev |

**What to show:**
1. `@architect` can only read code — it designs, then hands off via buttons
2. `@frontend-dev` has agent-scoped hooks (PostToolUse auto-format)
3. `@reviewer` uses GitHub MCP to comment on real PRs
4. Handoff buttons create seamless multi-agent workflows

---

### 🧠 Skills (5 skills)

| Skill | Purpose | Template Files |
|-------|---------|----------------|
| `component-library` | Create components following design system | `component-template.tsx`, `styles-guide.md` |
| `api-scaffold` | Scaffold .NET controller + service + model | `controller-template.cs`, `service-template.cs` |
| `e2e-test` | Write Playwright E2E tests | `test-template.spec.ts` |
| `database-migration` | Manage EF Core migrations | `migration-checklist.md` |
| `api-client` | Generate TypeScript API client functions | `client-template.ts` |

**What to show:** Skills are referenced by agents — when `@frontend-dev` creates a component, it automatically follows the `component-library` skill templates and design system.

---

### ⚡ Prompts (3 slash commands)

| Command | Routes to | Description |
|---------|-----------|-------------|
| `/new-feature` | `@architect` | Full feature workflow: design → implement → review |
| `/dashboard-widget` | `@frontend-dev` | Quick dashboard widget creation |
| `/api-endpoint` | `@backend-dev` | Quick API endpoint creation |

**What to show:** Type `/new-feature Add an alerts system` — it routes to `@architect` who designs the feature, then hands off to `@backend-dev` and `@frontend-dev` for implementation.

---

### 🪝 Hooks (4 hooks)

| Event | Script | Effect |
|-------|--------|--------|
| `SessionStart` | `session-welcome.ps1` | Displays project status and available agents |
| `PreToolUse` | `secret-scan.ps1` | **BLOCKS** file edits containing hardcoded secrets (exit 2) |
| `PostToolUse` | `format-check.ps1` | Auto-formats .ts/.tsx with Prettier, .cs with dotnet format |
| `PostToolUse` | `test-runner.ps1` | Finds and runs relevant tests after code changes |

**What to show:**
1. Start a new session — see welcome message with project status
2. Ask an agent to add `apiKey = "sk-test123..."` — the secret scan blocks it
3. Ask an agent to edit a file — it gets auto-formatted after the edit
4. Edit a component — the test runner looks for matching test files

---

### 🔌 MCP Servers (2 servers)

| Server | Type | Used by | Purpose |
|--------|------|---------|---------|
| GitHub | HTTP | `@reviewer` | Read PRs, leave review comments, approve/request changes |
| Playwright | stdio | `@frontend-dev` | Browser automation, screenshots, E2E testing |

**What to show:** `@reviewer` can read a real GitHub PR, analyze the changes, and leave structured review comments — all through MCP tools.

---

## Demo Guide (Interactive)

Run each step in VS Code Copilot Chat. Each step uses a **real agent** via the prompt's `agent:` field — no roleplay.

### Step 1 — Architecture Design (`@architect`)
Open the prompt picker and run **demo-1-design**.
`@architect` explores the codebase (read-only), produces a technical spec, then offers **handoff buttons** to `@backend-dev` and `@frontend-dev`.

> **Shows:** Agents, Handoffs, Instructions (auto-applied), read-only tool restrictions

### Step 2 — Backend Implementation (`@backend-dev`)
Click the handoff button to `@backend-dev`, or manually invoke `@backend-dev` and paste the spec.
The agent uses the **api-scaffold** skill to create `Alert` model, `AlertsService`, and `AlertsController`. It also registers DI in `Program.cs`.

> **Shows:** Skills (api-scaffold), Instructions (dotnet + api-design auto-apply), PostToolUse hooks (format-check, test-runner)

### Step 3 — Secret Scan Block (`@backend-dev`)
Run **demo-3-secret-test**.
`@backend-dev` tries to write a file with a hardcoded API key. The **PreToolUse hook** intercepts and blocks it.

> **Shows:** Hooks (secret-scan.ps1 exits with code 2), the agent recovers and suggests environment variables

### Step 4 — Frontend Implementation (`@frontend-dev`)
Hand off to `@frontend-dev` or invoke directly. Ask it to build the `AlertsBanner` component and `/alerts` page, and update `api-client.ts`.
The agent uses the **component-library** and **api-client** skills.

> **Shows:** Skills (component-library, api-client), Instructions (nextjs auto-apply), agent-scoped PostToolUse hooks

### Step 5 — E2E Tests (`@frontend-dev`)
Run **demo-4-e2e**.
`@frontend-dev` uses the **e2e-test** skill and **Playwright MCP** to create `alerts.spec.ts`.

> **Shows:** Skills (e2e-test), MCP Servers (Playwright), Instructions (testing auto-apply)

### Step 6 — Code Review (`@reviewer`)
Run **demo-5-review**.
`@reviewer` reviews all changes (read-only). If a PR exists, it uses **GitHub MCP** to leave review comments.

> **Shows:** Agents (reviewer, read-only), MCP Servers (GitHub), Handoffs back to devs

### Step 7 — Verify Results
Run **verify-demo** to check all expected files exist and follow conventions.

### Reset
```powershell
.\scripts\reset-demo.ps1
```
Restores the workspace to `demo-baseline` tag so you can run the demo again.

---

## File Structure

```
agents-demo/
├── .github/
│   ├── copilot-instructions.md          # Global project instructions
│   ├── instructions/
│   │   ├── dotnet.instructions.md       # .NET conventions (auto-applies to *.cs)
│   │   ├── nextjs.instructions.md       # Next.js conventions (auto-applies to *.tsx)
│   │   ├── testing.instructions.md      # Testing standards (auto-applies to *.test.*)
│   │   └── api-design.instructions.md   # API design (auto-applies to Controllers/)
│   ├── agents/
│   │   ├── architect.agent.md           # Solutions Architect (read-only, designs)
│   │   ├── frontend-dev.agent.md        # Frontend Developer (Next.js, Playwright)
│   │   ├── backend-dev.agent.md         # Backend Developer (.NET, EF Core)
│   │   └── reviewer.agent.md            # Code Reviewer (GitHub MCP)
│   ├── skills/
│   │   ├── component-library/           # Next.js component creation
│   │   │   ├── SKILL.md
│   │   │   ├── component-template.tsx
│   │   │   └── styles-guide.md
│   │   ├── api-scaffold/               # .NET API scaffolding
│   │   │   ├── SKILL.md
│   │   │   ├── controller-template.cs
│   │   │   └── service-template.cs
│   │   ├── e2e-test/                   # Playwright E2E tests
│   │   │   ├── SKILL.md
│   │   │   └── test-template.spec.ts
│   │   ├── database-migration/         # EF Core migrations
│   │   │   ├── SKILL.md
│   │   │   └── migration-checklist.md
│   │   └── api-client/                 # TypeScript API client
│   │       ├── SKILL.md
│   │       └── client-template.ts
│   ├── prompts/
│   │   ├── new-feature.prompt.md       # /new-feature slash command
│   │   ├── dashboard-widget.prompt.md  # /dashboard-widget slash command
│   │   ├── api-endpoint.prompt.md      # /api-endpoint slash command
│   │   ├── demo-1-design.prompt.md     # Demo step 1 → @architect
│   │   ├── demo-3-secret-test.prompt.md # Demo step 3 → @backend-dev
│   │   ├── demo-4-e2e.prompt.md        # Demo step 4 → @frontend-dev
│   │   ├── demo-5-review.prompt.md     # Demo step 5 → @reviewer
│   │   └── verify-demo.prompt.md       # Post-demo verification
│   └── hooks/
│       └── hooks.json                  # Hook event configuration
├── .vscode/
│   └── mcp.json                        # MCP server configuration
├── scripts/
│   ├── secret-scan.ps1                 # PreToolUse: blocks hardcoded secrets
│   ├── format-check.ps1               # PostToolUse: auto-formats code
│   ├── test-runner.ps1                 # PostToolUse: runs relevant tests
│   └── session-welcome.ps1            # SessionStart: project status
├── src/
│   ├── frontend/                       # Next.js 15 App
│   │   ├── app/
│   │   │   ├── layout.tsx
│   │   │   ├── globals.css
│   │   │   └── page.tsx               # Dashboard page
│   │   ├── components/
│   │   │   ├── DashboardCard.tsx      # Metric card component
│   │   │   └── MetricsChart.tsx       # Bar chart component
│   │   └── lib/
│   │       └── api-client.ts          # Typed API client
│   └── backend/
│       └── PulseBoard.Api/
│           ├── Controllers/
│           │   └── MetricsController.cs
│           ├── Services/
│           │   └── MetricsService.cs
│           ├── Models/
│           │   └── Metric.cs
│           └── Program.cs
└── README.md
```
