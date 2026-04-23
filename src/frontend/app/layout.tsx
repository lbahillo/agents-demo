import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "PulseBoard - Real-time Analytics",
  description: "Real-time analytics dashboard for monitoring application metrics",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-gray-950 text-white antialiased">{children}</body>
    </html>
  );
}
