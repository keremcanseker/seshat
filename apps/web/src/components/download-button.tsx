import { type ReactNode } from "react";

type Props = {
  href: string;
  className?: string;
  children: ReactNode;
};

// The href points at the server's /download endpoint, which logs the click and
// redirects to the latest DMG — so no client-side analytics beacon is needed.
export function DownloadButton({ href, className, children }: Props) {
  return (
    <a href={href} className={className}>
      {children}
    </a>
  );
}
