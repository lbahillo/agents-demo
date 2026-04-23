---
name: database-migration
description: "Create and manage EF Core database migrations for PulseBoard. Includes pre/post validation, rollback strategy, and data seeding."
argument-hint: "Describe the schema change (e.g., 'Add Alerts table with severity and timestamp columns')"
user-invocable: true
disable-model-invocation: false
---

# Database Migration Skill

Create and manage EF Core database migrations for PulseBoard.

## Migration Workflow

1. **Define/update the entity** in `Models/` as a sealed record
2. **Update the DbContext** if adding a new entity (add `DbSet<T>`)
3. **Create the migration** using EF Core CLI
4. **Review** the generated migration code
5. **Validate** using the [migration checklist](./migration-checklist.md)
6. **Apply** the migration

## Commands

```bash
# Create a new migration
dotnet ef migrations add {MigrationName} --project src/backend/PulseBoard.Api

# Apply pending migrations
dotnet ef database update --project src/backend/PulseBoard.Api

# Rollback to a specific migration  
dotnet ef database update {PreviousMigrationName} --project src/backend/PulseBoard.Api

# Generate SQL script (for production)
dotnet ef migrations script --project src/backend/PulseBoard.Api --idempotent
```

## Naming Conventions

- Migration name: `Add{Entity}Table`, `Add{Column}To{Table}`, `Remove{Column}From{Table}`
- Entity names: PascalCase, singular (e.g., `Alert`, `MetricSnapshot`)
- Table names: Follow EF Core defaults (pluralized entity names)

## Entity Pattern

```csharp
public sealed record AlertEntity
{
    public required string Id { get; init; }
    public required string Title { get; init; }
    public required AlertSeverity Severity { get; init; }
    public required DateTimeOffset CreatedAt { get; init; }
    public DateTimeOffset? ResolvedAt { get; init; }
}

public enum AlertSeverity { Info, Warning, Critical }
```

## Rules

1. Every migration must be **reversible** — always define both Up and Down methods
2. Never modify data in migrations — use seed scripts separately
3. Always generate an **idempotent SQL script** for production deployments
4. Large data migrations must be done in **batches** to avoid timeouts
