// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/ads/ads_controller.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class DashboardAds extends StatefulWidget {
  const DashboardAds({super.key});

  @override
  State<DashboardAds> createState() => _DashboardAdsState();
}

class _DashboardAdsState extends State<DashboardAds> {
  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  void initState() {
    super.initState();
    if (context.read<AdsController>().isQualifiedForAds()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadAd();
      });
    }
  }

  String getAdUnitId() {
    if (kDebugMode) {
      return context.read<AdsController>().getTestAdUnitId(AdFormat.native);
    }

    return switch (PlatformCheck.currentPlatform) {
      // Copied from the AdMob Console
      Platform.android => 'ca-app-pub-7730914075870960/4681798929',
      Platform.iOS => 'ca-app-pub-7730914075870960/2027715422',
      _ => 'N/A',
    };
  }

  /// Loads a native ad.
  void loadAd() {
    nativeAd = NativeAd(
      adUnitId: getAdUnitId(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad here to free resources.
          debugPrint('$NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
      request: context.read<AdsController>().createAdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: DefaultTextStyle.of(context).style.color,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
      ),
    )..load();
  }

  @override
  dispose() {
    nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areAdsVisible = context.watch<AdsController>().areAdsVisible;
    if (!areAdsVisible) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: GestureDetector(
              onTap: () => navigateToSharezonePlusPage(context),
              child: Text.rich(
                TextSpan(
                  text:
                      'Dank dieser Anzeige ist Sharezone kostenlos. Falls du die Anzeige nicht sehen möchtest, kannst du ',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: context.l10n.dashboardAdSectionSharezonePlusLabel,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: context.l10n.dashboardAdSectionAcquireSuffix,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 320, // minimum recommended width
              minHeight: 90, // minimum recommended height
              maxWidth: 500,
              maxHeight: 100,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _nativeAdIsLoaded
                      ? AdWidget(ad: nativeAd!)
                      : const _Placeholder(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: min(500, MediaQuery.of(context).size.width - 24),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color:
            Theme.of(context).isDarkTheme ? Colors.grey[900] : Colors.grey[100],
        child: Center(child: Text(context.l10n.adsLoading)),
      ),
    );
  }
}
