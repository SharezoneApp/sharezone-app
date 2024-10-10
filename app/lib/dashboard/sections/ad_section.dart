import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAd();
    });
  }

  final String _adUnitId = PlatformCheck.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  /// Loads a native ad.
  void loadAd() {
    nativeAd = NativeAd(
        adUnitId: _adUnitId,
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
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.purple,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_nativeAdIsLoaded) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: CustomCard(
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
                maxHeight: 140,
              ),
              child: AdWidget(ad: nativeAd!),
            ),
          ],
        ),
      ),
    );
  }
}
