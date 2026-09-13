import type { MetadataRoute } from "next";

// Shared documents live under /d/ and are never indexed (KER-803).
export default function robots(): MetadataRoute.Robots {
  return {
    rules: { userAgent: "*", allow: "/", disallow: ["/d/", "/dashboard", "/auth/", "/api/"] },
  };
}
