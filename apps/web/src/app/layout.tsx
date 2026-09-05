import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import { ThemeProvider } from "@/components/theme-provider";
import "./globals.css";

const geist = Geist({
  variable: "--font-geist",
  subsets: ["latin"],
  display: "swap",
});

const mono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
  display: "swap",
});

export const metadata: Metadata = {
  title: "Seshat a reading room for markdown",
  description:
    "A native macOS app and CLI for reading and sharing markdown, built so long-form .md files actually feel good to read, and so any developer can publish one with a single terminal command.",
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
      className={`${geist.variable} ${mono.variable} h-full antialiased`}
      suppressHydrationWarning
    >
      <body className="bg-paper text-ink min-h-full font-sans">
        <ThemeProvider
          attribute="class"
          defaultTheme="light"
          enableSystem={false}
          storageKey="seshat-theme"
        >
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
