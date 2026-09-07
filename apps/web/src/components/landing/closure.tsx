import Link from "next/link";
import { DownloadButton } from "@/components/download-button";
import { AppleGlyph } from "@/components/landing/hero-desktop";

type Props = {
  downloadHref: string;
  title: string;
  lede: string;
};

/** Closing call over the temple terrace, then the site footer. */
export function Closure({ downloadHref, title, lede }: Props) {
  return (
    <div className="closure">
      <section className="close" aria-labelledby="close-h">
        <h2 id="close-h" className="close-line">
          {title}
        </h2>
        <p className="close-lede">{lede}</p>
        <DownloadButton
          href={downloadHref}
          className="close-cta btn-ink inline-flex h-10 items-center gap-2 rounded-full px-5 text-[14px] font-medium no-underline"
        >
          <AppleGlyph />
          Download for macOS
        </DownloadButton>
        <p className="close-fine">No account to read. macOS 14 or later.</p>
      </section>

      <footer className="foot">
        <div className="foot-in">
          <div className="foot-id">
            <Link className="foot-brand" href="/" aria-label="Seshat home">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src="/apple-icon.png" alt="" width={44} height={44} draggable={false} />
            </Link>
            <p className="foot-name">Seshat</p>
            <p className="foot-by">
              Made by <a href="https://github.com/keremcanseker">Kerem</a> · © 2026
            </p>
          </div>
          <div className="foot-cols">
            <div className="foot-col">
              <p className="foot-h">Seshat</p>
              <Link href="/#about">What it is</Link>
              <Link href="/#faq">Questions</Link>
              <a href={downloadHref}>Download for macOS</a>
            </div>
            <div className="foot-col">
              <p className="foot-h">Share</p>
              <a href="/pricing">Pricing</a>
              <a href="/login">Sign in</a>
              <a href="/dashboard">Your pages</a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
