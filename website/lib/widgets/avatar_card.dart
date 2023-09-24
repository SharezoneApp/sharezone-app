import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'shadow_card.dart';

// Karte mit CircleAvatar und dahinter eine Karte
// Wichtig: Es muss entweder ein SvgPath oder ein imagePath angeben werden!
class AvatarCard extends StatelessWidget {
  const AvatarCard({
    super.key,
    this.children,
    this.crossAxisAlignment,
    this.radius,
    this.svgPath,
    this.svgSize,
    this.imagePath,
    this.imageSize,
    this.kuerzel,
    this.avatarBackgroundColor,
    this.paddingBottom,
    this.icon,
    this.onTapImage,
    this.fontColor,
    this.withShadow = true,
  });

  final List<Widget>? children;
  final CrossAxisAlignment? crossAxisAlignment;
  final String? svgPath;
  final Size? svgSize;
  final String? imagePath;
  final Size? imageSize;
  final double? radius;
  final String? kuerzel;
  final Color? avatarBackgroundColor;
  final double? paddingBottom;
  final Widget? icon;
  final VoidCallback? onTapImage;
  final Color? fontColor;
  final bool withShadow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 62.5),
      child: Stack(
        children: <Widget>[
          CustomCard(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 87.0, bottom: paddingBottom ?? 22),
                child: Column(
                  crossAxisAlignment: crossAxisAlignment == null
                      ? CrossAxisAlignment.start
                      : crossAxisAlignment!,
                  children: children!,
                ),
              ),
            ),
          ),
          FractionalTranslation(
            translation: const Offset(0.0, -0.4),
            child: Align(
              alignment: const FractionalOffset(0.5, 0.0),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: (radius ?? 55.0) + 10,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  Positioned(
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (withShadow)
                            BoxShadow(
                              color: Colors.grey[300]!,
                              blurRadius: 12.5,
                              offset: const Offset(0.0, 5.0),
                            ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: radius ?? 55.0,
                        backgroundColor: avatarBackgroundColor ??
                            Theme.of(context).primaryColor,
                        child: icon ??
                            (svgPath == null
                                ? imagePath == null
                                    ? Text(
                                        kuerzel ?? "",
                                        style: TextStyle(
                                          fontSize: 26,
                                          color: fontColor ?? Colors.white,
                                        ),
                                      )
                                    : image()
                                : svg()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget svg() {
    return InkWell(
      onTap: onTapImage,
      child: SvgPicture.asset(
        svgPath!,
        width: svgSize?.width,
        height: svgSize?.height,
      ),
    );
  }

  Widget image() {
    return InkWell(
      onTap: onTapImage,
      child: Container(
        width: imageSize == null ? 110.0 : imageSize!.width,
        height: imageSize == null ? 110.0 : imageSize!.height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imagePath!),
          ),
        ),
      ),
    );
  }
}
