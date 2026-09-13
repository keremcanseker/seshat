import { getSessionToken } from "@/lib/auth";
import { SESHAT_API_BASE } from "@/lib/session";

/** One earlier version of a shared doc, from `GET /docs/:slug/versions` (KER-807). */
export type DocVersion = {
  id: string;
  title: string;
  createdAt: string;
  bytes: number;
};

async function authed(path: string, init?: RequestInit): Promise<Response> {
  const token = await getSessionToken();
  if (!token) throw new Error("not authenticated");
  return fetch(`${SESHAT_API_BASE}${path}`, {
    ...init,
    headers: { authorization: `Bearer ${token}`, accept: "application/json", ...init?.headers },
    cache: "no-store",
  });
}

/** Newest first. `null` when the doc is not the user's or history is not on their plan. */
export async function getMyVersions(slug: string): Promise<DocVersion[] | null> {
  const res = await authed(`/docs/${encodeURIComponent(slug)}/versions`);
  if (res.status === 402 || res.status === 404) return null;
  if (!res.ok) throw new Error(`Failed to load versions (${res.status})`);
  return ((await res.json()) as { versions: DocVersion[] }).versions;
}

export async function restoreMyVersion(slug: string, id: string): Promise<void> {
  const res = await authed(`/docs/${encodeURIComponent(slug)}/versions/${encodeURIComponent(id)}/restore`, {
    method: "POST",
  });
  if (!res.ok) throw new Error(`Failed to restore version (${res.status})`);
}

/** Raw markdown of one version, streamed through to the browser as a download. */
export async function fetchMyVersionRaw(slug: string, id: string): Promise<Response> {
  return authed(`/docs/${encodeURIComponent(slug)}/versions/${encodeURIComponent(id)}`, {
    headers: { accept: "text/markdown" },
  });
}
