import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { DocList } from "@/components/doc-list";
import { SeshatMark } from "@/components/seshat-mark";
import { getCurrentUser, getMyDocs } from "@/lib/auth";
import { logoutAction } from "./actions";

export const metadata: Metadata = {
  title: "Your library · Seshat",
};

export default async function DashboardPage() {
  const user = await getCurrentUser();
  if (!user) redirect("/login");

  const docs = await getMyDocs();

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
            Every markdown file you&rsquo;ve shared with{" "}
            <code className="font-mono text-[13px]">seshat share</code>. Open it,
            copy its link, or remove it from the web.
          </p>
        </div>

        <DocList docs={docs} />
      </section>
    </main>
  );
}
