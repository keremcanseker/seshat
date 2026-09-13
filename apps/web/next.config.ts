import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",
  // Belt and braces with the <meta name="robots"> on /d/[slug]: crawlers that
  // only read headers still see noindex (KER-803).
  async headers() {
    return [
      {
        source: "/d/:slug",
        headers: [{ key: "X-Robots-Tag", value: "noindex, nofollow" }],
      },
      {
        source: "/s/:path*",
        headers: [{ key: "X-Robots-Tag", value: "noindex, nofollow" }],
      },
    ];
  },
};

export default nextConfig;
