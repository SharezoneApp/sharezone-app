// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/blackboard/blackboard_picture_utils.dart';

void main() {
  group('blackboard_picture_utils', () {
    test('isRemoteBlackboardPicture detects remote URLs', () {
      expect(isRemoteBlackboardPicture(null), isFalse);
      expect(isRemoteBlackboardPicture('assets/wallpaper/foo.png'), isFalse);
      expect(isRemoteBlackboardPicture('http://example.com/foo.png'), isTrue);
      expect(isRemoteBlackboardPicture('https://example.com/foo.png'), isTrue);
    });

    test('getBlackboardPictureProvider returns matching provider', () {
      final assetProvider = getBlackboardPictureProvider(
        'assets/wallpaper/foo.png',
      );
      expect(assetProvider, isA<AssetImage>());
      expect((assetProvider as AssetImage).assetName, 'assets/wallpaper/foo.png');

      final networkProvider = getBlackboardPictureProvider(
        'https://example.com/foo.png',
      );
      expect(networkProvider, isA<NetworkImage>());
      expect((networkProvider as NetworkImage).url, 'https://example.com/foo.png');
    });
  });
}
