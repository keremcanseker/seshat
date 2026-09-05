import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { GoogleSignInButton } from "@/components/google-sign-in-button";
import { SeshatMark } from "@/components/seshat-mark";
import { getCurrentUser } from "@/lib/auth";

export const metadata: Metadata = {
  title: "Sign in · Seshat",
};

export default async function LoginPage() {
  const user = await getCurrentUser();
  if (user) redirect("/dashboard");

  return (
    <main className="bg-paper text-ink grid min-h-screen place-items-center px-6 font-sans">
      <div className="w-full max-w-[380px] text-center">
        <Link
          href="/"
          className="text-ink-faint hover:text-ink-muted mb-8 inline-flex items-center gap-2 transition-colors"
          aria-label="Seshat home"
        >
          <SeshatMark size={26} />
        </Link>

        <h1 className="font-heading text-ink m-0 mb-3 text-[30px] font-bold tracking-[-0.01em]">
          Your shared pages
        </h1>
        <p className="text-ink-muted mx-auto m-0 mb-9 max-w-[300px] text-[15px] leading-[1.6]">
          Sign in to view the markdown documents you have shared and manage
          their links.
        </p>

        <GoogleSignInButton />

        <p className="text-ink-faint mt-8 text-[12px] leading-[1.5]">
          Seshat reads your name and email only to identify your shared pages.
        </p>
      </div>
    </main>
  );
}
