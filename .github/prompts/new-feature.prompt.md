---
description: "Design and implement a complete feature end-to-end. Starts with the architect for system design, then delegates to frontend and backend developers for implementation."
agent: "architect"
model: "Claude Sonnet 4 (copilot)"
tools:
  - "codeSearch"
  - "readFile"
  - "listDirectory"
---

# New Feature Workflow

You are starting a full feature design and implementation workflow.

## Process

1. **Architecture Phase** (you are here — @architect)
   - Analyze the feature request below
   - Explore the current codebase to understand existing patterns
   - Create a detailed technical spec with data models, API endpoints, and frontend components
   - Use handoffs to delegate implementation to the appropriate developer agents

2. **Implementation Phase** (after handoff)
   - `@backend-dev` implements the API: models, services, controllers
   - `@frontend-dev` implements the UI: components, pages, API client integration
   - Each developer uses their specialized skills

3. **Review Phase** (after implementation)
   - `@reviewer` checks the implementation against the spec and project conventions
   - Issues are sent back to the responsible developer via handoff

## Feature Request

The user wants the following feature:
