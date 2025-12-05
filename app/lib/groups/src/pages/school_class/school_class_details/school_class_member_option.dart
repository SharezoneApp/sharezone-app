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
import 'package:helper_functions/helper_functions.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone/groups/src/widgets/member_list.dart';
import 'package:sharezone/main/application_bloc.dart';

Future<void> showSchoolClassMemberOptionsSheet({
  required BuildContext context,
  required MemberData memberData,
  required String schoolClassID,
  required List<MemberData> membersDataList,
}) async {
  final bloc = BlocProvider.of<MySchoolClassBloc>(context);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder:
        (context) => BlocProvider<MySchoolClassBloc>(
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
    required this.initialData,
    required this.schoolClassID,
    required this.membersDataList,
  });

  final String schoolClassID;
  final MemberData initialData;
  final List<MemberData> membersDataList;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return StreamBuilder<bool>(
      initialData: membersDataList
          .singleWhere((member) => member.id == api.userId)
          .role
          .hasPermission(GroupPermission.administration),
      stream: bloc.isAdminStream(),
      builder: (context, snapshot) {
        final isAdmin = snapshot.data ?? false;
        return StreamBuilder<MemberData>(
          initialData: initialData,
          stream: bloc.streamMember(schoolClassID, initialData.id.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error!);
            }
            if (!snapshot.hasData) {
              return Container();
            } else {
              final memberData = snapshot.data!;
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
                    _PermissionRadioGroup(
                      memberData: memberData,
                      enabled: enabled,
                      schoolClassID: schoolClassID,
                    ),
                    const Divider(height: 0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child:
                          memberData.id == api.userId
                              ? _LeaveCourse()
                              : _KickUser(
                                memberID: memberData.id.toString(),
                                isAdmin: isAdmin,
                              ),
                    ),
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

class _PermissionRadioGroup extends StatelessWidget {
  const _PermissionRadioGroup({
    required this.memberData,
    required this.enabled,
    required this.schoolClassID,
  });

  final MemberData memberData;
  final bool enabled;
  final String schoolClassID;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    return RadioGroup<MemberRole>(
      groupValue:
          memberData.role == MemberRole.owner
              ? MemberRole.admin
              : memberData.role,
      onChanged: (newRole) {
        if (newRole == null) return;
        Future<AppFunctionsResult<bool>> updateFuture = bloc.updateMemberRole(
          schoolClassID,
          memberData.id,
          newRole,
        );
        showAppFunctionStateDialog(context, updateFuture);
      },
      child: Column(
        children: [
          _RoleTile(
            role: MemberRole.admin,
            description: "Schreib- und Leserechte & Verwaltung",
            enabled: enabled,
          ),
          _RoleTile(
            role: MemberRole.creator,
            description: "Schreib- und Leserechte",
            enabled: enabled,
          ),
          _RoleTile(
            role: MemberRole.standard,
            description: "Leserechte",
            enabled: enabled,
          ),
        ],
      ),
    );
  }
}

class _AloneInCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ).add(const EdgeInsets.only(top: 12)),
      child: const Text(
        "Da du der einzige in der Schulklasse bist, kannst du deine Rolle nicht bearbeiten.",
        style: TextStyle(color: Colors.grey, fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _NoPermissions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ).add(const EdgeInsets.only(top: 12)),
      child: const Text(
        "Da du kein Admin bist, hast du keine Rechte, um andere Mitglieder zu verwalten.",
        style: TextStyle(color: Colors.grey, fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _OnlyAdminHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ).add(const EdgeInsets.only(top: 12)),
      child: const Text(
        "Du bist der einzige Admin in dieser Schulklasse. Daher kannst du dir keine Rechte entziehen.",
        style: TextStyle(color: Colors.grey, fontSize: 11),
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
      style: TextButton.styleFrom(foregroundColor: Colors.red),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Future<AppFunctionsResult<bool>> kickUser = bloc.leaveSchoolClass();
        showAppFunctionStateDialog(context, kickUser);
      },
      child: const Text("SCHULKLASSE VERLASSEN"),
    );
  }
}

class _KickUser extends StatelessWidget {
  const _KickUser({required this.memberID, required this.isAdmin});

  final String memberID;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MySchoolClassBloc>(context);
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: Colors.red),
      onPressed:
          isAdmin
              ? () {
                Navigator.pop(context);
                Future<AppFunctionsResult<bool>> kickUser = bloc.kickMember(
                  memberID,
                );
                showAppFunctionStateDialog(context, kickUser);
              }
              : null,
      child: const Text("AUS DER SCHULKLASSE KICKEN"),
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({
    required this.role,
    this.description,
    required this.enabled,
  });

  final bool enabled;
  final MemberRole role;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<MemberRole>(
      title: Text(memberRoleAsString[role]!),
      subtitle: !isEmptyOrNull(description) ? Text(description!) : null,
      value: role,
      enabled: enabled,
    );
  }
}
