import { sql } from "drizzle-orm";
import { db } from "../db/client";
import { env } from "../env";

/**
 * View counter (KER-809). No cookies: the viewer is a keyed hash of the IP, and
 * a viewer counts once per document per 24 h. One statement: touch the viewer
 * row, and bump the counter only if the touch went through.
 */
export async function recordView(documentId: string, ip: string): Promise<void> {
  const viewer = new Bun.CryptoHasher("sha256", env.AUTH_JWT_SECRET).update(ip).digest("hex").slice(0, 32);
  await db.execute(sql`
    with seen as (
      insert into document_viewers (document_id, viewer)
      values (${documentId}, ${viewer})
      on conflict (document_id, viewer) do update set seen_at = now()
      where document_viewers.seen_at < now() - interval '24 hours'
      returning 1
    )
    update documents set views = views + 1
    where id = ${documentId} and exists (select 1 from seen)
  `);
}
