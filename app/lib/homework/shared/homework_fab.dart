// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../homework_dialog/open_homework_dialog.dart';

class HomeworkFab extends StatefulWidget {
  const HomeworkFab({super.key});

  @override
  State<HomeworkFab> createState() => _HomeworkFabState();
}

class _HomeworkFabState extends State<HomeworkFab> {
  InterstitialAd? _interstitialAd;

  @override
  initState() {
    super.initState();
    loadAd();
  }

  final adUnitId = PlatformCheck.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  /// Loads an interstitial ad.
  void loadAd() {
    debugPrint('Loading an interstitial ad.');
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ModalFloatingActionButton(
      icon: const Icon(Icons.add),
      tooltip: "Neue Hausaufgabe",
      onPressed: () async {
        // AnalyticsProvider.ofOrNullObject(context)
        //     .log(const AnalyticsEvent("homework_add_via_fab"));
        // await openHomeworkDialogAndShowConfirmationIfSuccessful(context);
        _interstitialAd?.show();
      },
      // When there are multiple FABs one has to have a different tag
      // than the other one. If none has a tag or both the same an error will be thrown
      heroTag: "sharezone-fab",
    );
  }
}
