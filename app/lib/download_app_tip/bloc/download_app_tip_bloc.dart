// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:flutter/foundation.dart';
import 'package:sharezone_utils/platform.dart';

import '../analytics/download_app_tip_analytics.dart';
import '../cache/download_app_tip_cache.dart';
import '../models/download_app_tip.dart';

/// Warum wird [PlatformCheck] & [TargetPlatform] verwendet? Was ist der
/// Unterschied?
///
/// [PlatformCheck] prüft die jeweilige Plattform, auf der die App
/// ausgeführt wird. Dabei wird nicht daraufgeachtet, über welches Betriebssystem
/// die App ausgeführt wird. Egal, mit welchem Betriebssystem der Nutzer
/// die Web-App aufruft, man erhält immer [Platform.web].
///
/// [TargetPlatform] prüft dagegen, über welches Betriebssystem die App läuft.
/// Somit wird auch über die Web-App erkennt, welches Betriebssystem der Nutzer
/// verwendet. Verwendet der Nutzer die macOS-App oder die Web-App für macOS
/// ergibt in beiden Fällen [TargetPlatform.macOS].
class DownloadAppTipBloc extends BlocBase {
  final DownloadAppTipCache _cache;
  final DownloadAppTipAnalytics _analytics;

  DownloadAppTipBloc(this._cache, this._analytics);

  /// Folgende Plattformen haben eine App, die heruntergeladen werden kann,
  /// weswegen für diese Plattform auch eine Tipp-Karte angezeigt wird.
  final _platformsWithTips = [
    TargetPlatform.macOS,
    // Aktuell erkennt [TargetPlatform] das Betriebssystem über Flutter Web nur
    // von macOS, iPhone und iPad korrekt. Bei Windows & Linux wird immer
    // [TargetPlatform.android] als Fallback zurückgegeben. Sobald Flutter die
    // Erkennung für Windows & Linux eingebaut hat, kann der Code wieder
    // auskommentiert werden. Ticket:
    // https://github.com/flutter/flutter/issues/60271
    //
    // TargetPlatform.android,
    TargetPlatform.iOS
  ];

  /// Diese Methode gibt einen [DownloadAppTip] zurück, falls einer für diese
  /// Plattform verhanden ist und dieser nicht schon bereits weggeklickt
  /// wurde.
  ///
  /// Download-Tips werden nur in der Web-App angezeigt. Diese sollen
  /// den Nutzer auffordern, die jeweilige App herunterzuladen, weil diese
  /// i. d. R. deutlich stabiler und performanter sind.
  ///
  /// Die Tips werden nur angezeigt, wenn es für die jeweilige Plattform
  /// auch eine App gibt. Diese Plattformen werden in [_platformsWithTips]
  /// aufgelistet
  ///
  /// Falls der Tip nicht gezeigt werden soll, wird null zurückgegeben.
  Stream<DownloadAppTip> getDownloadTipIfShouldShowTip() {
    if (PlatformCheck.isWeb &&
        _platformsWithTips.contains(defaultTargetPlatform)) {
      return _cache.alreadyShowedTip(defaultTargetPlatform).map(
          (showedAlready) => showedAlready ? null : _getPlatformDownloadTip());
    }

    return Stream.value(null);
  }

  DownloadAppTip _getPlatformDownloadTip() {
    if (defaultTargetPlatform.isMacOS) return MacOsTip();
    if (defaultTargetPlatform.isAndroid) return AndroidTip();
    if (defaultTargetPlatform.isIOS) return IOsTip();
    throw UnimplementedError('There is no tip for $defaultTargetPlatform');
  }

  void closeTip(DownloadAppTip tip) {
    _analytics.logCloseTip(tip.platform);
    _cache.markTipAsShown(tip.platform);
  }

  void markTipAsOpened(DownloadAppTip tip) {
    _analytics.logOpenTip(tip.platform);
    _cache.markTipAsShown(tip.platform);
  }

  @override
  void dispose() {}
}

extension on TargetPlatform {
  bool get isAndroid => this == TargetPlatform.android;
  bool get isIOS => this == TargetPlatform.iOS;
  bool get isMacOS => this == TargetPlatform.macOS;
}
