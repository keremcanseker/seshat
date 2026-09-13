import { fetchMyVersionRaw } from "@/lib/versions";

/** Proxies a version download; the session token never reaches the browser. */
export async function GET(
  _request: Request,
  { params }: { params: Promise<{ slug: string; id: string }> },
) {
  const { slug, id } = await params;
  const upstream = await fetchMyVersionRaw(slug, id);
  if (!upstream.ok) return new Response("Not found", { status: upstream.status });
  return new Response(upstream.body, {
    headers: {
      "content-type": "text/markdown; charset=utf-8",
      "content-disposition": upstream.headers.get("content-disposition") ?? "attachment",
    },
  });
}
