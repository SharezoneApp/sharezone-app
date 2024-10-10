import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? ad;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ad = BannerAd(
        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        request: const AdRequest(),
        size: AdSize(
          width: MediaQuery.of(context).size.width.toInt(),
          height: 50,
        ),
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            setState(() {
              _isLoaded = true;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (ad, err) {
            debugPrint('BannerAd failed to load: $err');
            // Dispose the ad here to free resources.
            ad.dispose();
          },
        ),
      )..load();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded == false) return Container();
    return SizedBox(
      height: ad!.size.height.toDouble(),
      width: ad!.size.width.toDouble(),
      child: AdWidget(ad: ad!),
    );
  }
}
