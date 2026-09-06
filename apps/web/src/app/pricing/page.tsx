import type { Metadata } from "next";
import Link from "next/link";
import { PricingCards } from "@/components/pricing-cards";
import { SeshatMark } from "@/components/seshat-mark";
import { getCurrentUser } from "@/lib/auth";
import { fetchPlans } from "@/lib/plans";
import { SESHAT_API_BASE } from "@/lib/session";

export const metadata: Metadata = {
  title: "Pricing · Seshat",
  description: "The reader is free. Seshat Premium is for sharing more than one link.",
};

export default async function PricingPage() {
  const [plans, user] = await Promise.all([fetchPlans(), getCurrentUser()]);

  return (
    <main className="bg-paper text-ink min-h-screen font-sans">
      <header className="border-rule border-b-[0.5px] px-8 py-5 sm:px-12">
        <div className="mx-auto flex max-w-[920px] items-center justify-between">
          <Link
            href="/"
            className="text-ink hover:text-ink-muted flex items-center gap-2.5 transition-colors"
            aria-label="Seshat home"
          >
            <SeshatMark size={20} />
            <span className="font-heading text-[16px] font-semibold tracking-[-0.005em]">
              Seshat
            </span>
          </Link>
          <Link
            href={user ? "/dashboard" : "/login"}
            className="text-ink-muted hover:text-ink text-[13px] transition-colors"
          >
            {user ? "Your pages" : "Sign in"}
          </Link>
        </div>
      </header>

      <section className="mx-auto max-w-[920px] px-8 py-12 sm:px-12">
        <div className="mb-10 max-w-[560px]">
          <p className="text-ink-faint mb-3 font-mono text-[11px] tracking-[0.1em] uppercase">
            Pricing
          </p>
          <h1 className="font-heading text-ink m-0 text-[36px] font-bold tracking-[-0.012em]">
            Read for free. Share more with Premium.
          </h1>
          <p className="text-ink-muted mt-3 text-[15px] leading-[1.6]">
            The reader is free and nothing local is locked: reading, the library,
            the outline, dark mode and the CLI stay free. Every account also gets one
            permanent share link. Premium is for sharing beyond that.
          </p>
        </div>

        <PricingCards
          plans={plans}
          signedIn={user !== null}
          downloadHref={`${SESHAT_API_BASE}/download`}
        />

        <p className="text-ink-faint mt-8 text-[12px] leading-[1.6]">
          If you cancel, your links stay online. Documents above the free allowance
          become read-only; nothing is deleted. Payments are handled by Polar.
        </p>
      </section>
    </main>
  );
}
