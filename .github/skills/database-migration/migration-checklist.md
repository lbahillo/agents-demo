# Migration Checklist

Run through this checklist before and after applying any database migration.

## Pre-Migration

- [ ] Entity model is defined as `sealed record` with `required` properties
- [ ] DbContext has the new `DbSet<T>` property (if new entity)
- [ ] Migration was created successfully: `dotnet ef migrations add {Name}`
- [ ] Review the generated `Up()` method — does it match your intent?
- [ ] Review the generated `Down()` method — is it a clean rollback?
- [ ] No data loss in the migration (check for dropped columns with data)
- [ ] Default values provided for new non-nullable columns on existing tables
- [ ] Indexes added for columns used in WHERE clauses or JOINs

## Post-Migration

- [ ] Migration applied successfully: `dotnet ef database update`
- [ ] Application starts without errors
- [ ] Existing API endpoints still work (no regressions)
- [ ] New endpoints return expected data shapes
- [ ] Idempotent SQL script generated for production: `dotnet ef migrations script --idempotent`

## Rollback Plan

- [ ] Document the rollback command: `dotnet ef database update {PreviousMigration}`
- [ ] Verify rollback works in development before applying to production
- [ ] If migration includes data changes, have a reversibility plan

## Red Flags

Stop and reconsider if:
- Migration drops a column that has production data
- Migration renames a table (prefer add new + migrate data + drop old)
- Migration is very large (> 50 lines of SQL) — break it into smaller steps
- Multiple developers are creating migrations at the same time (merge conflicts)
