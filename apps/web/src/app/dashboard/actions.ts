"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { cookies } from "next/headers";
import { deleteMyDoc } from "@/lib/auth";
import { SESSION_COOKIE } from "@/lib/session";

/** Deletes one of the signed-in user's shared docs, then refreshes the list. */
export async function deleteDocAction(slug: string): Promise<void> {
  await deleteMyDoc(slug);
  revalidatePath("/dashboard");
}

/** Clears the first-party session cookie and returns to the marketing site. */
export async function logoutAction(): Promise<void> {
  const store = await cookies();
  store.delete(SESSION_COOKIE);
  redirect("/");
}
