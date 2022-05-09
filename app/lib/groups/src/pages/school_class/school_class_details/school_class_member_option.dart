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
import 'package:sharezone/additional/course_permission.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone/groups/src/widgets/member_list.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/state_sheet.dart';

Future<void> showSchoolClassMemberOptionsSheet({
  @required BuildContext context,
  @required MemberData memberData,
  @required String schoolClassID,
  @required List<MemberData> membersDataList,
}) async {
  final bloc = BlocProvider.of<MySchoolClassBloc>(context);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => BlocProvider<MySchoolClassBloc>(
      bloc: bloc,
      child: _SchoolClassMemberOptionsSheet(
        initialData: memberData,
        schoolClassID: schoolClassID,
        membersDataList: membersDataList,
      ),
    ),
  );
}

class _SchoolClassMemberOptionsSheet extends StatelessWidget {
  const _SchoolClassMemberOptionsSheet({
    @required this.initialData,
    @required this.schoolClassID,
    @required this.membersDataList,
  });

  final String schoolClassID;
  final MemberData initialData;
  final List<MemberData> membersDataList;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return StreamBuilder<bool>(
      initialData: requestPermission(
          role: membersDataList
              .singleWhere((member) => member.id == api.userId)
              .role,
          permissiontype: PermissionAccessType.admin),
      stream: bloc.isAdminStream(),
      builder: (context, snapshot) {
        final isAdmin = snapshot.data ?? false;
        return StreamBuilder<MemberData>(
          initialData: initialData,
          stream: bloc.streamMember(schoolClassID, initialData.id.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error);
            }
            if (!snapshot.hasData) {
              return Container();
            } else {
              final memberData = snapshot.data;
              final isMe = memberData.id == api.userId;
              final moreThanOneAdmin = bloc.moreThanOneAdmin(membersDataList);
              final isOnlyAdmin = (!moreThanOneAdmin) && isMe && isAdmin;
              final enabled =
                  (!isOnlyAdmin) && isAdmin && membersDataList.length != 1;
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    MemberTile(memberData: memberData, withReportOption: true),
                    const Divider(height: 0),
                    if (!isAdmin) _NoPermissions(),
                    if (isOnlyAdmin && membersDataList.length >= 2)
                      _OnlyAdminHint(),
                    if (membersDataList.length == 1) _AloneInCourse(),
                    _RoleTile(
                      memberData: memberData,
                      role: MemberRole.admin,
                      description: "Schreib- und Leserechte & Verwaltung",
                      enabled: enabled,
                      schoolClassID: schoolClassID,
                    ),
                    _RoleTile(
                      memberData: memberData,
                      role: MemberRole.creator,
                      description: "Schreib- und Leserechte",
                      enabled: enabled,
                      schoolClassID: schoolClassID,
                    ),
                    _RoleTile(
                      memberData: memberData,
                      role: MemberRole.standard,
                      description: "Leserechte",
                      enabled: enabled,
                      schoolClassID: schoolClassID,
                    ),
                    const Divider(height: 0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: memberData.id == api.userId
                          ? _LeaveCourse()
                          : _KickUser(
                              memberID: memberData.id.toString(),
                              isAdmin: isAdmin,
                            ),
                    )
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _AloneInCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24)
          .add(const EdgeInsets.only(top: 12)),
      child: Text(
        "Da du der einzige in der Schulklasse bist, kannst du deine Rolle nicht bearbeiten.",
        style: const TextStyle(color: Colors.grey, fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _NoPermissions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24)
          .add(const EdgeInsets.only(top: 12)),
      child: Text(
        "Da du kein Admin bist, hast du keine Rechte, um andere Mitglieder zu verwalten.",
        style: const TextStyle(color: Colors.grey, fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _OnlyAdminHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24)
          .add(const EdgeInsets.only(top: 12)),
      child: Text(
        "Du bist der einzige Admin in dieser Schulklasse. Daher kannst du dir keine Rechte entziehen.",
        style: const TextStyle(color: Colors.grey, fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LeaveCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    return TextButton(
      child: Text("SCHULKLASSE VERLASSEN"),
      style: TextButton.styleFrom(
        primary: Colors.red,
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Future<AppFunctionsResult<bool>> kickUser = bloc.leaveSchoolClass();
        showAppFunctionStateDialog(context, kickUser);
      },
    );
  }
}

class _KickUser extends StatelessWidget {
  const _KickUser({
    Key key,
    @required this.memberID,
    @required this.isAdmin,
  }) : super(key: key);

  final String memberID;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    return TextButton(
      child: const Text("AUS DER SCHULKLASSE KICKEN"),
      style: TextButton.styleFrom(
        primary: Colors.red,
      ),
      onPressed: isAdmin
          ? () {
              Navigator.pop(context);
              Future<AppFunctionsResult<bool>> kickUser =
                  bloc.kickMember(memberID);
              showAppFunctionStateDialog(context, kickUser);
            }
          : null,
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile(
      {Key key,
      @required this.role,
      @required this.memberData,
      this.description,
      @required this.enabled,
      @required this.schoolClassID})
      : super(key: key);

  final bool enabled;
  final MemberRole role;
  final String description;
  final MemberData memberData;
  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    return RadioListTile<MemberRole>(
        title: Text(memberRoleAsString[role]),
        subtitle: !isEmptyOrNull(description) ? Text(description) : null,
        groupValue: memberData.role == MemberRole.owner
            ? MemberRole.admin
            : memberData.role,
        value: role,
        onChanged: enabled
            ? (newRole) {
                print("PERMISSION ACCEPTED");
                Future<AppFunctionsResult<bool>> updateFuture = bloc
                    .updateMemberRole(schoolClassID, memberData.id, newRole);
                showAppFunctionStateDialog(context, updateFuture);
              }
            : null);
  }
}
