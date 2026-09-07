"use client";

import { useState, useTransition } from "react";
import Link from "next/link";
import { Check } from "lucide-react";
import { checkoutAction } from "@/app/pricing/actions";
import { AppleGlyph } from "@/components/landing/hero-desktop";
import { SeshatStar } from "@/components/seshat-star";
import { formatMoney, type DisplayFeature, type Interval, type Plans } from "@/lib/plans";

type Props = {
  plans: Plans;
  signedIn: boolean;
  downloadHref: string;
};

/** Free (paper) and Premium (ink) with a yearly / monthly tab inside Premium. */
export function PricingCards({ plans, signedIn, downloadHref }: Props) {
  const [interval, setInterval] = useState<Interval>("yearly");
  const [starting, startCheckout] = useTransition();
  const monthly = plans.pricing.monthly;
  const yearly = plans.pricing.yearly;
  const cur = yearly.currency;
  const yearAtMonthly = monthly.amount * 12;
  const savePct = Math.round((1 - yearly.amount / yearAtMonthly) * 100);
  const freeLimit = plans.plans.free.quotas.activeLinks;
  const isYearly = interval === "yearly";

  return (
    <div className="pricing-grid">
      <section className="pricing-card">
        <span className="pricing-eyebrow">For reading</span>
        <h3 className="pricing-title">Free</h3>
        <p className="pricing-sub">
          The whole reader, no account.
          {freeLimit === null ? "" : ` ${freeLimit} share link included.`}
        </p>
        <div className="pricing-price">
          <span className="pricing-amount">
            0 {cur}
            <span className="pricing-period">forever</span>
          </span>
        </div>
        <hr className="pricing-rule" />
        <Features items={plans.display.free} />
        <p className="pricing-note">Upgrade whenever a second link is needed.</p>
        <a href={downloadHref} className="btn-ink pricing-btn mt-auto">
          <AppleGlyph />
          Download for macOS
        </a>
        <p className="pricing-fine">macOS 14 or later</p>
      </section>

      <section className="pricing-card is-featured">
        <div className="flex items-center justify-between gap-3">
          <span className="pricing-eyebrow">
            <SeshatStar size={9} />
            For sharing
          </span>
          <div
            role="radiogroup"
            aria-label="Billing interval"
            className="pricing-tabs"
            data-on={interval}
          >
            <span className="pricing-tabs-pill" aria-hidden />
            {(["yearly", "monthly"] as const).map((v) => (
              <button
                key={v}
                type="button"
                role="radio"
                aria-checked={interval === v}
                onClick={() => setInterval(v)}
                className={interval === v ? "is-on" : ""}
              >
                {v === "yearly" ? "Yearly" : "Monthly"}
                {v === "yearly" ? <em>-{savePct}%</em> : null}
              </button>
            ))}
          </div>
        </div>
        <h3 className="pricing-title">Premium</h3>
        <p className="pricing-sub">
          {isYearly ? "Two months free. Everything below, unlimited." : "Everything below, paid month to month."}
        </p>
        <div className="pricing-price pricing-swap" key={interval}>
          <span className="pricing-was" style={isYearly ? undefined : { visibility: "hidden" }}>
            <s>{formatMoney(yearAtMonthly, cur)}</s>
            <span className="pricing-badge">Save {savePct}%</span>
          </span>
          <span className="pricing-amount">
            {formatMoney(isYearly ? yearly.amount : monthly.amount, cur)}
            <span className="pricing-period">{isYearly ? "/ year" : "/ month"}</span>
          </span>
        </div>
        <p className="pricing-permonth">
          {isYearly
            ? `That is ${formatMoney(yearly.amount / 12, cur)} a month, billed once a year.`
            : `${formatMoney(yearAtMonthly, cur)} a year. Yearly is ${formatMoney(yearly.amount, cur)}.`}
        </p>
        <hr className="pricing-rule" />
        <Features items={plans.display.premium} />
        <p className="pricing-note">Cancel anytime. Your links stay online.</p>
        <div className="mt-auto">
          {signedIn ? (
            <button
              type="button"
              disabled={starting}
              onClick={() => startCheckout(() => checkoutAction(interval))}
              className="btn-paper pricing-btn disabled:opacity-60"
            >
              {starting ? "Opening checkout…" : isYearly ? "Get Premium yearly" : "Get Premium monthly"}
            </button>
          ) : (
            <Link href="/login" className="btn-paper pricing-btn">
              {isYearly ? "Get Premium yearly" : "Get Premium monthly"}
            </Link>
          )}
        </div>
        <p className="pricing-fine">
          {isYearly ? "One payment a year. Handled by Polar." : "Billed monthly. Handled by Polar."}
        </p>
      </section>
    </div>
  );
}

function Features({ items }: { items: DisplayFeature[] }) {
  return (
    <ul className="pricing-features">
      {items.map((f) => (
        <li key={f.key} className={f.available ? "" : "is-soon"}>
          <Check className="pricing-check" strokeWidth={2.2} />
          <span>
            {f.label}
            {f.available ? null : <em>soon</em>}
          </span>
        </li>
      ))}
    </ul>
  );
}
