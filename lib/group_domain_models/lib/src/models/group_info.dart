// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:design/design.dart';
import 'package:group_domain_models/group_domain_models.dart';

class GroupInfo {
  final String id;
  final String? name, abbreviation;
  final Design design;
  final String? sharecode;
  // Originally we used a joinLink from the backend, but since Firebase Dynamic
  // Links was deprecated, we needed a quick solution for new links.
  // Regenerating all existing join links in the database is not feasible right
  // now, so we compute the joinLink from the sharecode (before we used another
  // link format).
  String? get joinLink =>
      sharecode == null
          ? null
          : "https://web.sharezone.net/link?type=joinbykey&data=$sharecode";
  final MemberRole? myRole;
  final GroupType groupType;

  const GroupInfo({
    required this.id,
    required String this.name,
    required this.design,
    required this.abbreviation,
    required this.sharecode,

    /// Is ignored since we compute the joinLink from the sharecode. This is a
    /// quick/hacky solution, since we can't update all the existing join links
    /// in the database to the new format right now.
    String? joinLink,
    required this.groupType,
    this.myRole,
  });

  factory GroupInfo.fromData(Map<String, dynamic> data) {
    return GroupInfo(
      id: data['id'],
      name: data['name'],
      design: Design.fromData(data['design']),
      abbreviation:
          data['abbreviation'] ?? _getAbbreviationFromName(data['name'] ?? ""),
      sharecode: data['publicKey'],
      joinLink: data['joinLink'],
      groupType: GroupType.values.byName(data['groupType']),
    );
  }

  GroupKey get groupKey => GroupKey(id: id, groupType: groupType);
}

String _getAbbreviationFromName(String name) {
  if (name.length > 2) return name.substring(0, 2);
  return name;
}
