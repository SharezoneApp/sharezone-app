import 'package:flutter/material.dart';
import 'package:sharezone_widgets/svg.dart';
import 'package:sharezone/data/icon_licences.dart';
import 'package:sharezone/util/launch_link.dart';

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
