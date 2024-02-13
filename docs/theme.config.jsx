import Link from "next/link";
import React from "react";

const footerNav = [
  {
    name: "Support",
    href: "https://sharezone.net/support",
  },
];

const footerLegalNav = [
  { name: "Imprint", href: "https://sharezone.net/imprint" },
  {
    name: "Privacy",
    href: "https://sharezone.net/privacy",
  },
];

export default {
  logo: <span>Sharezone</span>,
  search: {
    placeholder: "Search...",
  },
  project: {
    link: "https://github.com/SharezoneApp/sharezone-app",
  },
  sidebar: {
    defaultMenuCollapseLevel: 1,
    toggleButton: true,
  },
  editLink: {
    text: "Edit this page on GitHub",
  },
  toc: {
    backToTop: true,
  },
  docsRepositoryBase:
    "https://github.com/SharezoneApp/sharezone-app/tree/main/docs",
  footer: {
    text: (
      <span className="text-primary/80">
        MIT {new Date().getFullYear()} © Sharezone UG (haftungsbeschränkt)
      </span>
    ),
  },
};
