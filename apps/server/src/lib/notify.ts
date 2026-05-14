import { env } from "../env";

type DownloadNotification = {
  userAgent: string | null;
  referrer: string | null;
  platform: string | null;
};

export async function sendDownloadNotification(
  event: DownloadNotification,
): Promise<void> {
  if (!env.RESEND_API_KEY || !env.DOWNLOAD_NOTIFY_TO) return;

  const subject = `Seshat download · ${event.platform ?? "unknown"}`;
  const lines = [
    `Platform: ${event.platform ?? "—"}`,
    `Referrer: ${event.referrer ?? "—"}`,
    `User-Agent: ${event.userAgent ?? "—"}`,
    `Time: ${new Date().toISOString()}`,
  ];
  const text = lines.join("\n");

  try {
    const response = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${env.RESEND_API_KEY}`,
        "content-type": "application/json",
      },
      body: JSON.stringify({
        from: env.DOWNLOAD_NOTIFY_FROM,
        to: env.DOWNLOAD_NOTIFY_TO,
        subject,
        text,
      }),
    });
    if (!response.ok) {
      const body = await response.text().catch(() => "");
      console.error(
        `resend notify failed (${response.status}): ${body.slice(0, 200)}`,
      );
    }
  } catch (err) {
    console.error("resend notify error:", err);
  }
}
