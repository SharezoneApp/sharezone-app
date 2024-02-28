/**
 * Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
 * Licensed under the EUPL-1.2-or-later.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * SPDX-License-Identifier: EUPL-1.2
 */

const withNextra = require('nextra')({
    theme: 'nextra-theme-docs',
    themeConfig: './theme.config.jsx'
})

module.exports = withNextra()

// If you have other Next.js configurations, you can pass them as the parameter:
// module.exports = withNextra({ /* other next.js config */ })