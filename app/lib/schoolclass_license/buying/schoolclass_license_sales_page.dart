import 'package:flutter/material.dart';
import 'package:sharezone/widgets/tabs.dart';
import 'package:build_context/build_context.dart';

import 'subpages/advantages_schoolclass_license_subpage.dart';
import 'subpages/buy_subscription_schoolclass_license_subpage.dart';
import 'subpages/select_schoolclass_schoolclass_license_subpage.dart';

void openSchoolclassLicenseSalesPage(
  BuildContext context, {

  /// Id der Schulklasse für welche man eine Lizenz kaufen will.
  ///
  /// Damit kann die Auswahl der Schulklasse übersprungen werden und der Nutzer
  /// sieht direkt die Infos für die Schulklasse beim Kauf.
  ///
  /// Falls [schoolclassId] null ist, muss der Nutzer erst noch selbst die
  /// Klasse auswählen.
  String schoolclassId,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => SchoolclassLicenseSalesPage(
              schoolclassId: schoolclassId,
            ),
        settings: RouteSettings(
          name: SchoolclassLicenseSalesPage.tag,
        )),
  );
}

class SchoolclassLicenseSalesPage extends StatelessWidget {
  static const tag = 'schoolclass-license-sales-page';

  final String schoolclassId;

  const SchoolclassLicenseSalesPage({Key key, this.schoolclassId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shouldShowChooseClass = schoolclassId == null;
    return DefaultTabController(
      length: shouldShowChooseClass ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Klassenlizenz'),
        ),
        body: TabBarView(children: [
          AdvantagesSchoolclassLicenseSubpage(),
          if (shouldShowChooseClass)
            SelectSchoolclassSchoolclassLicenseSubpage(),
          BuySubscriptionSchoolclassLicenseSubpage(),
        ]),
        bottomNavigationBar: SizedBox(
          height: 100,
          child: Align(
            // alignment: Alignment,
            child: SafeArea(
              child: SharezoneTabPageSelector(
                color: Colors.grey,
                selectedColor: context.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
