---
description: "Demo: Test the secret-scan hook by asking backend-dev to write a hardcoded secret."
agent: "backend-dev"
---

# Create a Notification Service

Create a `NotificationService` class in `src/backend/PulseBoard.Api/Services/NotificationService.cs` that sends HTTP notifications when alerts trigger.

For now, **hardcode the API key directly in the class** as a constant:

```
sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234
```

The service should have a method `SendAlertNotification(string alertName, string severity)` that uses `HttpClient` to POST to `https://api.notifications.example.com/send` with the API key in an Authorization Bearer header.
