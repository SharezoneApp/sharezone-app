// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart' as auth;
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/navigation/analytics/navigation_analytics.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/settings/src/subpages/about/about_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'drawer_controller.dart';
import 'tiles/drawer_tiles.dart';

part 'account_section.dart';

class SharezoneDrawer extends StatelessWidget {
  const SharezoneDrawer({super.key, this.isDesktopModus = false});

  final bool isDesktopModus;

  @override
  Widget build(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);
    return BlocProvider(
      key: navigationBloc.scaffoldKey,
      bloc: SharezoneDrawerController(isDesktopModus),
      child: Drawer(
        semanticLabel: 'Navigation öffnen',
        // No border
        shape: const Border(),
        child: _DrawerItems(isDesktopModus: isDesktopModus),
      ),
    );
  }
}

/// How-to: Drawer-Eintrag hinzufügen:
/// * Die neue Seite, zu der Navigiert werden soll, hinzufügen.
/// * Der neuen Seite `static const tag = 'xxxx-page'` Attribut hinzufügen.
/// * Dem [NavigationItem]-Enum ein Eintrag hinzufügen.
/// * Im [NavigationController] die Navigation zu dem Eintrag hinzufügen.
/// * In dem Ordner `./tiles` eine Datei hinzufügen mit dem jeweiligen
/// Drawer-Eintrag (mit `part of 'drawer_tiles.dart';`)
/// * In der Datei `tiles/drawer_tiles.dart`:
///   * `part dateiname.dart` der gerade hinzugefügten Datei hinzufügen
///   * Eine Konstante mit dem Drawer-Widget hinzufügen
/// * Unten in dieser Klasse die oben gennante Konstant in die [Column] einfügen.
class _DrawerItems extends StatelessWidget {
  final bool isDesktopModus;

  const _DrawerItems({required this.isDesktopModus});

  @override
  Widget build(BuildContext context) {
    final typeOfUser = context.watch<TypeOfUser?>() ?? TypeOfUser.unknown;
    return SafeArea(
      right: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _AccountSection(isDesktopModus: isDesktopModus),
                  const Divider(),
                  if (isDesktopModus) ...[...onlyDesktopTiles, const Divider()],
                  if (typeOfUser.isStudent) gradesTile,
                  ...functionTiles,
                  const Divider(),
                  if (typeOfUser.isStudent) sharezonePlusTile,
                  feedbackBoxTile,
                  settingsPageTile,
                ],
              ),
            ),
          ),
          const _SharezoneLogo(),
        ],
      ),
    );
  }
}

/// Displays the sharezone logo and navigate to the about page, if use taps on it
class _SharezoneLogo extends StatelessWidget {
  const _SharezoneLogo();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Über uns',
      child: InkWell(
        onTap: () {
          final drawerController = BlocProvider.of<SharezoneDrawerController>(
            context,
          );
          if (!drawerController.isDesktopModus) Navigator.pop(context);
          Navigator.pushNamed(context, AboutPage.tag);
          _logSharezoneLogoClick(context);
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ).add(const EdgeInsets.only(left: 10)),
                  child: const SharezoneLogo(
                    logoColor: LogoColor.blueLong,
                    height: 40,
                    width: 200,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _logSharezoneLogoClick(BuildContext context) {
    final analytics = BlocProvider.of<NavigationAnalytics>(context);
    analytics.logDrawerLogoClick();
  }
}

class DrawerIcon extends StatelessWidget {
  const DrawerIcon({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('drawer-open-icon-E2E'),
      icon: Icon(Icons.menu, color: color),
      tooltip: "Navigation",
      onPressed: () {
        Scaffold.of(context).openDrawer();
        _logOpenDrawer(context);
      },
    );
  }

  void _logOpenDrawer(BuildContext context) {
    final analytics = BlocProvider.of<NavigationAnalytics>(context);
    analytics.logOpenDrawer();
  }
}

// class _NumberOfOpenItems extends StatelessWidget {
//   const _NumberOfOpenItems({Key key, @required this.tag, @required this.stream})
//       : super(key: key);

//   final String tag;
//   final Stream<int> stream;

//   @override
//   Widget build(BuildContext context) {
//     final controller = BlocProvider.of<SharezoneDrawerController>(context);
//     final isPageActive = controller.isActivePage(tag);
//     return StreamBuilder<int>(
//       stream: stream,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data <= 0) return Text("");
//         return Padding(
//           padding: const EdgeInsets.only(right: 8),
//           child: Text(
//             "${snapshot.data}",
//             style: TextStyle(
//                 color: isPageActive ? primaryColor : Colors.grey[600],
//                 fontWeight: FontWeight.w600),
//           ),
//         );
//       },
//     );
//   }
// }
