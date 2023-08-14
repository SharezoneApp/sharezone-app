// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/pages/school_class/edit/school_class_edit_page.dart';
import 'package:sharezone/groups/src/widgets/group_share.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../my_school_class_bloc.dart';
import '../school_class_details.dart';
import '../school_class_page.dart';

enum _SchoolClassLongPressResult { edit, leave, delete }

class SchoolClassCard extends StatelessWidget {
  const SchoolClassCard(this.schoolClass);

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context) {
    final isAdmin =
        schoolClass.myRole.hasPermission(GroupPermission.administration);
    final gateway = BlocProvider.of<SharezoneContext>(context).api;
    final bloc = MySchoolClassBloc(schoolClass: schoolClass, gateway: gateway);
    return CustomCard(
      child: ListTile(
        leading: Hero(
          tag: schoolClass.id,
          child: _AbbreviationAvatar(name: schoolClass.name),
        ),
        title: Text(schoolClass.name),
        trailing: ShareIconButton(schoolClass: schoolClass),
        onTap: () => openMySchoolClassPage(context, schoolClass),
        onLongPress: () async {
          final result =
              await showLongPressAdaptiveDialog<_SchoolClassLongPressResult>(
            title: "Klasse: ${schoolClass.name}",
            context: context,
            longPressList: [
              if (isAdmin)
                const LongPress(
                    title: "Bearbeiten",
                    popResult: _SchoolClassLongPressResult.edit,
                    icon: Icon(Icons.edit)),
              const LongPress(
                title: "Verlassen",
                popResult: _SchoolClassLongPressResult.leave,
                icon: Icon(Icons.cancel),
              ),
              if (isAdmin)
                const LongPress(
                  title: "Löschen",
                  popResult: _SchoolClassLongPressResult.delete,
                  icon: Icon(Icons.delete),
                ),
            ],
          );

          switch (result) {
            case _SchoolClassLongPressResult.edit:
              openSchoolClassEditPage(context, schoolClass);
              break;
            case _SchoolClassLongPressResult.leave:
              final result = await showLeaveSchoolClassDialog(context);
              if (result == true) {
                await showAppFunctionStateDialog(
                    context, bloc.leaveSchoolClass());
              }
              break;
            case _SchoolClassLongPressResult.delete:
              final schoolClassDeleteType =
                  await showDeleteSchoolClassDialog(context);
              if (schoolClassDeleteType != null) {
                await showAppFunctionStateDialog(
                    context, bloc.deleteSchoolClass(schoolClassDeleteType));
              }
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

class _AbbreviationAvatar extends StatelessWidget {
  const _AbbreviationAvatar({Key key, @required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Design.standard().color.withOpacity(0.2),
      child: Text(
        _getAbbreviation(name),
        style: TextStyle(color: Design.standard().color),
      ),
    );
  }

  String _getAbbreviation(String name) {
    if (name == null) return "";
    if (name.length <= 1) return name;
    return name.substring(0, 2).toUpperCase();
  }
}

class ShareIconButton extends StatelessWidget {
  const ShareIconButton({
    @required this.schoolClass,
  });

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return IconButton(
      icon: Icon(Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoIcons.share
          : Icons.share),
      onPressed: () {
        analytics.log(NamedAnalyticsEvent(name: "school_class_share_dialog"));
        showDialog(
          context: context,
          builder: (context) =>
              ShareThisGroupDialogContent(groupInfo: schoolClass.toGroupInfo()),
        );
      },
    );
  }
}
