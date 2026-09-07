import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { DocList } from "@/components/doc-list";
import { SeshatMark } from "@/components/seshat-mark";
import { CheckoutWatcher } from "@/components/checkout-watcher";
import { getCurrentUser, getMe, getMyDocs } from "@/lib/auth";
import type { Me } from "@/lib/plans";
import { logoutAction, portalAction } from "./actions";

export const metadata: Metadata = {
  title: "Your pages · Seshat",
};

export default async function DashboardPage({
  searchParams,
}: {
  searchParams: Promise<{ checkout?: string }>;
}) {
  const user = await getCurrentUser();
  if (!user) redirect("/login");

  const [docs, me, params] = await Promise.all([getMyDocs(), getMe(), searchParams]);
  // The webhook may not have landed yet; the watcher refreshes until it does.
  const awaitingCheckout = params.checkout === "success" && me?.plan !== "premium";

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
          <div className="flex items-center gap-4">
            <Link
              href="/pricing"
              className="text-ink-muted hover:text-ink text-[13px] transition-colors"
            >
              Pricing
            </Link>
            <span className="text-ink-muted hidden text-[13px] sm:inline">
              {user.email}
            </span>
            <form action={logoutAction}>
              <button
                type="submit"
                className="text-ink-muted hover:text-ink text-[13px] transition-colors"
              >
                Sign out
              </button>
            </form>
          </div>
        </div>
      </header>

      <section className="mx-auto max-w-[920px] px-8 py-12 sm:px-12">
        <div className="mb-9">
          <p className="text-ink-faint mb-3 font-mono text-[11px] tracking-[0.1em] uppercase">
            Your library
          </p>
          <h1 className="font-heading text-ink m-0 text-[36px] font-bold tracking-[-0.012em]">
            Shared documents
          </h1>
          <p className="text-ink-muted mt-3 max-w-[520px] text-[15px] leading-[1.6]">
            Every markdown file you shared with{" "}
            <code className="font-mono text-[13px]">seshat share</code>. Open it,
            copy its link, or remove its public page.
          </p>
        </div>

        <CheckoutWatcher pending={awaitingCheckout} />

        {me ? <PlanRow me={me} /> : null}

        <DocList docs={docs} />
      </section>
    </main>
  );
}

/** Plan and link usage, from GET /me. The counter is visible before any wall. */
function PlanRow({ me }: { me: Me }) {
  const { activeLinks, limit } = me.usage;
  const usage =
    limit === null
      ? `${activeLinks} ${activeLinks === 1 ? "link" : "links"}`
      : `${activeLinks} of ${limit} free links`;
  const premium = me.plan === "premium";

  return (
    <div className="border-rule mb-6 flex items-center justify-between gap-4 rounded-lg border-[0.5px] px-5 py-3.5">
      <p className="m-0 text-[13px]">
        <span className="text-ink font-medium">{premium ? "Premium" : "Free plan"}</span>
        <span className="text-ink-faint"> · </span>
        <span className="text-ink-muted tabular-nums">{usage}</span>
        {me.planStatus === "canceled" && me.planPeriodEnd ? (
          <span className="text-ink-faint">
            {" "}
            · ends {new Date(me.planPeriodEnd).toLocaleDateString("en-US", { dateStyle: "medium" })}
          </span>
        ) : null}
      </p>
      {premium ? (
        <form action={portalAction}>
          <button
            type="submit"
            className="border-rule-strong text-ink-muted hover:text-ink h-8 rounded-md border-[0.5px] px-3.5 text-[12px] font-medium transition-colors"
          >
            Manage subscription
          </button>
        </form>
      ) : (
        <Link
          href="/pricing"
          className="btn-ink inline-flex h-8 items-center rounded-md px-3.5 text-[12px] font-medium no-underline"
        >
          Upgrade
        </Link>
      )}
    </div>
  );
}
