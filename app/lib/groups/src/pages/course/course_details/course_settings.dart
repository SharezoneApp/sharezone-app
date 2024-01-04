// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:app_functions/app_functions_ui.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/src/pages/course/course_details/course_details_bloc.dart';
import 'package:sharezone/groups/src/pages/course/course_details/write_permission_options.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

void showExplanation(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) => InformationDialog(text: text),
  );
}

class CourseSettingsCard extends StatelessWidget {
  const CourseSettingsCard({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    final courseSettings = course.settings;
    final bloc = BlocProvider.of<CourseDetailsBloc>(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _IsPublic(isPublic: courseSettings.isPublic),
          WritePermissions(
            initialWritePermission: course.settings.writePermission,
            onChange: (newWP) => bloc.setWritePermission(newWP),
            writePermissionStream: bloc.writePermissionStream,
          ),
        ],
      ),
    );
  }
}

class _IsPublic extends StatelessWidget {
  const _IsPublic({
    required this.isPublic,
  });

  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseDetailsBloc>(context);
    return ListTile(
      title: const Text("Beitreten erlauben"),
      leading: const Icon(Icons.lock),
      onTap: () {
        Future<AppFunctionsResult<bool>> setFuture =
            bloc.setIsPublic(!isPublic);
        showAppFunctionStateDialog(context, setFuture);
      },
      onLongPress: () => showExplanation(context,
          "Über diese Einstellungen kannst du regulieren, ob neue Mitglieder dem Kurs beitreten dürfen."),
      trailing: Switch.adaptive(
        value: isPublic,
        onChanged: (newValue) {
          Future<AppFunctionsResult<bool>> setFuture =
              bloc.setIsPublic(newValue);
          showAppFunctionStateDialog(context, setFuture);
        },
      ),
    );
  }
}
