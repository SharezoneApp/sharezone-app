// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'group_share.dart';

class AddMember extends StatelessWidget {
  const AddMember({super.key, required this.groupInfo});

  final GroupInfo groupInfo;

  @override
  Widget build(BuildContext context) {
    return GrayShimmer(
      enabled: groupInfo.sharecode == null || groupInfo.sharecode!.isEmpty,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: const Text("Teilnehmer einladen"),
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Icon(Icons.person_add, color: Theme.of(context).primaryColor),
        ),
        onTap: () => showDialog(
          context: context,
          builder: (context) =>
              ShareThisGroupDialogContent(groupInfo: groupInfo),
        ),
      ),
    );
  }
}

class MemberList extends StatelessWidget {
  const MemberList({
    super.key,
    required this.members,
    required this.allMembers,
    required this.title,
    required this.onTap,
  });

  final List<MemberData> members;
  final List<MemberData> allMembers;
  final String title;
  final Function(MemberData member) onTap;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return Container();
    return Column(
      children: <Widget>[
        _DividerWithText(text: "$title (${members.length})"),
        Column(
            children: members
                .map((MemberData member) => MemberTile(
                      memberData: member,
                      onTap: () => onTap(member),
                      onLongPress: () => onTap(member),
                    ))
                .toList()),
      ],
    );
  }
}

class LoadingMemberList extends StatelessWidget {
  const LoadingMemberList({super.key});

  @override
  Widget build(BuildContext context) {
    final placeholderUser = [
      MemberData.create(
          id: "bernd77",
          user: AppUser.create(id: "bernd77").copyWith(name: "Bernd das Brot"),
          role: MemberRole.admin),
      MemberData.create(
          id: "doduck11",
          user: AppUser.create(id: "doduck11").copyWith(name: "Donald Duck"),
          role: MemberRole.creator),
      MemberData.create(
          id: "mario11",
          user: AppUser.create(id: "mario11").copyWith(name: "Mario"),
          role: MemberRole.standard),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _DividerWithText(text: "Legenden"),
        Column(
            children: placeholderUser
                .map((u) => GrayShimmer(child: MemberTile(memberData: u)))
                .toList()),
      ],
    );
  }
}

class MemberTile extends StatelessWidget {
  const MemberTile({
    super.key,
    required this.memberData,
    this.onTap,
    this.onLongPress,
    this.withReportOption = false,
  });

  final MemberData memberData;
  final VoidCallback? onTap, onLongPress;
  final bool withReportOption;

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return ListTile(
      onLongPress: onLongPress,
      title: Text(memberData.name),
      subtitle: Text(memberData.typeOfUser.toReadableString()),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(generateAbbreviation(memberData.name),
            style: const TextStyle(color: Colors.white)),
      ),
      onTap: onTap,
      trailing: memberData.id.toString() == api.uID
          ? const Chip(label: Text("Du"))
          : withReportOption
              ? ReportIcon(
                  item: ReportItemReference.user(memberData.id.toString()),
                  color: Theme.of(context).isDarkTheme
                      ? Colors.grey
                      : Colors.grey[600],
                )
              : null,
    );
  }
}

class _DividerWithText extends StatelessWidget {
  const _DividerWithText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(width: 200),
      const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Divider(height: 0),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(text, style: TextStyle(color: Colors.grey[600])),
          ),
        ),
      ),
    ]);
  }
}
