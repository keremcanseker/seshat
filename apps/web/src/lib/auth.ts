import { cookies } from "next/headers";
import type { Me } from "@/lib/plans";
import {
  SESHAT_API_BASE,
  SESSION_COOKIE,
  type SessionUser,
  type SharedDocSummary,
} from "@/lib/session";

/**
 * Server-side auth helpers for the web app.
 *
 * The server (apps/server) issues a session JWT via Google OAuth. For the web
 * surface we use `source=web-token`: the server redirects to
 * `${WEB_BASE_URL}/auth/callback#token=<jwt>`. The callback page POSTs the token
 * to `/api/session`, which stores it in a *first-party* httpOnly cookie on the
 * web app's own origin. All authenticated API calls are then made here,
 * server-side, forwarding the token as `Authorization: Bearer <jwt>`, which
 * sidesteps cross-site SameSite=Lax cookie restrictions between the web origin
 * and the API origin.
 */

/** Reads the current session token from the first-party cookie, if any. */
export async function getSessionToken(): Promise<string | null> {
  const store = await cookies();
  return store.get(SESSION_COOKIE)?.value ?? null;
}

/** Fetches the signed-in user from the API, or null if not authenticated. */
export async function getCurrentUser(): Promise<SessionUser | null> {
  const token = await getSessionToken();
  if (!token) return null;

  let res: Response;
  try {
    res = await fetch(`${SESHAT_API_BASE}/auth/me`, {
      headers: { authorization: `Bearer ${token}`, accept: "application/json" },
      cache: "no-store",
    });
  } catch {
    return null;
  }
  if (!res.ok) return null;
  return (await res.json()) as SessionUser;
}

/** Plan, entitlements and link usage via `GET /me`, or null when signed out. */
export async function getMe(): Promise<Me | null> {
  const token = await getSessionToken();
  if (!token) return null;

  const res = await fetch(`${SESHAT_API_BASE}/me`, {
    headers: { authorization: `Bearer ${token}`, accept: "application/json" },
    cache: "no-store",
  });
  if (!res.ok) return null;
  return (await res.json()) as Me;
}

/** Lists the signed-in user's shared documents via `GET /docs/me`. */
export async function getMyDocs(): Promise<SharedDocSummary[]> {
  const token = await getSessionToken();
  if (!token) return [];

  const res = await fetch(`${SESHAT_API_BASE}/docs/me`, {
    headers: { authorization: `Bearer ${token}`, accept: "application/json" },
    cache: "no-store",
  });
  if (!res.ok) {
    throw new Error(`Failed to load documents (${res.status})`);
  }
  const body = (await res.json()) as { documents: SharedDocSummary[] };
  return body.documents;
}

/** Lists the signed-in user's folder sites via `GET /sites/me`. */
export async function getMySites(): Promise<SharedDocSummary[]> {
  const token = await getSessionToken();
  if (!token) return [];

  const res = await fetch(`${SESHAT_API_BASE}/sites/me`, {
    headers: { authorization: `Bearer ${token}`, accept: "application/json" },
    cache: "no-store",
  });
  if (!res.ok) {
    throw new Error(`Failed to load sites (${res.status})`);
  }
  const body = (await res.json()) as { sites: SharedDocSummary[] };
  return body.sites;
}

/** Deletes one of the signed-in user's docs or sites. */
/** Renames one of the signed-in user's docs via `PATCH /docs/:slug`. Returns an error code on 4xx. */
export async function renameMyDoc(slug: string, wanted: string): Promise<{ error?: string }> {
  const token = await getSessionToken();
  if (!token) throw new Error("not authenticated");

  const res = await fetch(`${SESHAT_API_BASE}/docs/${encodeURIComponent(slug)}`, {
    method: "PATCH",
    headers: { authorization: `Bearer ${token}`, "content-type": "application/json" },
    body: JSON.stringify({ slug: wanted }),
    cache: "no-store",
  });
  if (res.ok) return {};
  const body = (await res.json().catch(() => ({}))) as { code?: string; error?: string };
  return { error: body.code ?? body.error ?? `HTTP ${res.status}` };
}

export async function deleteMyItem(kind: "doc" | "site", slug: string): Promise<void> {
  const token = await getSessionToken();
  if (!token) throw new Error("not authenticated");

  const res = await fetch(
    `${SESHAT_API_BASE}/${kind === "site" ? "sites" : "docs"}/${encodeURIComponent(slug)}`,
    {
      method: "DELETE",
      headers: { authorization: `Bearer ${token}` },
      cache: "no-store",
    },
  );
  if (!res.ok) {
    throw new Error(`Failed to delete ${kind} (${res.status})`);
  }
}
