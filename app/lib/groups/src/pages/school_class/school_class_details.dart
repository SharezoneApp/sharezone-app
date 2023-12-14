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
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/pages/course/course_details/course_details_bloc.dart';
import 'package:sharezone/groups/src/pages/course/course_details/course_settings.dart';
import 'package:sharezone/groups/src/pages/course/course_details/write_permission_options.dart';
import 'package:sharezone/groups/src/pages/school_class/edit/school_class_edit_page.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone/groups/src/pages/school_class/school_class_details/school_class_member_option.dart';
import 'package:sharezone/groups/src/pages/school_class/school_class_page.dart';
import 'package:sharezone/groups/src/widgets/group_share.dart';
import 'package:sharezone/groups/src/widgets/member_section.dart';
import 'package:sharezone/groups/src/widgets/sharecode_text.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/widgets/avatar_card.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'school_class_details/school_class_course_list.dart';

Future<SchoolClassDeleteType?> showDeleteSchoolClassDialog(
    BuildContext context) async {
  return await showColumnActionsAdaptiveDialog<SchoolClassDeleteType>(
    context: context,
    title: "Klasse verlassen",
    messsage:
        "Möchtest du wirklich die Klasse verlassen?\n\nDu hast noch die Option, die Kurse der Schulklasse ebenfalls zu löschen oder diese zu behalten. Werden die Kurse der Schulklasse nicht gelöscht, bleiben diese weiterhin bestehen.",
    actions: [
      const AdaptiveDialogAction(
        title: "Mit Kursen löschen",
        popResult: SchoolClassDeleteType.withCourses,
      ),
      const AdaptiveDialogAction(
        title: "Ohne Kurse löschen",
        popResult: SchoolClassDeleteType.withoutCourses,
      ),
    ],
  );
}

Future<bool?> showLeaveSchoolClassDialog(BuildContext context) async {
  return await showLeftRightAdaptiveDialog<bool>(
    context: context,
    defaultValue: false,
    title: ThemePlatform.isCupertino
        ? "Möchtest du möchtest du wirklich Schulklasse verlassen?"
        : null,
    content: !ThemePlatform.isCupertino
        ? const Text("Möchtest du möchtest du wirklich Schulklasse verlassen?")
        : null,
    right: AdaptiveDialogAction.leave,
  );
}

class SchoolClassDetailsPage extends StatelessWidget {
  const SchoolClassDetailsPage(this.schoolClass, {super.key});

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    final isAdmin =
        schoolClass.myRole.hasPermission(GroupPermission.administration);
    return Scaffold(
      appBar: AppBar(
        title: Text(schoolClass.name),
        centerTitle: true,
        actions: <Widget>[
          ReportIcon(item: ReportItemReference.schoolClass(schoolClass.id)),
          if (isAdmin) _EditIcon(schoolClass: schoolClass),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: MaxWidthConstraintBox(
          child: StreamBuilder<List<MemberData>>(
            stream: bloc.streamMembers(schoolClass.id),
            builder: (context, snapshot) {
              final members = snapshot.data ?? <MemberData>[];
              return Column(
                children: <Widget>[
                  _SchoolClassAvatarCard(
                      schoolClass: schoolClass, memberCount: members.length),
                  SchoolClassCoursesList(
                    key: ValueKey(schoolClass.id),
                    schoolClassID: schoolClass.id,
                  ),
                  _SettingsCard(schoolClass: schoolClass),
                  MemberSection(
                    splittedMemberList: createSplittedMemberList(members),
                    groupInfo: schoolClass.toGroupInfo(),
                    allMembers: members,
                    onTap: (member) {
                      showSchoolClassMemberOptionsSheet(
                        context: context,
                        memberData: member,
                        membersDataList: members,
                        schoolClassID: schoolClass.id,
                      );
                    },
                  ),
                  SafeArea(
                    bottom: !isAdmin,
                    child: _LeaveSchoolClassButton(
                      onDialogClose: (appFunction) => Navigator.pop(context,
                          LeaveSchoolClassDetailsPopOption(appFunction)),
                    ),
                  ),
                  if (isAdmin)
                    _DeleteSchoolClassButton(
                        onDialogClose: (appFunction) => Navigator.pop(context,
                            DeleteSchoolClassDetailsPopOption(appFunction))),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EditIcon extends StatelessWidget {
  const _EditIcon({
    Key? key,
    required this.schoolClass,
  }) : super(key: key);

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Bearbeiten',
      icon: const Icon(Icons.edit),
      onPressed: () => openSchoolClassEditPage(context, schoolClass),
    );
  }
}

class _LeaveSchoolClassButton extends StatelessWidget {
  const _LeaveSchoolClassButton({
    Key? key,
    required this.onDialogClose,
  }) : super(key: key);

  final Function(Future<AppFunctionsResult<bool>>) onDialogClose;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DestroyButton(
        color: const Color(0xFFff7d7d),
        title: const Text("KLASSE VERLASSEN"),
        onTap: () async {
          final confirmed = await showLeaveSchoolClassDialog(context);
          if (confirmed == true) {
            onDialogClose(bloc.leaveSchoolClass());
          }
        },
      ),
    );
  }
}

class _DeleteSchoolClassButton extends StatelessWidget {
  const _DeleteSchoolClassButton({
    Key? key,
    required this.onDialogClose,
  }) : super(key: key);

  final Function(Future<AppFunctionsResult<bool>>) onDialogClose;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DestroyButton(
          title: const Text("KLASSE LÖSCHEN"),
          color: Colors.redAccent,
          onTap: () async {
            final schoolClassDeleteType =
                await showDeleteSchoolClassDialog(context);
            if (schoolClassDeleteType != null) {
              onDialogClose(bloc.deleteSchoolClass(schoolClassDeleteType));
            }
          },
        ),
      ),
    );
  }
}

class _SchoolClassAvatarCard extends StatelessWidget {
  const _SchoolClassAvatarCard({
    required this.schoolClass,
    this.memberCount = 0,
  });

  final SchoolClass schoolClass;
  final int memberCount;

  String _getSchoolClassAbbreviation() {
    if (isEmptyOrNull(schoolClass.name)) return '';
    if (schoolClass.name.length == 1) return schoolClass.name;
    return schoolClass.name.substring(0, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AvatarCard(
          crossAxisAlignment: CrossAxisAlignment.center,
          kuerzel: _getSchoolClassAbbreviation(),
          avatarBackgroundColor: schoolClass.getDesign().color.withOpacity(0.2),
          fontColor: schoolClass.getDesign().color,
          withShadow: false,
          paddingBottom: 0,
          children: <Widget>[
            Text(
              schoolClass.name,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            MemberCountText(memberCount: memberCount),
            const SizedBox(height: 16),
            SharecodeText(
              schoolClass.personalSharecode ?? schoolClass.sharecode,
            ),
            const Divider(height: 40),
            ShareGroupSection(groupInfo: schoolClass.toGroupInfo()),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({Key? key, required this.schoolClass}) : super(key: key);

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    if (!bloc.isAdmin()) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SchoolClassSettingsCard(settings: schoolClass.settings),
        const SizedBox(height: 16),
      ],
    );
  }
}

class SchoolClassSettingsCard extends StatelessWidget {
  const SchoolClassSettingsCard({Key? key, required this.settings})
      : super(key: key);

  final CourseSettings settings;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _IsPublic(isPublic: settings.isPublic),
          WritePermissions(
            initialWritePermission: settings.writePermission,
            onChange: (newWP) => bloc.setWritePermission(newWP),
            writePermissionStream: bloc.writePermissionStream(),
            annotation:
                "Die Einstellung wird direkt auf alle Kurse übertragen, die mit der Schulklasse verbunden sind.",
          ),
        ],
      ),
    );
  }
}

class _IsPublic extends StatelessWidget {
  const _IsPublic({Key? key, required this.isPublic}) : super(key: key);

  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    return ListTile(
      title: const Text("Beitreten erlauben"),
      leading: const Icon(Icons.lock),
      onTap: () {
        final setFuture = bloc.setIsPublic(!isPublic);
        showAppFunctionStateDialog(context, setFuture);
      },
      onLongPress: () => showExplanation(context,
          "Über diese Einstellungen kannst du regulieren, ob neue Mitglieder dem Kurs beitreten dürfen.\n\nDie Einstellung wird direkt auf alle Kurse übertragen, die mit der Schulklasse verbunden sind."),
      trailing: Switch.adaptive(
        value: isPublic,
        onChanged: (newValue) {
          final setFuture = bloc.setIsPublic(newValue);
          showAppFunctionStateDialog(context, setFuture);
        },
      ),
    );
  }
}
