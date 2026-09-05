export type SharedDoc = {
  slug: string;
  title: string;
  content: string;
  createdAt: string;
  updatedAt: string;
};

const API_BASE =
  process.env.NEXT_PUBLIC_SESHAT_API ?? "https://api.seshat.page";

export async function fetchSharedDoc(slug: string): Promise<SharedDoc | null> {
  const url = `${API_BASE}/docs/${encodeURIComponent(slug)}`;
  let response: Response;
  try {
    response = await fetch(url, {
      cache: "no-store",
      headers: { Accept: "application/json" },
    });
  } catch {
    return null;
  }
  if (response.status === 404) return null;
  if (!response.ok) {
    throw new Error(`Failed to load document (${response.status})`);
  }
  const body = (await response.json()) as {
    slug: string;
    title: string;
    content: string;
    created_at: string;
    updated_at: string;
  };
  return {
    slug: body.slug,
    title: body.title,
    content: body.content,
    createdAt: body.created_at,
    updatedAt: body.updated_at,
  };
}
