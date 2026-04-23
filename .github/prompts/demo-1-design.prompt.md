---
description: "Start the demo: architect designs an Alert System, then hands off to dev agents via real handoff buttons."
agent: "architect"
---

# Demo: Design an Alert System for PulseBoard

PulseBoard needs a threshold-based **Alert System**. Users should be able to create alerts that trigger when a metric exceeds a threshold (e.g., "notify when error rate > 5%").

## Requirements

- **Alert** entity: name, metric name, threshold value, severity (info/warning/critical), enabled flag, created timestamp
- CRUD API endpoints following the existing `MetricsController` + `MetricsService` + `Metric` pattern
- **AlertsBanner** component on the dashboard showing active alerts with severity-colored badges
- **Alerts management page** at `/alerts` for creating and deleting alerts
- Typed API client functions added to the existing `api-client.ts`

## Your Task

1. Explore the current codebase to understand existing patterns
2. Produce a detailed technical spec: data models, API endpoints, frontend components, integration points
3. When the design is complete, use the **handoff buttons** to delegate implementation to `@backend-dev` and `@frontend-dev`
