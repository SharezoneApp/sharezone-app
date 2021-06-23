import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'group_type.dart';

class GroupKey {
  final String id;
  final GroupType groupType;

  const GroupKey({@required this.id, @required this.groupType});

  @override
  operator ==(other) {
    return other is GroupKey && id == other.id && groupType == other.groupType;
  }

  int get hashCode {
    return hashList([id, groupType]);
  }
}
