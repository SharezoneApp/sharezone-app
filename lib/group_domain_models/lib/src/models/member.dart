// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/foundation.dart';
import 'package:sharezone_common/firebase_helper.dart';
import 'package:user/user.dart';

import 'member_role.dart';

@immutable
class MemberData {
  final UserId id;
  final String name, abbreviation;
  final MemberRole role;
  final TypeOfUser typeOfUser;
  final DateTime joinedOn;

  const MemberData({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.typeOfUser,
    required this.role,
    required this.joinedOn,
  });

  factory MemberData.create({
    required String id,
    required MemberRole role,
    required AppUser user,
  }) {
    return MemberData(
      id: UserId(id),
      name: user.name,
      abbreviation: generateAbbreviation(user.name),
      role: role,
      typeOfUser: user.typeOfUser,
      joinedOn: DateTime.now(),
    );
  }

  factory MemberData.fromData(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return MemberData(
      id: UserId(id),
      name: data['name'] ?? "",
      abbreviation: data['abbreviation'] ?? "",
      typeOfUser: TypeOfUser.values.byName(data['typeOfUser']),
      role: MemberRole.values.byName(data['role']),
      joinedOn: dateTimeFromTimestamp(data['joinedOn']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'abbreviation': abbreviation,
      'typeOfUser': typeOfUser.name,
      'role': role.name,
      'joinedOn': joinedOn,
    };
  }

  MemberData copyWith({
    String? name,
    abbreviation,
    DateTime? joinedOn,
    MemberData? role,
    TypeOfUser? typeOfUser,
  }) {
    return MemberData(
      id: id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      typeOfUser: typeOfUser ?? this.typeOfUser,
      role: role as MemberRole? ?? this.role,
      joinedOn: joinedOn ?? this.joinedOn,
    );
  }
}
