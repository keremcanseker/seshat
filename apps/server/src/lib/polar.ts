import { Polar } from "@polar-sh/sdk";
import { env } from "../env";

/**
 * null until the Polar env vars are set, so a deploy without billing configured
 * still boots and serves reading and sharing. Callers answer 503 instead.
 */
export const polar = env.POLAR_ACCESS_TOKEN
  ? new Polar({ accessToken: env.POLAR_ACCESS_TOKEN, server: env.POLAR_ENV })
  : null;
