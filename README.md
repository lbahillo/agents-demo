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

### 🤖 Agents (5 agents)

| Agent | Role | Tools | Handoffs to |
|-------|------|-------|-------------|
| `@orchestrator` | Planner & Orchestrator | Read-only + memory + askQuestions | agent (via "Start Implementation" handoff) |
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

### ⚡ Prompts (4 slash commands)

| Command | Routes to | Description |
|---------|-----------|-------------|
| `/demo` | `@orchestrator` | Full agent customizations demo with automated orchestration |
| `/new-feature` | `@architect` | Full feature workflow: design → implement → review |
| `/dashboard-widget` | `@frontend-dev` | Quick dashboard widget creation |
| `/api-endpoint` | `@backend-dev` | Quick API endpoint creation |

**What to show:** Type `/demo` — it routes to `@orchestrator` who researches the codebase, presents a plan, and after approval orchestrates all specialized agents automatically.

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

## Demo Guide

The entire demo runs from a **single entry point** with automated orchestration.

### How to Run

1. Open the prompt picker in Copilot Chat and run **`/demo`**
2. `@orchestrator` researches the codebase and presents a detailed plan
3. Review the plan — the orchestrator will ask clarifying questions if needed
4. Click **"Start Implementation"** to approve
5. Watch as specialized agents are invoked automatically in sequence

### What You'll See

After clicking "Start Implementation", the following happens automatically:

| Phase | Agent | What Happens | Customizations Showcased |
|-------|-------|--------------|-------------------------|
| Backend | `@backend-dev` | Creates Alert model, service, controller, DI registration | **Skills** (api-scaffold), **Instructions** (dotnet + api-design), **Hooks** (format-check, test-runner) |
| Secret Scan | `@backend-dev` | Tries to write a hardcoded API key — gets **blocked** | **Hooks** (secret-scan.ps1 PreToolUse, exit code 2) |
| Frontend | `@frontend-dev` | Creates AlertsBanner, alerts page, updates api-client.ts | **Skills** (component-library, api-client), **Instructions** (nextjs), **Hooks** (format-check) |
| E2E Tests | `@frontend-dev` | Writes Playwright tests for alerts feature | **Skills** (e2e-test), **MCP** (Playwright), **Instructions** (testing) |
| Review | `@reviewer` | Reviews all changes, checks conventions | **Agents** (read-only), **MCP** (GitHub) |

All 6 customization types are demonstrated: **Instructions**, **Agents**, **Skills**, **Hooks**, **MCP Servers**, and **Prompts**.

### Verify & Reset

```powershell
# Run verify-demo prompt to check all expected files exist
# Then reset the workspace for another run:
.\scripts\reset-demo.ps1
```

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
│   │   ├── orchestrator.agent.md     # Planner & Orchestrator (read-only, plans)
│   │   ├── architect.agent.md          # Solutions Architect (read-only, designs)
│   │   ├── frontend-dev.agent.md       # Frontend Developer (Next.js, Playwright)
│   │   ├── backend-dev.agent.md        # Backend Developer (.NET, EF Core)
│   │   └── reviewer.agent.md           # Code Reviewer (GitHub MCP)
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
│   │   ├── demo.prompt.md              # /demo — full orchestrated demo
│   │   ├── new-feature.prompt.md       # /new-feature slash command
│   │   ├── dashboard-widget.prompt.md  # /dashboard-widget slash command
│   │   ├── api-endpoint.prompt.md      # /api-endpoint slash command
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
