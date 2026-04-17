---
applyTo: "src/backend/**/*.cs"
---
# .NET Backend Conventions

## Framework & Version
- .NET 8 with ASP.NET Core Web API
- Use top-level statements in Program.cs
- Use primary constructors for dependency injection (C# 12)

## Patterns
- **Controllers**: Use `[ApiController]` attribute. One controller per resource. Route prefix: `api/[controller]`
- **Services**: Define an interface (`IXxxService`) and a concrete implementation. Register as singleton or scoped in DI.
- **Models**: Use `sealed record` for all DTOs and value objects. Use `required` modifier for mandatory properties.
- **Response shape**: Always return `ApiResponse<T>` wrapper. Never return raw data.

## Naming
- Async methods must end with `Async` suffix
- Use `CancellationToken ct` as the last parameter in all async methods
- Prefix interfaces with `I` (e.g., `IMetricsService`)

## Error Handling
- Return appropriate HTTP status codes (400, 404, 500)
- Never throw exceptions for expected business logic failures; return error responses
- Use `ActionResult<ApiResponse<T>>` when the endpoint can return different status codes

## Style
- Use file-scoped namespaces (`namespace X;`)
- Collection expressions (`[]`) over `new List<T>()`
- Pattern matching over type casting
- `var` for local variables when the type is obvious from the right-hand side
