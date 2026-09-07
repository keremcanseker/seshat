"use server";

import { redirect } from "next/navigation";
import { getSessionToken } from "@/lib/auth";
import { SESHAT_API_BASE } from "@/lib/session";

/** Opens a Polar checkout for the chosen interval and sends the user to it. */
export async function checkoutAction(interval: "monthly" | "yearly"): Promise<void> {
  const token = await getSessionToken();
  if (!token) redirect("/login");

  const res = await fetch(`${SESHAT_API_BASE}/billing/checkout`, {
    method: "POST",
    headers: {
      authorization: `Bearer ${token}`,
      "content-type": "application/json",
    },
    body: JSON.stringify({ interval }),
    cache: "no-store",
  });
  if (!res.ok) {
    throw new Error(`Could not start checkout (${res.status})`);
  }
  const { url } = (await res.json()) as { url: string };
  redirect(url);
}
