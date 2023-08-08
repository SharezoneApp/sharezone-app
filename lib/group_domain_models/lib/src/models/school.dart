// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'course.dart';
import 'member_role.dart';

class School {
  final String? id, name, publicKey, joinLink;
  final MemberRole? myRole;
  final CourseSettings settings;

  School._({
    required this.id,
    required this.name,
    required this.myRole,
    required this.publicKey,
    required this.settings,
    required this.joinLink,
  });

  factory School.fromData(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return School._(
      id: id,
      name: data['name'],
      myRole: MemberRole.values.byName(data['myRole']),
      publicKey: data['publicKey'],
      joinLink: data['joinLink'],
      settings: CourseSettings.fromData(data['settings']),
    );
  }
}

class SchoolData {
  final String id;
  final String? name, title, description, abbreviation;
  final String? publicKey, joinLink;
  final CourseSettings settings;

  const SchoolData._({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.abbreviation,
    required this.publicKey,
    required this.joinLink,
    required this.settings,
  });

  factory SchoolData.create() {
    return const SchoolData._(
      id: '',
      name: "",
      title: "",
      description: "",
      abbreviation: "",
      publicKey: null,
      joinLink: null,
      settings: CourseSettings.standard,
    );
  }

  factory SchoolData.fromData({
    data,
    required String id,
  }) {
    return SchoolData._(
      id: id,
      name: data['name'],
      title: data['subject'],
      description: data['description'],
      abbreviation: data['abbreviation'],
      publicKey: data['publicKey'],
      joinLink: data['joinLink'],
      settings: CourseSettings.fromData(data['settings']),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'subject': title,
      'description': description,
      'abbreviation': abbreviation,
      'publicKey': publicKey,
      'joinLink': joinLink,
      'settings': settings.toJson(),
    };
  }

  Map<String, dynamic> toEditJson() {
    return {
      'name': name,
      'title': title,
      'description': description,
      'abbreviation': abbreviation,
      'publicKey': publicKey,
      'joinLink': joinLink,
      'settings': settings.toJson(),
    };
  }

  SchoolData copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    String? abbreviation,
    String? publicKey,
    String? joinLink,
    CourseSettings? settings,
  }) {
    return SchoolData._(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      abbreviation: abbreviation ?? this.abbreviation,
      publicKey: publicKey ?? this.publicKey,
      joinLink: joinLink ?? this.joinLink,
      settings: settings ?? this.settings,
    );
  }
}
