---
name: api-scaffold
description: "Scaffold a complete .NET API endpoint: controller, service interface + implementation, and model — all wired up with dependency injection."
argument-hint: "The resource name and operations (e.g., 'Alerts resource with CRUD operations')"
user-invocable: true
disable-model-invocation: false
---

# API Scaffold Skill

Scaffold a complete .NET 8 API endpoint stack in one go.

## What Gets Created

For a resource named `{Resource}`, this skill creates:

| File | Location | Purpose |
|------|----------|---------|
| `{Resource}.cs` | `Models/` | Sealed record DTOs for the resource |
| `I{Resource}Service.cs` + `{Resource}Service.cs` | `Services/` | Service interface and implementation |
| `{Resource}Controller.cs` | `Controllers/` | API controller with standard endpoints |

Plus registration in `Program.cs` DI container.

## Templates

Follow these templates for consistent scaffolding:

### Model Template
See [controller template](./controller-template.cs) and [service template](./service-template.cs) for the exact patterns to follow.

### Standard Endpoints

Every resource gets these endpoints by default:

| Method | Route | Action | Response |
|--------|-------|--------|----------|
| GET | `/api/{resources}` | List (paginated) | `ApiResponse<{ items, totalCount }>` |
| GET | `/api/{resources}/{id}` | Get by ID | `ApiResponse<Resource>` |
| POST | `/api/{resources}` | Create | `ApiResponse<Resource>` (201) |
| PUT | `/api/{resources}/{id}` | Update | `ApiResponse<Resource>` |
| DELETE | `/api/{resources}/{id}` | Delete | 204 No Content |

### DI Registration

After creating the files, register the service in `Program.cs`:

```csharp
builder.Services.AddSingleton<I{Resource}Service, {Resource}Service>();
```

## Rules

1. All DTOs must be `sealed record` with `required` properties
2. All controllers must use `[ApiController]` and primary constructors
3. All async methods must accept `CancellationToken` as last parameter
4. All responses must use `ApiResponse<T>` wrapper
5. Controllers must be thin — business logic lives in services
