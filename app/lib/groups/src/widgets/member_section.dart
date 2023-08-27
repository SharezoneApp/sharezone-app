// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/src/models/splitted_member_list.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'member_list.dart';

class MemberSection extends StatelessWidget {
  const MemberSection({
    required this.splittedMemberList,
    required this.allMembers,
    required this.groupInfo,
    required this.onTap,
  });

  final List<MemberData> allMembers;
  final SplittedMemberList splittedMemberList;
  final GroupInfo groupInfo;
  final Function(MemberData member) onTap;

  bool _isLoading() =>
      groupInfo.sharecode == null || groupInfo.sharecode!.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AddMember(
                groupInfo: groupInfo,
              ),
              _isLoading()
                  ? LoadingMemberList()
                  : Column(
                      children: <Widget>[
                        MemberList(
                          title: "Administratoren",
                          members: splittedMemberList.admins,
                          allMembers: allMembers,
                          onTap: onTap,
                        ),
                        MemberList(
                          title: "Aktives Mitglied (Schreib- und Leserechte)",
                          members: splittedMemberList.creator,
                          allMembers: allMembers,
                          onTap: onTap,
                        ),
                        MemberList(
                          title: "Passives Mitglied (nur Leserechte)",
                          members: splittedMemberList.reader,
                          allMembers: allMembers,
                          onTap: onTap,
                        ),
                      ],
                    ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class MemberCountText extends StatelessWidget {
  const MemberCountText({Key? key, this.memberCount = 0}) : super(key: key);

  final int memberCount;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Anzahl der Teilnehmer: $memberCount",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 13,
      ),
    );
  }
}
