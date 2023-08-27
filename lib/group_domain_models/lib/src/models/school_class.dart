// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:design/design.dart';
import 'package:user/user.dart';

import 'course.dart';
import 'group_info.dart';
import 'group_type.dart';
import 'member_role.dart';

class SchoolClass {
  final String id;
  final String name;
  final String? sharecode, joinLink, meetingID;
  GroupId get groupId => GroupId(id);
  final MemberRole myRole;
  final CourseSettings settings;
  final String? personalSharecode, personalJoinLink;

  SchoolClass._({
    required this.id,
    required this.name,
    required this.myRole,
    required this.settings,
    required this.sharecode,
    required this.meetingID,
    required this.joinLink,
    required this.personalSharecode,
    required this.personalJoinLink,
  });

  factory SchoolClass.fromData(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return SchoolClass._(
      id: id,
      name: data['name'] ?? '',
      myRole: MemberRole.values.byName(data['myRole']),
      sharecode: data['publicKey'],
      joinLink: data['joinLink'],
      meetingID: data['meetingID'] ?? '',
      personalSharecode: data['personalPublicKey'],
      personalJoinLink: data['personalJoinLink'],
      settings: CourseSettings.fromData(data['settings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  SchoolClass copyWith({
    String? id,
    String? name,
    String? sharecode,
    String? meetingID,
    MemberRole? myRole,
    CourseSettings? settings,
    String? joinLink,
  }) {
    return SchoolClass._(
      id: id ?? this.id,
      name: name ?? this.name,
      sharecode: sharecode ?? this.sharecode,
      meetingID: meetingID ?? this.meetingID,
      joinLink: joinLink ?? this.joinLink,
      personalJoinLink: personalJoinLink,
      personalSharecode: personalSharecode,
      myRole: myRole ?? this.myRole,
      settings: settings ?? this.settings,
    );
  }

  Design getDesign() {
    return Design.standard();
  }

  String? getPublicKey() {
    return personalSharecode ?? sharecode;
  }

  String? getJoinLink() {
    return personalJoinLink ?? joinLink;
  }

  GroupInfo toGroupInfo() {
    return GroupInfo(
      id: id,
      name: name!,
      abbreviation: generateAbbreviation(name),
      design: getDesign(),
      meetingID: meetingID,
      sharecode: getPublicKey(),
      joinLink: getJoinLink(),
      groupType: GroupType.schoolclass,
      myRole: myRole,
    );
  }
}

class SchoolClassData {
  final String id;
  final String name;
  final String? description, abbreviation, meetingID;
  final String? sharecode, joinLink, referenceSchoolID;

  final CourseSettings settings;

  const SchoolClassData._({
    required this.id,
    required this.name,
    required this.description,
    required this.meetingID,
    required this.abbreviation,
    required this.sharecode,
    required this.joinLink,
    required this.referenceSchoolID,
    required this.settings,
  });

  factory SchoolClassData.create() {
    return const SchoolClassData._(
      id: '',
      name: "",
      description: "",
      abbreviation: "",
      sharecode: null,
      meetingID: null,
      joinLink: null,
      referenceSchoolID: null,
      settings: CourseSettings.standard,
    );
  }

  factory SchoolClassData.fromData(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return SchoolClassData._(
      id: id,
      name: data['name'],
      description: data['description'],
      abbreviation: data['abbreviation'],
      sharecode: data['publicKey'],
      meetingID: data['meetingID'],
      joinLink: data['joinLink'],
      referenceSchoolID: data['referenceSchoolID'],
      settings: CourseSettings.fromData(data['settings']),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'abbreviation': abbreviation,
      'publicKey': sharecode,
      'joinLink': joinLink,
      'settings': settings.toJson(),
    };
  }

  Map<String, dynamic> toEditJson() {
    return {
      'name': name,
      'description': description,
      'abbreviation': abbreviation,
      'settings': settings.toJson(),
    };
  }

  SchoolClassData copyWith({
    String? id,
    String? name,
    String? description,
    String? abbreviation,
    String? sharecode,
    String? joinLink,
    referenceSchoolID,
    CourseSettings? settings,
  }) {
    return SchoolClassData._(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      abbreviation: abbreviation ?? this.abbreviation,
      sharecode: sharecode ?? this.sharecode,
      joinLink: joinLink ?? this.joinLink,
      meetingID: meetingID ?? meetingID,
      referenceSchoolID: referenceSchoolID ?? this.referenceSchoolID,
      settings: settings ?? this.settings,
    );
  }
}
