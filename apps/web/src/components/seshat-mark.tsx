type SeshatMarkProps = {
  size?: number;
  className?: string;
  /** Render the full goddess emblem (headdress + staff + star) or only the star. */
  starOnly?: boolean;
  withCircle?: boolean;
  strokeWidth?: number;
};

/**
 * The Seshat emblem mirrors the macOS app icon
 * (apps/macos/Seshat/Assets.xcassets/AppIcon.appiconset/icon_*.png):
 * a downward-curving headdress, a vertical staff, and the seven-pointed star.
 * Gold by default like the letterpress icon; pass a `text-*` class to override
 * (faint for empty states, ink for dense chrome).
 */
export function SeshatMark({
  size = 28,
  className = "text-gold",
  starOnly = false,
  withCircle = false,
  strokeWidth = 1.4,
}: SeshatMarkProps) {
  return (
    <svg
      viewBox="0 0 32 32"
      width={size}
      height={size}
      className={className}
      fill="none"
      stroke="currentColor"
      strokeWidth={strokeWidth}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      {withCircle ? (
        <circle cx="16" cy="16" r="14.25" opacity="0.18" />
      ) : null}

      {/* Headdress arc + connecting staff. Hidden when only the star is needed. */}
      {!starOnly ? (
        <>
          <path d="M 8.5 7.2 Q 16 2 23.5 7.2" />
          <path d="M 16 5.4 L 16 13.6" />
        </>
      ) : null}

      {/* Seven-pointed star, centered at (16, 21.5) when full emblem,
          centered at (16, 16) when starOnly. Two paths so the star can sit
          higher when the headdress is omitted. */}
      {starOnly ? (
        <path d="M 16 2 L 18.4 11 L 26.95 7.27 L 21.36 14.78 L 29.65 19.12 L 20.3 19.43 L 22.07 28.61 L 16 21.5 L 9.93 28.61 L 11.7 19.43 L 2.35 19.12 L 10.64 14.78 L 5.05 7.27 L 13.61 11 Z" />
      ) : (
        <path d="M 16 14 L 17.39 19.12 L 22.25 17.01 L 19.12 21.29 L 23.8 23.78 L 18.5 24 L 19.47 29.21 L 16 25.2 L 12.53 29.21 L 13.5 24 L 8.2 23.78 L 12.88 21.29 L 9.75 17.01 L 14.61 19.12 Z" />
      )}
    </svg>
  );
}
