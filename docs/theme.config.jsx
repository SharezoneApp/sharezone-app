/**
 * Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
 * Licensed under the EUPL-1.2-or-later.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * SPDX-License-Identifier: EUPL-1.2
 */

import Link from "next/link";
import React from "react";

const footerLegalNav = [
  { name: "Imprint", href: "https://sharezone.net/imprint" },
  {
    name: "Privacy Policy",
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
    ),
  },
};
