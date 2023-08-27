// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/material.dart';
import 'package:sharezone/widgets/svg.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

// Karte mit CircleAvatar und dahinter eine Karte
// Wichtig: Es muss entweder ein SvgPath oder ein imagePath angeben werden!
class AvatarCard extends StatelessWidget {
  const AvatarCard({
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.radius = 55.0,
    this.svgPath,
    this.svgSize = const Size.square(60.0),
    this.imagePath,
    this.imageSize = const Size.square(111.0),
    this.kuerzel = "",
    this.avatarBackgroundColor,
    this.paddingBottom = 22.0,
    this.icon,
    this.onTapImage,
    this.fontColor = Colors.white,
    this.withShadow = true,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final String? svgPath;
  final Size svgSize;
  final String? imagePath;
  final Size imageSize;
  final double radius;
  final String kuerzel;
  final Color? avatarBackgroundColor;
  final double paddingBottom;
  final Widget? icon;
  final VoidCallback? onTapImage;
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
                  padding: EdgeInsets.only(top: 87.0, bottom: paddingBottom),
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment,
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
                        radius: radius + 10,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      ),
                      Positioned(
                        left: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              if (withShadow == true &&
                                  !isDarkThemeEnabled(context))
                                BoxShadow(
                                  color: Colors.grey[300]!,
                                  blurRadius: 12.5,
                                  offset: Offset(0.0, 5.0),
                                ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: radius,
                            backgroundColor: avatarBackgroundColor ??
                                Theme.of(context).primaryColor,
                            child: icon == null
                                ? svgPath == null
                                    ? imagePath == null
                                        ? Text(
                                            kuerzel,
                                            style: TextStyle(
                                              fontSize: 26,
                                              color: fontColor,
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
        assetName: svgPath!,
        size: svgSize,
      ),
    );
  }

  Widget image() {
    return InkWell(
      onTap: onTapImage,
      child: Container(
        width: imageSize.width,
        height: imageSize.height,
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
