import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/ads/ads_controller.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAd();
    });
  }

  /// Loads a native ad.
  void loadAd() {
    nativeAd = NativeAd(
      adUnitId: context.read<AdsController>().getAdUnitId(AdFormat.native),
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
    if (!areAdsVisible || !_nativeAdIsLoaded) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
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
                      text: 'Sharezone Plus',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const TextSpan(
                      text: ' erwerben.',
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
              maxHeight: 120,
            ),
            child: AdWidget(ad: nativeAd!),
          ),
        ],
      ),
    );
  }
}
