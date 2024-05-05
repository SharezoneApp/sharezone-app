// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:sharezone/timetable/src/models/substitution_id.dart';

enum SubstitutionType {
  /// The lesson is canceled.
  lessonCanceled,

  /// The lesson is moved to another room.
  locationChanged,

  /// Unknown substitution type.
  unknown;

  String toDatabaseString() {
    return switch (this) {
      lessonCanceled => 'lessonCanceled',
      locationChanged => 'placeChanged',
      unknown => 'unknown',
    };
  }

  static SubstitutionType fromDatabaseString(String value) {
    return switch (value) {
      'lessonCanceled' => lessonCanceled,
      'placeChanged' => locationChanged,
      _ => unknown,
    };
  }
}

sealed class Substitution {
  final SubstitutionId id;
  final SubstitutionType type;

  /// The date of the substitution.
  final Date date;

  /// The user who created the substitution.
  final UserId createdBy;

  /// The user who updated the substitution.
  ///
  /// This field is only set if the substitution was updated.
  final UserId? updatedBy;

  /// Defines, if the substitution is deleted.
  ///
  /// We don't delete the substitution from the database. Instead, we set this
  /// flag to `true` to mark the substitution as deleted. This is required to
  /// send notifications to the group members when the substitution is deleted
  /// while supporting offline mode.
  final bool isDeleted;

  const Substitution({
    required this.id,
    required this.type,
    required this.date,
    required this.createdBy,
    this.isDeleted = false,
    this.updatedBy,
  });

  static Substitution fromData(
    Map<String, dynamic> data, {
    required SubstitutionId id,
  }) {
    final type = SubstitutionType.fromDatabaseString(data['type']);
    final updatedBy = UserId.tryParse(data['updated']?['by']);
    final createdBy = UserId(data['created']['by'] as String);
    final isDeleted = data['deleted'] != null;
    return switch (type) {
      SubstitutionType.lessonCanceled => LessonCanceledSubstitution(
          id: id,
          date: Date.parse(data['date'] as String),
          createdBy: createdBy,
          isDeleted: isDeleted,
          updatedBy: updatedBy,
        ),
      SubstitutionType.locationChanged => LocationChangedSubstitution(
          id: id,
          date: Date.parse(data['date'] as String),
          createdBy: createdBy,
          newLocation: data['newPlace'] as String,
          isDeleted: isDeleted,
          updatedBy: updatedBy,
        ),
      SubstitutionType.unknown => UnknownSubstitution(
          id: id,
          date: Date.parse(data['date'] as String),
          createdBy: createdBy,
          isDeleted: isDeleted,
          updatedBy: updatedBy,
        )
    };
  }

  Map<String, dynamic> toCreateJson({
    required bool notifyGroupMembers,
  }) {
    return {
      'type': type.toDatabaseString(),
      'date': date.toDateString,
      'created': {
        'on': FieldValue.serverTimestamp(),
        'by': createdBy.value,
        'notifyGroupMembers': notifyGroupMembers,
      },
    };
  }
}

class LessonCanceledSubstitution extends Substitution {
  const LessonCanceledSubstitution({
    required super.id,
    required super.date,
    required super.createdBy,
    super.isDeleted,
    super.updatedBy,
  }) : super(type: SubstitutionType.lessonCanceled);
}

class LocationChangedSubstitution extends Substitution {
  final String newLocation;

  const LocationChangedSubstitution({
    required super.id,
    required this.newLocation,
    required super.date,
    required super.createdBy,
    super.isDeleted,
    super.updatedBy,
  }) : super(type: SubstitutionType.locationChanged);

  @override
  Map<String, dynamic> toCreateJson({
    required bool notifyGroupMembers,
  }) {
    return {
      ...super.toCreateJson(notifyGroupMembers: notifyGroupMembers),
      // We use a database field `newPlace` because `place` is already used for
      // the original place of the lesson.
      'newPlace': newLocation,
    };
  }
}

class UnknownSubstitution extends Substitution {
  const UnknownSubstitution({
    required super.id,
    required super.date,
    required super.createdBy,
    super.isDeleted,
    super.updatedBy,
  }) : super(type: SubstitutionType.unknown);
}
