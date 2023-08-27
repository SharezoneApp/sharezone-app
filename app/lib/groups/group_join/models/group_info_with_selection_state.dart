// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:design/design.dart';
import 'package:group_domain_models/group_domain_models.dart';

class GroupInfoWithSelectionState {
  final String id;
  final GroupType groupType;
  final String name;
  final Design design;
  final String abbreviation;
  final bool isSelected;

  const GroupInfoWithSelectionState({
    required this.id,
    required this.groupType,
    required this.name,
    required this.abbreviation,
    required this.design,
    required this.isSelected,
  });

  factory GroupInfoWithSelectionState.fromData(Map<String, dynamic> data) {
    return GroupInfoWithSelectionState(
      id: data['id'] as String,
      groupType: GroupType.values.byName(data['groupType'] as String),
      name: data['name'] as String,
      abbreviation: data['abbreviation'] as String,
      design: Design.fromData(data['design']),
      isSelected: data['isPreSelected'] as bool,
    );
  }

  GroupKey get groupKey => GroupKey(id: id, groupType: groupType);

  GroupInfoWithSelectionState copyWithSelectionState(bool newSelectionState) {
    return GroupInfoWithSelectionState(
      id: id,
      groupType: groupType,
      name: name,
      abbreviation: abbreviation,
      design: design,
      isSelected: newSelectionState,
    );
  }
}
