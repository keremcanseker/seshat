"use server";

import { revalidatePath } from "next/cache";
import { restoreMyVersion } from "@/lib/versions";

/** Makes an earlier version current; the replaced text joins the history. */
export async function restoreVersionAction(slug: string, id: string): Promise<void> {
  await restoreMyVersion(slug, id);
  revalidatePath(`/dashboard/${slug}/history`);
  revalidatePath("/dashboard");
}
