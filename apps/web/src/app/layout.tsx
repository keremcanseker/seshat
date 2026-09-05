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
  title: "Seshat: A markdown reader for macOS",
  description:
    "A native macOS reader and CLI for .md files. Read long documents as pages, then share any file with a public link.",
  metadataBase: new URL("https://seshat.app"),
  openGraph: {
    title: "Seshat: A markdown reader for macOS",
    description:
      "Read .md files as documents on macOS. Share any local file with a public link.",
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
