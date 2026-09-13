import type { MetadataRoute } from "next";

// Shared documents (/d/) and folder sites (/s/) are never indexed (KER-803).
export default function robots(): MetadataRoute.Robots {
  return {
    rules: { userAgent: "*", allow: "/", disallow: ["/d/", "/s/", "/dashboard", "/auth/", "/api/"] },
  };
}
