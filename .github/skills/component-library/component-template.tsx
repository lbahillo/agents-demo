// Component Template for PulseBoard
// Copy this structure when creating new components.

interface TemplateComponentProps {
  /** Primary display text */
  title: string;
  /** Optional secondary text */
  description?: string;
  /** Visual variant */
  variant?: "default" | "accent" | "danger";
  /** Content to render inside the component */
  children?: React.ReactNode;
}

export function TemplateComponent({
  title,
  description,
  variant = "default",
  children,
}: TemplateComponentProps) {
  const variantStyles = {
    default: "border-gray-800 bg-gray-900",
    accent: "border-indigo-500/20 bg-indigo-500/5",
    danger: "border-red-500/20 bg-red-500/5",
  };

  return (
    <div
      className={`rounded-xl border p-6 transition-shadow hover:shadow-lg ${variantStyles[variant]}`}
    >
      <h3 className="text-lg font-semibold">{title}</h3>
      {description && (
        <p className="mt-1 text-sm text-gray-400">{description}</p>
      )}
      {children && <div className="mt-4">{children}</div>}
    </div>
  );
}
