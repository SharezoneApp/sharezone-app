import 'package:flutter/material.dart';
import 'package:sharezone_widgets/svg.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone/widgets/settings/icon_license.dart';

class LicensesPage extends StatelessWidget {
  static const String tag = "license-page";

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(title: const Text("Lizenzen"), centerTitle: true),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: GridView.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 1 : 2,
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 32.0,
                padding: const EdgeInsets.all(32.0),
                childAspectRatio: (orientation == Orientation.portrait)
                    ? getScreenSize(context).height / 660
                    : getScreenSize(context).width / 505,
                children: kindOfLicenseList.map((LicenseItem licenseItem) {
                  return LicenseModel(licenseItem: licenseItem);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<LicenseItem> kindOfLicenseList = <LicenseItem>[
    LicenseItem(
      title: "Icons",
      nextPageWidget: IconLicense(),
      svgURL: "https://www.sharezone.net/images/app/lizenz_icons.svg",
    ),
    LicenseItem(
      title: "Plugins & Weiteres",
      nextPageWidget: LicensePage(),
      svgURL: "https://www.sharezone.net/images/app/lizenz_icons.svg",
    ),
  ];
}

class LicenseItem {
  LicenseItem({
    this.title,
    this.nextPageWidget,
    this.svgURL,
  });

  final String title;
  final Widget nextPageWidget;
  final String svgURL;
}

class LicenseModel extends StatelessWidget {
  const LicenseModel({
    @required this.licenseItem,
  });

  final LicenseItem licenseItem;

  @override
  Widget build(BuildContext context) {
    void onTap() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return licenseItem.nextPageWidget;
          },
        ),
      );
    }

    final Widget svg = GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
        width: 25.0,
        height: 10.0,
        child: PlatformSvg.network(licenseItem.svgURL),
      ),
    );

    return GridTile(
      footer: GestureDetector(
        onTap: onTap,
        child: GridTileBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(licenseItem.title),
          ),
          backgroundColor: Colors.black45,
        ),
      ),
      child: Container(
        color: Color(0xFF132B45),
        child: svg,
      ),
    );
  }
}
