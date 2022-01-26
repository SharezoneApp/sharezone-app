// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// ignore:avoid_web_libraries_in_flutter
import 'dart:html';

void openWebFile(String url, String name) {
  AnchorElement linkElement = AnchorElement();
  linkElement.href = url;
  linkElement.target = '_blank';
  linkElement.click();
}
