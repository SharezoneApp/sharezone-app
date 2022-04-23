// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_widgets/svg.dart';

class IconLicense extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lizenzen: Icons"), centerTitle: true),
      body: ListView(children: IconsLicenses.icons),
    );
  }
}

class IconListTitle extends StatelessWidget {
  const IconListTitle(
      {@required this.author,
      @required this.license,
      @required this.iconPath,
      @required this.url});

  final String author;
  final String license;
  final String iconPath;
  final String url;

  static const double _svgSize = 35.0;

  @override
  Widget build(BuildContext context) {
    // Unterscheiden zwischen SVG und PNG Datei
    Widget _asset;
    if (iconPath.endsWith(".svg")) {
      _asset = SizedBox(
        width: _svgSize,
        height: _svgSize,
        child: PlatformSvg.asset(iconPath),
      );
    } else
      _asset = SizedBox(
        width: _svgSize,
        height: _svgSize,
        child: Image(
          image: AssetImage(iconPath),
        ),
      );

    return ListTile(
      title: Text("Icon made by $author"),
      subtitle: Text(license),
      leading: _asset,
//      isThreeLine: true,
      trailing: Icon(Icons.open_in_browser),
      onTap: () {
        launchURL(url);
      },
    );
  }
}

class IconsLicenses {
  static const freepik = "Freepik";
  static const pixelPerfect = "Pixel Perfect";
  static const daveGandy = "Dave Gandy";
  static const icomoon = "Icomoon";
  static const smashicons = "Smashicons";

  static const flationURL = "https://www.flaticon.com";
  static const freepikURL = "https://www.flaticon.com/authors/freepik";
  static const daveGandyURL = "https://www.flaticon.com/authors/dave-gandy";
  static const icomoonURL = "https://www.flaticon.com/authors/icomoon";
  static const smashiconsURL = "https://www.flaticon.com/authors/smashicons";

  static const licenseFlation = "Flaticon Basic License";
  static const licenseCC = "Attribution 3.0 Unported (CC BY 3.0)";

  static List<IconListTitle> icons = [
    IconListTitle(
        author: freepik,
        iconPath: 'assets/icons/fire.svg',
        url: freepikURL,
        license: licenseFlation),
    IconListTitle(
        author: freepik,
        iconPath: 'assets/icons/professor.svg',
        url: freepikURL,
        license: licenseFlation),
    IconListTitle(
        author: freepik,
        iconPath: 'assets/icons/ghost.svg',
        url: freepikURL,
        license: licenseFlation),
    IconListTitle(
        author: freepik,
        iconPath: 'assets/icons/parents.svg',
        url: freepikURL,
        license: licenseFlation),
    IconListTitle(
        author: freepik,
        iconPath: 'assets/icons/students.svg',
        url: freepikURL,
        license: licenseFlation),
    IconListTitle(
        author: pixelPerfect,
        iconPath: 'assets/icons/instagram.svg',
        url: flationURL,
        license: licenseFlation),
    IconListTitle(
        author: smashicons,
        iconPath: 'assets/icons/game-controller.svg',
        url: smashiconsURL,
        license: licenseFlation),
    IconListTitle(
        author: daveGandy,
        iconPath: 'assets/icons/email.svg',
        url: daveGandyURL,
        license: licenseCC),
  ];
}
