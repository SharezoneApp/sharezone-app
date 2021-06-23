import 'package:flutter/material.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/image_text.dart';
import 'package:sharezone_website/widgets/subline.dart';
import 'package:sharezone_website/widgets/svg.dart';
import 'package:sharezone_website/widgets/transparent_button.dart';

class AllPlatforms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImageText(
      imagePosition: ImagePosition.right,
      body: _AllPlatformsText(),
      image: _AllPlatformsImage(),
    );
  }
}

class _AllPlatformsImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/all-platforms.png",
      height: 300,
    );
  }
}

class _AllPlatformsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey('all-plattforms'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Headline(
            "Auf allen Geräten verfügbar.",
          ),
          const SizedBox(height: 16),
          Subline(
            "Sharezone funktioniert auf allen Systemen. Somit kannst Du jederzeit auf deine Daten zugreifen.",
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TransparentButton.openLink(
                      link: "https://sharezone.net/ios",
                      child: PlatformSvg.asset(
                        "assets/get_it_on/appstore.svg",
                        height: 52,
                      ),
                    ),
                    TransparentButton.openLink(
                      link: "https://sharezone.net/android",
                      child: Image.asset(
                        "assets/get_it_on/android.png",
                        height: 75,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TransparentButton.openLink(
                      link: Theme.of(context).platform == TargetPlatform.macOS
                          ? "https://sharezone.net/macos-direct"
                          : "https://sharezone.net/macos",
                      child: PlatformSvg.asset(
                        "assets/get_it_on/macos.svg",
                        height: 52,
                      ),
                    ),
                    const SizedBox(width: 12),
                    TransparentButton.openLink(
                      link: "https://web.sharezone.net",
                      child: Image.asset(
                        "assets/get_it_on/web.png",
                        height: 52,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
