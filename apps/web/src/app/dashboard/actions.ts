"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { cookies } from "next/headers";
import { deleteMyItem, getSessionToken, renameMyDoc } from "@/lib/auth";
import { SESHAT_API_BASE, SESSION_COOKIE } from "@/lib/session";

/** Deletes one of the signed-in user's shared docs or sites, then refreshes the list. */
export async function deleteItemAction(kind: "doc" | "site", slug: string): Promise<void> {
  await deleteMyItem(kind, slug);
  revalidatePath("/dashboard");
}

/** Gives a shared doc a readable slug (Premium). Returns a message when the server refuses. */
export async function renameDocAction(slug: string, wanted: string): Promise<{ error?: string }> {
  const { error } = await renameMyDoc(slug, wanted);
  if (error) return { error: RENAME_ERRORS[error] ?? "Could not rename this link." };
  revalidatePath("/dashboard");
  return {};
}

const RENAME_ERRORS: Record<string, string> = {
  slug_taken: "That address is already taken.",
  feature_required: "Custom addresses need Premium.",
};

/** Sends the user to their Polar customer portal to manage or cancel. */
export async function portalAction(): Promise<void> {
  const token = await getSessionToken();
  if (!token) redirect("/login");

  const res = await fetch(`${SESHAT_API_BASE}/billing/portal`, {
    headers: { authorization: `Bearer ${token}`, accept: "application/json" },
    cache: "no-store",
  });
  if (!res.ok) {
    throw new Error(`Could not open the customer portal (${res.status})`);
  }
  const { url } = (await res.json()) as { url: string };
  redirect(url);
}

/** Clears the first-party session cookie and returns to the marketing site. */
export async function logoutAction(): Promise<void> {
  const store = await cookies();
  store.delete(SESSION_COOKIE);
  redirect("/");
}
