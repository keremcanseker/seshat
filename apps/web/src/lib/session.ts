/**
 * Client-safe session constants and helpers. No server-only imports here so
 * this module can be pulled into client components (e.g. the sign-in button).
 */

export const SESSION_COOKIE = "seshat_session";
export const SESSION_MAX_AGE = 60 * 60 * 24 * 30;

const API_BASE =
  process.env.NEXT_PUBLIC_SESHAT_API ?? "https://api.seshat.page";

/** URL that begins the Google OAuth flow for the web app. */
export function googleLoginUrl(): string {
  return `${API_BASE}/auth/google?source=web-token`;
}

export const SESHAT_API_BASE = API_BASE;

export type SessionUser = {
  id: string;
  email: string;
  name: string | null;
  avatarUrl: string | null;
  createdAt: string;
};

export type SharedDocSummary = {
  slug: string;
  title: string;
  createdAt: string;
  updatedAt: string;
};
