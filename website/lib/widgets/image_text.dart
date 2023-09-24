import 'package:flutter/material.dart';
import 'package:sharezone_website/home/home_page.dart';

import 'section.dart';

enum ImagePosition { right, left }

class ImageText extends StatelessWidget {
  const ImageText({
    super.key,
    this.body,
    this.imagePosition,
    this.image,
    this.desktopSpacing = 24.0,
  });

  final Widget? image;
  final Widget? body;
  final double desktopSpacing;
  final ImagePosition? imagePosition;

  @override
  Widget build(BuildContext context) {
    return Section(
      child: isTablet(context)
          ? Column(
              children: [
                image!,
                const SizedBox(height: 32),
                body!,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (imagePosition == ImagePosition.left) ...[
                  image!,
                  SizedBox(width: desktopSpacing),
                  Expanded(child: body!)
                ] else ...[
                  Expanded(child: body!),
                  SizedBox(width: desktopSpacing),
                  image!
                ]
              ],
            ),
    );
  }
}
