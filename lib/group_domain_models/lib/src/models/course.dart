// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:design/design.dart';
import 'package:flutter/foundation.dart';
import 'package:sharezone_common/helper_functions.dart';

import 'group_info.dart';
import 'group_type.dart';
import 'member_role.dart';
import 'write_permissions.dart';

class Course {
  final String id;
  final String name, subject, abbreviation;
  final String? sharecode, joinLink, meetingID;
  final MemberRole myRole;
  final CourseSettings settings;
  final bool version2;
  final GroupId? groupId;
  final Design? design, personalDesign;
  final String? personalSharecode, personalJoinLink;

  const Course._({
    required this.id,
    required this.name,
    required this.settings,
    required this.sharecode,
    required this.joinLink,
    required this.subject,
    required this.abbreviation,
    required this.meetingID,
    required this.myRole,
    required this.design,
    required this.personalDesign,
    required this.personalSharecode,
    required this.personalJoinLink,
    required this.groupId,
    this.version2 = true,
  });

  factory Course.create() {
    return Course._(
      id: "",
      name: "",
      subject: "",
      sharecode: null,
      joinLink: null,
      personalSharecode: null,
      personalJoinLink: null,
      meetingID: null,
      abbreviation: "",
      groupId: null,
      myRole: MemberRole.standard,
      design: Design
          .standard(), // MIGHT WANT TO CHANGE IT TO RANDOM OR SO, TO GENERATE A RANDOM COLOR
      settings: CourseSettings.standard,
      personalDesign: null,
    );
  }

  factory Course.fromData(Map<String, dynamic> data, {required String id}) {
    return Course._(
      id: id,
      name: data['name'] ?? "",
      subject: data['subject'] ?? data['name'] ?? "",
      sharecode: data['publicKey'],
      personalSharecode: data['personalPublicKey'],
      joinLink: data['joinLink'],
      personalJoinLink: data['personalJoinLink'],
      meetingID: data['meetingID'],
      groupId: GroupId(id),
      abbreviation:
          data['abbreviation'] ?? _getAbbreviationFromName(data['name'] ?? ""),
      myRole: MemberRole.values.byName(data['myRole'] ?? 'standard'),
      settings: CourseSettings.fromData(data['settings']),
      design: Design.fromData(data['design']),
      personalDesign: data['personalDesign'] != null
          ? Design.fromData(data['personalDesign'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subject': subject,
      'abbreviation': abbreviation,
      'publicKey': sharecode,
      'joinLink': joinLink,
      'meetingID': meetingID,
      'myRole': myRole.name,
      'settings': settings.toJson(),
      'design': design?.toJson(),
    };
  }

  Map<String, dynamic> toEditJson() {
    return {
      'name': name,
      'subject': subject,
      'abbreviation': abbreviation,
      'design': design?.toJson(),
    };
  }

  Course copyWith({
    String? id,
    String? name,
    String? subject,
    String? abbreviation,
    String? sharecode,
    String? joinLink,
    String? meetingID,
    MemberRole? myRole,
    CourseSettings? settings,
    bool? version2,
    Design? design,
    personalDesign,
  }) {
    return Course._(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      abbreviation: abbreviation ?? this.abbreviation,
      sharecode: sharecode ?? this.sharecode,
      joinLink: joinLink ?? this.joinLink,
      personalSharecode: personalSharecode,
      meetingID: meetingID ?? this.meetingID,
      personalJoinLink: personalJoinLink,
      myRole: myRole ?? this.myRole,
      settings: settings ?? this.settings,
      version2: version2 ?? this.version2,
      design: design ?? this.design,
      personalDesign: personalDesign ?? this.personalDesign,
      groupId: id == null ? groupId : GroupId(id),
    );
  }

  Design getDesign() {
    return personalDesign ?? design ?? Design.standard();
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
      name: name,
      abbreviation: abbreviation,
      design: getDesign(),
      meetingID: meetingID,
      sharecode: getPublicKey(),
      joinLink: getJoinLink(),
      groupType: GroupType.course,
      myRole: myRole,
    );
  }
}

class CourseData {
  final String id;
  final String name, subject, abbreviation;
  final String? description;
  final String? sharecode, joinLink, referenceSchoolID, meetingID;
  final List<String?>? referenceSchoolClassIDs;
  final CourseSettings settings;
  final Design design;

  const CourseData._({
    required this.id,
    required this.name,
    required this.subject,
    required this.description,
    required this.abbreviation,
    required this.sharecode,
    required this.joinLink,
    required this.meetingID,
    required this.referenceSchoolID,
    required this.referenceSchoolClassIDs,
    required this.settings,
    required this.design,
  });

  factory CourseData.create() {
    return CourseData._(
      id: '',
      name: "",
      subject: "",
      description: "",
      abbreviation: "",
      sharecode: null,
      meetingID: null,
      joinLink: null,
      referenceSchoolID: null,
      referenceSchoolClassIDs: null,
      settings: CourseSettings.standard,
      design: Design.random(),
    );
  }

  factory CourseData.fromData({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return CourseData._(
      id: id,
      name: data['name'],
      subject: data['subject'],
      description: data['description'],
      abbreviation: data['abbreviation'],
      sharecode: data['publicKey'],
      meetingID: data['meetingID'],
      joinLink: data['joinLink'],
      referenceSchoolID: data['referenceSchoolID'],
      referenceSchoolClassIDs:
          decodeList(data['referenceSchoolClassIDs'], (it) => it),
      settings: CourseSettings.fromData(data['settings']),
      design: Design.random(),
    );
  }

  Map<String, dynamic> toCreateJson(String creatorID) {
    return {
      'name': name,
      'creatorID': creatorID,
      'subject': subject,
      'description': description,
      'abbreviation': abbreviation,
      'meetingID': meetingID,
      'settings': settings.toJson(),
      'referenceSchoolClassIDs': referenceSchoolClassIDs,
      'referenceSchoolID': referenceSchoolID,
      'design': design.toJson(),
    };
  }

  Map<String, dynamic> toEditJson() {
    return {
      'name': name,
      'subject': subject,
      'description': description,
      'abbreviation': abbreviation,
    };
  }

  Course toUserCourse(MemberRole myRole) {
    return Course._(
      subject: subject,
      id: id,
      name: name,
      myRole: myRole,
      abbreviation: abbreviation,
      settings: settings,
      sharecode: sharecode,
      design: design,
      meetingID: meetingID,
      groupId: GroupId(id),
      joinLink: joinLink,
      personalDesign: null,
      personalSharecode: null,
      personalJoinLink: null,
    );
  }

  CourseData copyWith({
    String? id,
    name,
    subject,
    description,
    abbreviation,
    String? publicKey,
    String? joinLink,
    referenceSchoolID,
    List<String>? referenceSchoolClassIDs,
    CourseSettings? settings,
  }) {
    return CourseData._(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      abbreviation: abbreviation ?? this.abbreviation,
      sharecode: publicKey ?? sharecode,
      meetingID: meetingID ?? meetingID,
      joinLink: joinLink ?? this.joinLink,
      referenceSchoolClassIDs:
          referenceSchoolClassIDs ?? this.referenceSchoolClassIDs,
      referenceSchoolID: referenceSchoolID ?? this.referenceSchoolID,
      settings: settings ?? this.settings,
      design: design,
    );
  }
}

@immutable
class CourseSettings {
  final bool isPublic;
  final bool isMeetingEnabled;
  final WritePermission writePermission;

  const CourseSettings._({
    required this.isPublic,
    required this.isMeetingEnabled,
    required this.writePermission,
  });

  static const CourseSettings standard = CourseSettings._(
    isPublic: true,
    isMeetingEnabled: true,
    writePermission: WritePermission.everyone,
  );

  factory CourseSettings.fromData(Map<String, dynamic>? data) {
    if (data == null) return standard;
    return CourseSettings._(
      isPublic: data['isPublic'] ?? true,
      isMeetingEnabled: data['isMeetingEnabled'] ?? true,
      writePermission:
          WritePermission.values.byName(data['writePermission'] ?? 'everyone'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPublic': isPublic,
      'isMeetingEnabled': isMeetingEnabled,
      'writePermission': writePermission.name,
    };
  }

  CourseSettings copyWith({
    bool? isPublic,
    bool? isMeetingEnabled,
    WritePermission? writePermission,
  }) {
    return CourseSettings._(
      isPublic: isPublic ?? this.isPublic,
      isMeetingEnabled: isMeetingEnabled ?? this.isMeetingEnabled,
      writePermission: writePermission ?? this.writePermission,
    );
  }
}

String _getAbbreviationFromName(String name) {
  if (name.length > 2) return name.substring(0, 2);
  return name;
}
