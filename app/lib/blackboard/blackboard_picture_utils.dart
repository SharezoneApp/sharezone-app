// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

bool isRemoteBlackboardPicture(String? pictureUrl) {
  if (pictureUrl == null) return false;
  return pictureUrl.startsWith('http://') ||
      pictureUrl.startsWith('https://');
}

ImageProvider getBlackboardPictureProvider(String pictureUrl) {
  if (isRemoteBlackboardPicture(pictureUrl)) {
    return NetworkImage(pictureUrl);
  }
  return AssetImage(pictureUrl);
}
