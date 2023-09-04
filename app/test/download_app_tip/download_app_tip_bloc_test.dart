// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/download_app_tip/bloc/download_app_tip_bloc.dart';
import 'package:sharezone/download_app_tip/cache/download_app_tip_cache.dart';
import 'package:sharezone/download_app_tip/models/download_app_tip.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone_utils/platform.dart';

import 'mock_analytics.dart';

void main() {
  group('DownloadTip tests', () {
    late DownloadAppTipCache cache;
    late DownloadAppTipBloc bloc;
    late MockDownloadAppTipAnalytics analytics;

    setUp(() {
      cache = DownloadAppTipCache(InMemoryStreamingKeyValueStore());
      analytics = MockDownloadAppTipAnalytics();
      bloc = DownloadAppTipBloc(cache, analytics);
    });

    group('Platform is web', () {
      setUp(() => PlatformCheck.setCurrentPlatformForTesting(Platform.web));

      group('TargetPlatform.macOS', () {
        setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.macOS);

        test('bloc returns MacOsTip, if defaultTargetPlatform is macOS', () {
          expect(bloc.getDownloadTipIfShouldShowTip(), emits(MacOsTip()));
        });

        test(
            'bloc returns null, if defaultTargetPlatform is macOS and already showed macos tip',
            () {
          cache.markTipAsShown(TargetPlatform.macOS);
          expect(bloc.getDownloadTipIfShouldShowTip(), emits(null));
        });
      });

      group('TargetPlatform.android', () {
        setUp(
            () => debugDefaultTargetPlatformOverride = TargetPlatform.android);

        test('bloc returns AndroidTip, if defaultTargetPlatform is android',
            () {
          expect(bloc.getDownloadTipIfShouldShowTip(), emits(AndroidTip()));
        });

        test(
            'bloc returns null, if defaultTargetPlatform is android and already showed macos tip',
            () {
          cache.markTipAsShown(TargetPlatform.android);
          expect(bloc.getDownloadTipIfShouldShowTip(), emits(null));
        });
      },
          skip:
              'Aktuell erkennt [TargetPlatform] das Betriebssystem über Flutter Web nur von macOS, iPhone und iPad korrekt. Bei Windows & Linux wird immer [TargetPlatform.android] als Fallback zurückgegeben. Sobald Flutter die Erkennung für Windows & Linux eingebaut hat, kann der Code wieder auskommentiert werden. Ticket: https://github.com/flutter/flutter/issues/60271');

      group('TargetPlatform.iOS', () {
        setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.iOS);

        test('bloc returns iOsTip, if defaultTargetPlatform is iOS', () {
          expect(bloc.getDownloadTipIfShouldShowTip(), emits(IOsTip()));
        });

        test(
            'bloc returns null, if defaultTargetPlatform is iOS and already showed macos tip',
            () {
          cache.markTipAsShown(TargetPlatform.iOS);
          expect(bloc.getDownloadTipIfShouldShowTip(), emits(null));
        });
      });
    });

    test('logs if user closes tip', () {
      bloc.closeTip(MacOsTip());
      expect(analytics.closeTipLogged, true);
    });

    test('logs if user call tip action', () {
      bloc.markTipAsOpened(MacOsTip());
      expect(analytics.openTipLogged, true);
    });

    void _testPlatformCheck(Platform platform) {
      PlatformCheck.setCurrentPlatformForTesting(platform);
      expect(bloc.getDownloadTipIfShouldShowTip(), emits(null));
    }

    test("bloc returns null, if PlatformCheck is not web", () {
      _testPlatformCheck(Platform.android);
      _testPlatformCheck(Platform.iOS);
      _testPlatformCheck(Platform.macOS);
      _testPlatformCheck(Platform.windows);
      _testPlatformCheck(Platform.linux);
    });
  });
}
