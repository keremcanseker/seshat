import type { Metadata } from "next";
import { Newsreader, Inter, JetBrains_Mono } from "next/font/google";
import "./globals.css";

const newsreader = Newsreader({
  variable: "--font-newsreader",
  subsets: ["latin"],
  display: "swap",
  axes: ["opsz"],
});

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  display: "swap",
});

const mono = JetBrains_Mono({
  variable: "--font-mono-display",
  subsets: ["latin"],
  display: "swap",
});

export const metadata: Metadata = {
  title: "Seshat a reading room for markdown",
  description:
    "A native macOS app and CLI for reading and sharing markdown — built so long-form .md files actually feel good to read, and so any developer can publish one with a single terminal command.",
  metadataBase: new URL("https://seshat.app"),
  openGraph: {
    title: "Seshat a reading room for markdown",
    description:
      "Open .md files in a calm, well-typeset reader. Share any local file as a link with one command.",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${newsreader.variable} ${inter.variable} ${mono.variable} h-full antialiased`}
    >
      <body className="bg-paper text-ink min-h-full font-sans">{children}</body>
    </html>
  );
}
