// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:design/design.dart';

class GroupInfo {
  final String id;
  final String name, abbreviation;
  final Design design;
  final String sharecode, joinLink;
  final String meetingID;
  final MemberRole myRole;
  final GroupType groupType;

  const GroupInfo({
    @required this.id,
    @required this.name,
    @required this.design,
    @required this.abbreviation,
    @required this.sharecode,
    @required this.meetingID,
    @required this.joinLink,
    @required this.groupType,
    this.myRole,
  })  : assert(id != null),
        assert(name != null),
        assert(groupType != null);

  factory GroupInfo.fromData(Map<String, dynamic> data) {
    return GroupInfo(
      id: data['id'],
      name: data['name'],
      design: Design.fromData(data['design']),
      abbreviation:
          data['abbreviation'] ?? _getAbbreviationFromName(data['name'] ?? ""),
      sharecode: data['publicKey'],
      meetingID: data['meetingID'],
      joinLink: data['joinLink'],
      groupType: groupTypeFromString(data['groupType']),
    );
  }

  GroupKey get groupKey => GroupKey(id: id, groupType: groupType);
}

String _getAbbreviationFromName(String name) {
  if (name != null) {
    if (name.length > 2) {
      return name.substring(0, 2);
    } else {
      return name;
    }
  } else {
    return null;
  }
}
