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
import 'package:helper_functions/helper_functions.dart';
import 'package:sharezone/timetable/src/models/substitution_id.dart';

enum SubstitutionType {
  /// The lesson is canceled.
  cancelled,

  /// The lesson is moved to another room.
  placeChanged,

  /// Unknown substitution type.
  unknown,
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
    final type = SubstitutionType.values
        .tryByName(data['type'], defaultValue: SubstitutionType.unknown);
    final updatedBy = UserId.tryParse(data['updated']?['by']);
    final createdBy = UserId(data['created']['by'] as String);
    final isDeleted = data['deleted'] != null;
    return switch (type) {
      SubstitutionType.cancelled => SubstitutionCanceled(
          id: id,
          date: Date.parse(data['date'] as String),
          createdBy: createdBy,
          isDeleted: isDeleted,
          updatedBy: updatedBy,
        ),
      SubstitutionType.placeChanged => SubstitutionPlaceChange(
          id: id,
          date: Date.parse(data['date'] as String),
          createdBy: createdBy,
          newPlace: data['newPlace'] as String,
          isDeleted: isDeleted,
          updatedBy: updatedBy,
        ),
      SubstitutionType.unknown => SubstitutionUnknown(
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
      'type': type.name,
      'date': date.toDateString,
      'created': {
        'on': FieldValue.serverTimestamp(),
        'by': createdBy.value,
        'notifyGroupMembers': notifyGroupMembers,
      },
    };
  }
}

class SubstitutionCanceled extends Substitution {
  const SubstitutionCanceled({
    required super.id,
    required super.date,
    required super.createdBy,
    super.isDeleted,
    super.updatedBy,
  }) : super(type: SubstitutionType.cancelled);
}

class SubstitutionPlaceChange extends Substitution {
  final String newPlace;

  const SubstitutionPlaceChange({
    required super.id,
    required this.newPlace,
    required super.date,
    required super.createdBy,
    super.isDeleted,
    super.updatedBy,
  }) : super(type: SubstitutionType.placeChanged);

  @override
  Map<String, dynamic> toCreateJson({
    required bool notifyGroupMembers,
  }) {
    return {
      ...super.toCreateJson(notifyGroupMembers: notifyGroupMembers),
      'newPlace': newPlace,
    };
  }
}

class SubstitutionUnknown extends Substitution {
  const SubstitutionUnknown({
    required super.id,
    required super.date,
    required super.createdBy,
    super.isDeleted,
    super.updatedBy,
  }) : super(type: SubstitutionType.unknown);
}
