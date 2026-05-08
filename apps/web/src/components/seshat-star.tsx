type Props = {
  size?: number;
  variant?: "fill" | "stroke";
  className?: string;
  strokeWidth?: number;
};

const STAR_PATH =
  "M14 0 L16.50 8.82 L24.95 5.27 L19.61 12.72 L27.65 17.12 L18.50 17.58 L20.07 26.61 L14 19.75 L7.93 26.61 L9.50 17.58 L0.35 17.12 L8.39 12.72 L3.05 5.27 L11.50 8.82 Z";

export function SeshatStar({
  size = 8,
  variant = "fill",
  className,
  strokeWidth = 2,
}: Props) {
  return (
    <svg
      viewBox="0 0 28 28"
      width={size}
      height={size}
      className={className}
      aria-hidden="true"
    >
      <path
        d={STAR_PATH}
        fill={variant === "fill" ? "currentColor" : "none"}
        stroke={variant === "stroke" ? "currentColor" : "none"}
        strokeWidth={variant === "stroke" ? strokeWidth : 0}
        strokeLinejoin="round"
      />
    </svg>
  );
}
