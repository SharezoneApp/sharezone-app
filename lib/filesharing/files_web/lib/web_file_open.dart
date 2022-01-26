// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

library web_file_open;

import 'src/web_file_open/web_file_open_stub.dart'
    if (dart.library.js) 'src/web_file_open/web_file_open_html.dart'
    as implementation;

void openWebFile(String url, String name) =>
    implementation.openWebFile(url, name);
