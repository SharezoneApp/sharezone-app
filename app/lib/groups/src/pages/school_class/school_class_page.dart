// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/groups/analytics/group_analytics.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone/groups/src/pages/school_class/school_class_details.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

abstract class SchoolClassDetailsPopOption {}

class DeleteSchoolClassDetailsPopOption implements SchoolClassDetailsPopOption {
  final Future<AppFunctionsResult<bool>> appFunction;

  DeleteSchoolClassDetailsPopOption(this.appFunction);
}

class LeaveSchoolClassDetailsPopOption implements SchoolClassDetailsPopOption {
  final Future<AppFunctionsResult<bool>> appFunction;

  LeaveSchoolClassDetailsPopOption(this.appFunction);
}

Future<void> openMySchoolClassPage(
    BuildContext context, SchoolClass schoolClass) async {
  final analytics = BlocProvider.of<GroupAnalytics>(context);
  final bloc = MySchoolClassBloc(
    gateway: BlocProvider.of<SharezoneContext>(context).api,
    schoolClass: schoolClass,
    analytics: analytics,
  );
  final popOption = await Navigator.push<SchoolClassDetailsPopOption>(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider(
        bloc: bloc,
        child: const MySchoolClassPage(),
      ),
      settings: const RouteSettings(name: MySchoolClassPage.tag),
    ),
  );
  if (popOption != null && context.mounted) {
    if (popOption is LeaveSchoolClassDetailsPopOption) {
      await showAppFunctionStateDialog(context, popOption.appFunction);
    } else if (popOption is DeleteSchoolClassDetailsPopOption) {
      await showAppFunctionStateDialog(context, popOption.appFunction);
    }
  }
}

class MySchoolClassPage extends StatelessWidget {
  static const tag = "school-class-details-page";

  const MySchoolClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    return StreamBuilder<SchoolClass?>(
      stream: bloc.streamSchoolClass(),
      builder: (context, snapshot) {
        final schoolClass = snapshot.data;
        if (schoolClass == null) {
          return const Scaffold(
            body: Center(
                child: Text("Es ist ein Fehler beim Laden aufgetreten...")),
          );
        }
        return SchoolClassDetailsPage(schoolClass);
      },
    );
  }
}
