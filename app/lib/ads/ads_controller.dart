import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:platform_check/platform_check.dart';
import 'package:remote_configuration/remote_configuration.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';

class AdsController extends ChangeNotifier {
  final SubscriptionService subscriptionService;
  final RemoteConfiguration remoteConfiguration;
  final KeyValueStore keyValueStore;

  /// Defines if ads are visible for the current user.
  bool areAdsVisible = false;
  StreamSubscription<bool>? _subscription;

  AdsController({
    required this.subscriptionService,
    required this.remoteConfiguration,
    required this.keyValueStore,
  }) {
    if (remoteConfiguration.getBool('ads_enabled')) {
      _initializeMobileAdsSDK();
      listenToSubscriptionService();
    }
  }

  String getAdUnitId() {
    if (kDebugMode) {
      return switch (PlatformCheck.currentPlatform) {
        // Test ad unit IDs from:
        // https://developers.google.com/admob/flutter/banner#android
        Platform.android => 'ca-app-pub-3940256099942544/6300978111',
        Platform.iOS => 'ca-app-pub-3940256099942544/2934735716',
        _ => 'N/A',
      };
    }

    return switch (PlatformCheck.currentPlatform) {
      // In case you need to change the ad unit ID, also update the one in the
      // AndroidManifest.xml file.
      Platform.android => 'ca-app-pub-7730914075870960~2331360962',
      Platform.iOS => 'ca-app-pub-7730914075870960~4953718516',
      _ => 'N/A',
    };
  }

  void listenToSubscriptionService() {
    _subscription = subscriptionService
        .hasFeatureUnlockedStream(SharezonePlusFeature.removeAds)
        .listen((hasUnlocked) {
      if (hasUnlocked) {
        areAdsVisible = false;
      } else {
        areAdsVisible = remoteConfiguration.getBool('ads_enabled');
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
    if (areAdsVisible && _shouldShowFullscreenAd()) {
      await _showFullscreenAd(adUnitId: getAdUnitId());
    }
  }

  bool _shouldShowFullscreenAd() {
    final editingHwCounter =
        keyValueStore.getInt('homework-editing-counter') ?? 0;
    final creatingHwCounter =
        keyValueStore.getInt('homework-creating-counter') ?? 0;
    final sum = editingHwCounter + creatingHwCounter;

    if (sum == 0) {
      // For a better user experience, we don't want to show an ad when the user
      // shows his first homework. Technically, the sum should then be 1, but
      // since we're not waiting for the counter to increment, we need to check
      // for 0.
      return false;
    }

    return sum % 5 == 0;
  }

  Future<void> _showFullscreenAd({
    required String adUnitId,
  }) async {
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
