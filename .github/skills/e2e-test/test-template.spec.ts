import { test, expect } from "@playwright/test";

// Template: Replace {Feature} with the actual feature name.

test.describe("{Feature}", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/");
    // Wait for the page to fully load
    await expect(page.getByTestId("loading-spinner")).toBeHidden({
      timeout: 10_000,
    });
  });

  test("should display the main content", async ({ page }) => {
    // Arrange — page is already loaded via beforeEach

    // Act — no action needed for display tests

    // Assert
    await expect(page.getByTestId("{feature}-container")).toBeVisible();
  });

  test("should handle user interaction", async ({ page }) => {
    // Arrange
    const element = page.getByTestId("{feature}-interactive-element");

    // Act
    await element.click();

    // Assert
    await expect(page.getByTestId("{feature}-result")).toBeVisible();
  });

  test("should show error state on failure", async ({ page }) => {
    // Arrange — mock API failure
    await page.route("**/api/{feature}/**", (route) =>
      route.fulfill({
        status: 500,
        contentType: "application/json",
        body: JSON.stringify({
          data: null,
          success: false,
          error: "Internal server error",
        }),
      })
    );

    // Act
    await page.reload();

    // Assert
    await expect(page.getByTestId("error-message")).toBeVisible();
  });
});
