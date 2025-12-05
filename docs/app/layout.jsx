/**
 * Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
 * Licensed under the EUPL-1.2-or-later.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * SPDX-License-Identifier: EUPL-1.2
 */

import Link from "next/link";
import { Footer, Layout, Navbar } from "nextra-theme-docs";
import "nextra-theme-docs/style.css";
import { Head } from "nextra/components";
import { getPageMap } from "nextra/page-map";

export const metadata = {
  title: "Sharezone - Dokumentation",
  openGraph: {
    title: "Sharezone - Dokumentation",
    url: "https://docs.sharezone.net",
    locale: "de_DE",
    type: "website",
  },
};

const navbar = (
  <Navbar
    logo={<span>Sharezone</span>}
    projectLink="https://github.com/SharezoneApp/sharezone-app/"
  />
);

const footerLegalNav = [
  { name: "Imprint", href: "https://sharezone.net/imprint" },
  {
    name: "Privacy Policy",
    href: "https://sharezone.net/privacy-policy",
  },
];

const footer = (
  <Footer>
    <div>
      {footerLegalNav.map((nav) => (
        <Link
          key={nav.name}
          href={nav.href}
          style={{ paddingRight: "1rem" }}
          target="_blank"
        >
          {nav.name}
        </Link>
      ))}
    </div>
  </Footer>
);

export default async function RootLayout({ children }) {
  return (
    <html
      // Not required, but good for SEO
      lang="de"
      // Required to be set
      dir="ltr"
      // Suggested by `next-themes` package https://github.com/pacocoursey/next-themes#with-app
      suppressHydrationWarning
    >
      <Head />
      <body>
        <Layout
          navbar={navbar}
          pageMap={await getPageMap()}
          docsRepositoryBase="https://github.com/SharezoneApp/sharezone-app/tree/main/docs"
          footer={footer}
          sidebar={{ defaultMenuCollapseLevel: 1, toggleButton: true }}
          toc={{ backToTop: <span>Back to top</span> }}
        >
          {children}
        </Layout>
      </body>
    </html>
  );
}
