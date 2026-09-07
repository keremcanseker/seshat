import type { Metadata } from "next";
import Link from "next/link";
import { Closure } from "@/components/landing/closure";
import { Faq, type FaqItem } from "@/components/landing/faq";
import { PricingCards } from "@/components/pricing-cards";
import { getCurrentUser } from "@/lib/auth";
import { fetchPlans, formatMoney } from "@/lib/plans";
import { SESHAT_API_BASE } from "@/lib/session";

export const metadata: Metadata = {
  title: "Pricing · Seshat · Free to read, Premium to share",
  description:
    "The reader is free with one share link. Premium is 39.99 USD a year for unlimited links.",
};

const FAQ: FaqItem[] = [
  {
    q: "What is free, exactly?",
    a: "The whole macOS app: reading, the library at ~/Seshat/, the outline, dark mode, editing in place and the CLI. Nothing local is locked. Every account also gets one permanent share link that you can update or delete.",
  },
  {
    q: "What does Premium add?",
    a: "Unlimited share links and PDF export today. Private and expiring links, custom slugs, custom domains, image hosting, view counts and version history follow as they ship, at no extra cost.",
  },
  {
    q: "Why is yearly so much cheaper?",
    a: "Yearly is what we would rather sell: one payment, no monthly emails, and it lets us plan. So it is priced at about five months of the monthly plan. If you are not sure yet, start monthly and switch later.",
  },
  {
    q: "What happens if I cancel?",
    a: "Your links stay online. Documents above the free allowance become read-only, so nothing you shared breaks and nothing is deleted. Subscribe again and they are writable at once.",
  },
  {
    q: "Do readers need an account?",
    a: "No. A share link opens in any browser on any device, with the same typography as the app, and never asks the reader to sign in or install anything.",
  },
  {
    q: "Is there a team plan?",
    a: "Not yet. Team links are on the Premium list and will arrive there first. Until then each person has their own Premium.",
  },
  {
    q: "Who handles payment?",
    a: "Polar. They take care of cards, tax, invoices and the customer portal where you can change your card or cancel. We never see your card number.",
  },
];

export default async function PricingPage() {
  const [plans, user] = await Promise.all([fetchPlans(), getCurrentUser()]);
  const cur = plans.pricing.yearly.currency;
  const perMonth = formatMoney(plans.pricing.yearly.amount / 12, cur);
  const yearly = formatMoney(plans.pricing.yearly.amount, cur);
  const monthly = formatMoney(plans.pricing.monthly.amount, cur);

  return (
    <main className="bg-paper text-ink min-h-screen font-sans">
      <header className="px-6 py-5">
        <div className="mx-auto flex max-w-[1040px] items-center justify-between">
          <Link
            href="/"
            className="text-ink flex items-center gap-2.5 no-underline"
            aria-label="Seshat home"
          >
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src="/apple-icon.png" alt="" width={36} height={36} className="-my-1" draggable={false} />
            <span className="text-[15px] font-semibold tracking-[-0.01em]">Seshat</span>
          </Link>
          <nav className="flex items-center gap-6 text-[13px]">
            <Link href="/#faq" className="text-ink-muted hover:text-ink no-underline transition-colors">
              Questions
            </Link>
            <Link
              href={user ? "/dashboard" : "/login"}
              className="text-ink-muted hover:text-ink no-underline transition-colors"
            >
              {user ? "Your pages" : "Sign in"}
            </Link>
          </nav>
        </div>
      </header>

      <section className="mx-auto max-w-[1040px] px-6 pt-16 pb-10 sm:pt-24">
        <div className="mx-auto mb-12 max-w-[640px] text-center">
          <h1 className="text-ink m-0 text-balance text-[clamp(32px,4.2vw,46px)] leading-[1.1] font-medium tracking-[-0.02em]">
            Read for free. Share for{" "}
            <span className="whitespace-nowrap">{perMonth} a month.</span>
          </h1>
          <p className="text-ink-muted mx-auto mt-5 max-w-[52ch] text-[16px] leading-[1.6] text-pretty">
            The reader costs nothing and includes one share link. Premium is for
            sharing beyond that: {yearly} a year, or {monthly} a month if you
            would rather not commit.
          </p>
        </div>

        <PricingCards
          plans={plans}
          signedIn={user !== null}
          downloadHref={`${SESHAT_API_BASE}/download`}
        />

        <p className="text-ink-faint mx-auto mt-10 max-w-[56ch] text-center text-[12.5px] leading-[1.6]">
          Prices in {cur}. Tax is added at checkout where it applies. Payments,
          invoices and cancellation are handled by Polar.
        </p>
      </section>

      <section className="mx-auto max-w-[1040px] px-6" id="faq">
        <div className="faq-band">
          <h2 className="faq-title">Questions about the price.</h2>
          <Faq items={FAQ} />
        </div>
      </section>

      <Closure
        downloadHref={`${SESHAT_API_BASE}/download`}
        title="Start with the free reader."
        lede="Open the file, keep it in the library, share one link. Premium is there when you need the second."
      />
    </main>
  );
}
