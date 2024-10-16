// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:platform_check/platform_check.dart';
import 'package:remote_configuration/remote_configuration.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';

enum AdFormat {
  banner,
  native,
  interstitial,
}

class AdsController extends ChangeNotifier {
  final SubscriptionService subscriptionService;
  final RemoteConfiguration remoteConfiguration;
  final KeyValueStore keyValueStore;

  /// Defines if ads are visible for the current user.
  bool areAdsVisible = false;
  bool shouldShowInfoDialog = false;
  StreamSubscription<bool>? _subscription;

  AdsController({
    required this.subscriptionService,
    required this.remoteConfiguration,
    required this.keyValueStore,
  }) {
    if (isQualifiedForAds()) {
      _initializeMobileAdsSDK();
      _listenToSubscriptionService();
    }
  }

  bool isQualifiedForAds() {
    if (!PlatformCheck.isMobile) {
      // Google AdMob SDK is only available on mobile platforms.
      return false;
    }

    final isRemoteConfigFlagEnabled =
        remoteConfiguration.getBool('ads_enabled');
    final isActivationFlagEnabled = keyValueStore.getBool('show-ads') ?? false;
    return isRemoteConfigFlagEnabled || isActivationFlagEnabled;
  }

  /// Determines if the user should be shown an info dialog about ads.
  ///
  /// We show an info dialog about our ads experiment after the first app open.
  bool _shouldShowInfoDialog() {
    if (!isQualifiedForAds()) {
      return false;
    }

    final hasShownDialog =
        keyValueStore.getBool('ads-info-dialog-shown22') ?? false;
    if (hasShownDialog) {
      return false;
    }

    keyValueStore.setBool('ads-info-dialog-shown', true);
    return true;
  }

  // Returns the test ad unit ID for the given [format].
  //
  // Used for testing purposes only.
  String getTestAdUnitId(AdFormat format) {
    // From: https://developers.google.com/admob/flutter/banner#always_test_with_test_ads
    const testAdUnitIdBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
    const testAdUnitIdBannerIOS = 'ca-app-pub-3940256099942544/2934735716';

    // From: https://developers.google.com/admob/flutter/native/templates#always_test_with_test_ads
    const testAdUnitIdNativeAndroid = 'ca-app-pub-3940256099942544/2247696110';
    const testAdUnitIdNativeIOS = 'ca-app-pub-3940256099942544/3986624511';

    // From: https://developers.google.com/admob/flutter/interstitial#always_test_with_test_ads
    const testAdUnitIdInterstitialAndroid =
        'ca-app-pub-3940256099942544/1033173712';
    const testAdUnitIdInterstitialIOS =
        'ca-app-pub-3940256099942544/4411468910';

    return switch (PlatformCheck.currentPlatform) {
      // Test ad unit IDs from: https://developers.google.com/admob/flutter/
      Platform.android => switch (format) {
          AdFormat.banner => testAdUnitIdBannerAndroid,
          AdFormat.native => testAdUnitIdNativeAndroid,
          AdFormat.interstitial => testAdUnitIdInterstitialAndroid,
        },
      Platform.iOS => switch (format) {
          AdFormat.banner => testAdUnitIdBannerIOS,
          AdFormat.native => testAdUnitIdNativeIOS,
          AdFormat.interstitial => testAdUnitIdInterstitialIOS,
        },
      _ => 'N/A',
    };
  }

  void _listenToSubscriptionService() {
    _subscription = subscriptionService
        .hasFeatureUnlockedStream(SharezonePlusFeature.removeAds)
        .listen((hasUnlocked) {
      if (hasUnlocked) {
        areAdsVisible = false;
      } else {
        shouldShowInfoDialog = _shouldShowInfoDialog();
        areAdsVisible = isQualifiedForAds();
      }
      notifyListeners();
    });
  }

  Future<void> _initializeMobileAdsSDK() async {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
      // Since we set this value to `true` there is no need to show the consent
      // form.
      tagForUnderAgeOfConsent: 1,
    ));
    debugPrint("Google Mobile Ads SDK initialized.");
  }

  AdRequest createAdRequest() {
    return AdRequest(
      nonPersonalizedAds: true,
      // keywords, contentUrl, and neighboringContentUrls help Google AdMob to
      // show more relevant ads by providing more information about our app.
      keywords: remoteConfiguration.getStringList('ad_keywords'),
      contentUrl: remoteConfiguration.getString('ad_content_url'),
      neighboringContentUrls:
          remoteConfiguration.getStringList('ad_neighboring_urls'),
    );
  }

  Future<void> maybeShowFullscreenAd() async {
    if (!PlatformCheck.isMobile) {
      return;
    }

    if (areAdsVisible && _shouldShowFullscreenAd()) {
      await _showFullscreenAd();
    }
  }

  bool _shouldShowFullscreenAd() {
    final checkedHwCounter =
        keyValueStore.getInt('checked-homework-counter') ?? 0;

    if (checkedHwCounter == 0) {
      // For a better user experience, we don't show an ad when the user
      // completes their first homework. Technically, counter should then be 1,
      // but since we're not waiting for the counter to increment, we need to
      // check for 0.
      return false;
    }

    return checkedHwCounter % 5 == 0;
  }

  Future<void> _showFullscreenAd() async {
    String adUnitId;

    if (kDebugMode) {
      adUnitId = getTestAdUnitId(AdFormat.interstitial);
    } else {
      adUnitId = switch (PlatformCheck.currentPlatform) {
        // Copied from the AdMob Console
        Platform.android => 'ca-app-pub-7730914075870960/5232564896',
        Platform.iOS => 'ca-app-pub-7730914075870960/4462307071',
        _ => 'N/A',
      };
    }

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: createAdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
          );

          debugPrint('$ad loaded.');
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

extension on RemoteConfiguration {
  List<String> getStringList(String key) {
    return getString(key).split(',').map((e) => e.trim()).toList();
  }
}
