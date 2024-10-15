// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/ads/ads_controller.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({
    super.key,
    required this.adUnitId,
  });

  final String adUnitId;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? ad;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (context.read<AdsController>().isQualifiedForAds()) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final size =
            await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
                MediaQuery.sizeOf(context).width.truncate());

        if (size == null) {
          // Unable to get width of anchored banner.
          return;
        }

        if (!mounted) {
          return;
        }

        ad = BannerAd(
          adUnitId: widget.adUnitId,
          request: context.read<AdsController>().createAdRequest(),
          size: size,
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              debugPrint('$ad loaded.');
              setState(() {
                _isLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, err) {
              debugPrint('BannerAd failed to load: $err');
              ad.dispose();
            },
          ),
        )..load();
      });
    }
  }

  @override
  void dispose() {
    ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areAdsVisible = context.watch<AdsController>().areAdsVisible;
    if (!areAdsVisible || _isLoaded == false) return Container();
    return SizedBox(
      height: ad!.size.height.toDouble(),
      width: ad!.size.width.toDouble(),
      child: AdWidget(ad: ad!),
    );
  }
}
