/**
 * Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
 * Licensed under the EUPL-1.2-or-later.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * SPDX-License-Identifier: EUPL-1.2
 */

import { useMDXComponents as getThemeComponents } from 'nextra-theme-docs' // nextra-theme-blog or your custom theme
 
// Copied this file from https://nextra.site/docs/file-conventions/mdx-components-file

// Get the default MDX components
const themeComponents = getThemeComponents()
 
// Merge components
export function useMDXComponents(components) {
  return {
    ...themeComponents,
    ...components
  }
}