import 'package:flutter/material.dart';
import 'package:sharezone/widgets/svg.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';

// Karte mit CircleAvatar und dahinter eine Karte
// Wichtig: Es muss entweder ein SvgPath oder ein imagePath angeben werden!
class AvatarCard extends StatelessWidget {
  const AvatarCard({
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

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final String svgPath;
  final Size svgSize;
  final String imagePath;
  final Size imageSize;
  final double radius;
  final String kuerzel;
  final Color avatarBackgroundColor;
  final double paddingBottom;
  final Widget icon;
  final VoidCallback onTapImage;
  final Color fontColor;
  final bool withShadow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 62.5),
      child: Container(
        child: Stack(
          children: <Widget>[
            CustomCard(
              child: Container(
                width: getScreenSize(context).width,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 87.0, bottom: paddingBottom ?? 22),
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment == null
                        ? CrossAxisAlignment.start
                        : crossAxisAlignment,
                    children: children,
                  ),
                ),
              ),
            ),
            FractionalTranslation(
              translation: Offset(0.0, -0.4),
              child: Align(
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: (radius == null ? 55.0 : radius) + 10,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      ),
                      Positioned(
                        left: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              if (withShadow && !isDarkThemeEnabled(context))
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 12.5,
                                  offset: Offset(0.0, 5.0),
                                ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: radius == null ? 55.0 : radius,
                            backgroundColor: avatarBackgroundColor ??
                                Theme.of(context).primaryColor,
                            child: icon == null
                                ? svgPath == null
                                    ? imagePath == null
                                        ? Text(
                                            kuerzel ?? "",
                                            style: TextStyle(
                                              fontSize: 26,
                                              color:
                                                  fontColor ?? Colors.white,
                                            ),
                                          )
                                        : image()
                                    : svg()
                                : icon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                alignment: FractionalOffset(0.5, 0.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget svg() {
    return InkWell(
      onTap: onTapImage,
      child: SvgWidget(
        assetName: svgPath,
        size: svgSize == null ? Size(60.0, 60.0) : svgSize,
        // allowDrawingOutsideViewBox: false,
      ),
    );
  }

  Widget image() {
    return InkWell(
      onTap: onTapImage,
      child: Container(
        width: imageSize == null ? 110.0 : imageSize.width,
        height: imageSize == null ? 110.0 : imageSize.height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imagePath),
          ),
        ),
      ),
    );
  }
}
