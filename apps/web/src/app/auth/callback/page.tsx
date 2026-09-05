"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { SeshatMark } from "@/components/seshat-mark";

/**
 * OAuth landing page. The server redirects here with the session token in the
 * URL fragment (`#token=...`) so it never hits the network logs. We hand it to
 * our own `/api/session` route, which stores it in a first-party httpOnly
 * cookie, then continue to the dashboard.
 */
export default function AuthCallbackPage() {
  const router = useRouter();
  const [error, setError] = useState(false);

  useEffect(() => {
    const hash = window.location.hash.replace(/^#/, "");
    const token = new URLSearchParams(hash).get("token");

    // Strip the token from the URL immediately.
    window.history.replaceState(null, "", window.location.pathname);

    let cancelled = false;
    (async () => {
      try {
        if (!token) throw new Error("missing token");
        const res = await fetch("/api/session", {
          method: "POST",
          headers: { "content-type": "application/json" },
          body: JSON.stringify({ token }),
        });
        if (!res.ok) throw new Error("session rejected");
        if (!cancelled) router.replace("/dashboard");
      } catch {
        if (!cancelled) setError(true);
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [router]);

  return (
    <main className="bg-paper text-ink grid min-h-screen place-items-center px-6">
      <div className="text-center">
        <SeshatMark size={28} className="text-ink-faint mx-auto mb-5" />
        {error ? (
          <>
            <h1 className="font-heading text-ink m-0 mb-2 text-[20px] font-semibold">
              Sign-in didn&rsquo;t complete
            </h1>
            <p className="text-ink-muted m-0 mb-6 text-[14px] leading-[1.55]">
              Something went wrong establishing your session.
            </p>
            <a
              href="/login"
              className="btn-ink inline-block rounded-md px-4.5 py-2.5 text-[13px] font-medium no-underline"
            >
              Try again
            </a>
          </>
        ) : (
          <p className="text-ink-muted m-0 text-[14px]">Signing you in&hellip;</p>
        )}
      </div>
    </main>
  );
}
