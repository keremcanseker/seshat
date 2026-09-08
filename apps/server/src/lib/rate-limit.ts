// ponytail: in-memory sliding window, so the limit is per server process.
// One Coolify container today. Move the counters to Postgres or Redis the day
// we run more than one instance, or the cap becomes N times looser than it reads.

const hits = new Map<string, number[]>();
const MAX_KEYS = 10_000;

/**
 * Records one hit for `key` and reports whether it broke the limit.
 * Returns true when the caller should be refused.
 */
export function overLimit(key: string, limit: number, windowMs: number): boolean {
  const now = Date.now();
  const recent = (hits.get(key) ?? []).filter((at) => now - at < windowMs);
  if (recent.length >= limit) {
    hits.set(key, recent);
    return true;
  }
  recent.push(now);
  hits.set(key, recent);
  if (hits.size > MAX_KEYS) prune(now, windowMs);
  return false;
}

/** Drops keys whose hits have all aged out, so an idle process does not grow forever. */
function prune(now: number, windowMs: number): void {
  for (const [key, times] of hits) {
    if (times.every((at) => now - at >= windowMs)) hits.delete(key);
  }
}

/** Test seam: forget every counter. */
export function resetRateLimits(): void {
  hits.clear();
}
