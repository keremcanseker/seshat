"use client";

import { type ReactNode } from "react";

const API_BASE =
  process.env.NEXT_PUBLIC_SESHAT_API ?? "https://api.seshat.page";

type Props = {
  href: string;
  className?: string;
  children: ReactNode;
  platform?: string;
};

export function DownloadButton({
  href,
  className,
  children,
  platform = "macos",
}: Props) {
  const onClick = () => {
    const url = `${API_BASE}/downloads`;
    const payload = JSON.stringify({
      platform,
      referrer: typeof document !== "undefined" ? document.referrer : null,
    });
    try {
      if (
        typeof navigator !== "undefined" &&
        typeof navigator.sendBeacon === "function"
      ) {
        const blob = new Blob([payload], { type: "application/json" });
        navigator.sendBeacon(url, blob);
        return;
      }
    } catch {
      // fall through to fetch
    }
    try {
      fetch(url, {
        method: "POST",
        keepalive: true,
        headers: { "content-type": "application/json" },
        body: payload,
      }).catch(() => {});
    } catch {
      // never block the download
    }
  };

  return (
    <a href={href} download className={className} onClick={onClick}>
      {children}
    </a>
  );
}
