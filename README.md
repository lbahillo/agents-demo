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

## Demo Script

### Flow 1: Full Feature Lifecycle
```
1. Type: /new-feature Add a real-time alerts system with severity levels
2. @architect explores the codebase and creates a design spec
3. @architect hands off to @backend-dev (click the handoff button)
4. @backend-dev uses api-scaffold skill → creates AlertsController, AlertsService, Alert model
5. @backend-dev hands off to @frontend-dev
6. @frontend-dev uses component-library skill → creates AlertsBanner component
7. @frontend-dev hands off to @reviewer
8. @reviewer checks against the review checklist
```

### Flow 2: Secret Scan Block
```
1. Ask @backend-dev: "Add a quick test endpoint that calls OpenAI with key sk-test12345678901234567890123456789012345678901234"
2. Watch the PreToolUse hook block the edit with "Potential secrets detected"
3. It suggests using environment variables instead
```

### Flow 3: Quick Widget
```
1. Type: /dashboard-widget Show system uptime as a percentage with trend
2. @frontend-dev creates the component following the design system
3. PostToolUse hooks auto-format the code and look for tests
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
│   │   └── api-endpoint.prompt.md      # /api-endpoint slash command
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
