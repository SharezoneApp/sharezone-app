// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/src/models/splitted_member_list.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'member_list.dart';

class MemberSection extends StatelessWidget {
  const MemberSection({
    super.key,
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
              AddMember(groupInfo: groupInfo),
              _isLoading()
                  ? const LoadingMemberList()
                  : Column(
                    children: <Widget>[
                      MemberList(
                        title: context.l10n.groupsMembersAdminsTitle,
                        members: splittedMemberList.admins,
                        allMembers: allMembers,
                        onTap: onTap,
                      ),
                      MemberList(
                        title: context.l10n.groupsMembersActiveMemberTitle,
                        members: splittedMemberList.creator,
                        allMembers: allMembers,
                        onTap: onTap,
                      ),
                      MemberList(
                        title: context.l10n.groupsMembersPassiveMemberTitle,
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
  const MemberCountText({super.key, this.memberCount = 0});

  final int memberCount;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.groupsMemberCount(memberCount),
      style: const TextStyle(color: Colors.grey, fontSize: 13),
    );
  }
}
