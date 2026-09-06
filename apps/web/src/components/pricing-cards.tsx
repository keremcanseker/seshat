"use client";

import { useState } from "react";
import Link from "next/link";
import { Check } from "lucide-react";
import { formatMoney, type DisplayFeature, type Interval, type Plans } from "@/lib/plans";

type Props = {
  plans: Plans;
  signedIn: boolean;
  downloadHref: string;
};

export function PricingCards({ plans, signedIn, downloadHref }: Props) {
  const [interval, setInterval] = useState<Interval>("yearly");
  const price = plans.pricing[interval];
  const currency = price.currency;
  const perMonth = interval === "yearly" ? price.amount / 12 : price.amount;
  const perYear = interval === "yearly" ? price.amount : price.amount * 12;
  const freeLimit = plans.plans.free.quotas.activeLinks;

  return (
    <div className="grid gap-5 sm:grid-cols-2">
      <Card title="Free" eyebrow="For reading">
        <p className="font-heading text-ink m-0 text-[32px] leading-none font-bold tracking-[-0.01em]">
          0 {currency}
        </p>
        <p className="text-ink-muted m-0 mt-2 text-[13px]">
          {freeLimit === null ? "Unlimited share links" : `${freeLimit} share link, no expiry`}
        </p>
        <FeatureList items={plans.display.free} />
        <a
          href={downloadHref}
          className="border-rule-strong text-ink hover:bg-paper-subtle mt-auto inline-flex h-10 items-center justify-center rounded-md border-[0.5px] px-5 text-[14px] font-medium no-underline transition-colors"
        >
          Download for macOS
        </a>
      </Card>

      <Card title="Premium" eyebrow="For sharing" featured>
        <div
          role="radiogroup"
          aria-label="Billing interval"
          className="bg-paper-subtle mb-5 inline-flex self-start rounded-md p-0.5"
        >
          {(["yearly", "monthly"] as const).map((value) => (
            <button
              key={value}
              type="button"
              role="radio"
              aria-checked={interval === value}
              onClick={() => setInterval(value)}
              className={`h-7 rounded-[5px] px-3 text-[12px] font-medium transition-colors ${
                interval === value
                  ? "bg-paper text-ink shadow-[0_1px_2px_rgba(30,20,10,0.12)]"
                  : "text-ink-muted hover:text-ink"
              }`}
            >
              {value === "yearly" ? "Yearly" : "Monthly"}
            </button>
          ))}
        </div>
        <p className="font-heading text-ink m-0 text-[32px] leading-none font-bold tracking-[-0.01em] tabular-nums">
          {formatMoney(price.amount, currency)}
          <span className="text-ink-muted font-sans text-[14px] font-normal">
            {" "}
            / {interval === "yearly" ? "year" : "month"}
          </span>
        </p>
        <p className="text-ink-muted m-0 mt-2 text-[13px] tabular-nums">
          {interval === "yearly"
            ? `${formatMoney(perMonth, currency)} per month`
            : `${formatMoney(perYear, currency)} per year`}
        </p>
        <FeatureList items={plans.display.premium} />
        {signedIn ? (
          <button
            type="button"
            disabled
            title="Checkout opens soon"
            className="btn-ink mt-auto inline-flex h-10 items-center justify-center rounded-md px-5 text-[14px] font-medium disabled:opacity-60"
          >
            Get Premium
          </button>
        ) : (
          <Link
            href="/login"
            className="btn-ink mt-auto inline-flex h-10 items-center justify-center rounded-md px-5 text-[14px] font-medium no-underline"
          >
            Sign in to get Premium
          </Link>
        )}
      </Card>
    </div>
  );
}

function Card({
  title,
  eyebrow,
  featured = false,
  children,
}: {
  title: string;
  eyebrow: string;
  featured?: boolean;
  children: React.ReactNode;
}) {
  return (
    <section
      className={`flex flex-col rounded-xl border-[0.5px] p-7 ${
        featured ? "border-gold-soft bg-paper-subtle" : "border-rule bg-paper"
      }`}
    >
      <p className="text-ink-faint m-0 mb-1 font-mono text-[11px] tracking-[0.1em] uppercase">
        {eyebrow}
      </p>
      <h2 className="font-heading text-ink m-0 mb-5 text-[20px] font-semibold">{title}</h2>
      {children}
    </section>
  );
}

function FeatureList({ items }: { items: DisplayFeature[] }) {
  return (
    <ul className="m-0 my-7 list-none p-0">
      {items.map((f) => (
        <li key={f.key} className="text-ink flex items-start gap-2.5 py-1.5 text-[14px] leading-[1.5]">
          <Check
            className={`mt-1 size-3.5 shrink-0 ${f.available ? "text-gold" : "text-ink-faint"}`}
            strokeWidth={2}
          />
          <span className={f.available ? "" : "text-ink-muted"}>
            {f.label}
            {f.available ? null : (
              <span className="text-ink-faint ml-2 font-mono text-[10px] tracking-[0.08em] uppercase">
                soon
              </span>
            )}
          </span>
        </li>
      ))}
    </ul>
  );
}
