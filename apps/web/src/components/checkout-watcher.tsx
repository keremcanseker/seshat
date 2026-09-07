"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

/**
 * The plan only flips when Polar's webhook reaches our server, which lands a
 * moment after the browser returns from checkout. Refresh the page a few times
 * over ten seconds rather than trusting the success redirect.
 */
export function CheckoutWatcher({ pending }: { pending: boolean }) {
  const router = useRouter();
  const [gaveUp, setGaveUp] = useState(false);

  useEffect(() => {
    if (!pending) return;
    let tries = 0;
    const timer = setInterval(() => {
      tries += 1;
      if (tries > 5) {
        clearInterval(timer);
        setGaveUp(true);
        return;
      }
      router.refresh();
    }, 2000);
    return () => clearInterval(timer);
  }, [pending, router]);

  if (!pending) return null;

  return (
    <p className="border-gold-soft text-ink-muted mb-6 rounded-lg border-[0.5px] px-5 py-3.5 text-[13px]">
      {gaveUp
        ? "Payment received. Your plan is taking longer than usual to update, refresh in a minute."
        : "Confirming your payment with Polar..."}
    </p>
  );
}
