// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:collection/collection.dart';
import 'package:date/date.dart';
import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length.dart';
import 'package:sharezone/timetable/src/models/substitution_id.dart';
import 'package:time/time.dart';

class Lesson {
  /// The date and time when the event was created.
  ///
  /// Clients with a lower version than 1.7.9 will not have this field.
  /// Therefore, we will always have events without a [createdOn] field in the
  /// database.
  final DateTime? createdOn;

  final String? lessonID;
  final String groupID;
  final GroupType groupType;
  final Date? startDate, endDate;
  final Time startTime, endTime;
  final int? periodNumber;
  final WeekDay weekday;
  final WeekType weektype;
  final String? teacher, place;
  final Map<SubstitutionId, Substitution> substitutions;
  LessonLength get length => calculateLessonLength(startTime, endTime);

  /// Defines, if the lesson is dropped.
  ///
  /// Will be injected by the [TimetableBuilder] when the lesson is dropped.
  final bool isDropped;

  /// The new place of the lesson.
  ///
  /// Will be injected by the [TimetableBuilder] when the lesson is moved to
  /// another place.
  final String? newPlace;

  Lesson({
    required this.createdOn,
    required this.lessonID,
    required this.groupID,
    required this.groupType,
    this.startDate,
    this.endDate,
    this.periodNumber,
    this.isDropped = false,
    this.newPlace,
    required this.startTime,
    required this.endTime,
    required this.weekday,
    required this.weektype,
    required this.teacher,
    required this.place,
    this.substitutions = const {},
  });

  factory Lesson.fromData(Map<String, dynamic> data, {required String id}) {
    return Lesson(
      createdOn: dateTimeFromTimestampOrNull(data['createdOn']),
      lessonID: id,
      groupID: data['groupID'] as String,
      groupType: GroupType.values.byName(data['groupType'] as String),
      startDate: Date.parseOrNull(data['startDate'] as String?),
      endDate: Date.parseOrNull(data['endDate'] as String?),
      startTime: Time.parse(data['startTime'] as String),
      endTime: Time.parse(data['endTime'] as String),
      periodNumber: data['periodNumber'] as int?,
      weekday: WeekDay.values.byName(data['weekday'] as String),
      weektype: WeekType.values.byName(data['weektype'] as String),
      teacher: data['teacher'] as String?,
      place: data['place'] as String?,
      substitutions: data['substitutions'] == null
          ? const {}
          : decodeMapAdvanced(
              data['substitutions'],
              (key, value) {
                final id = SubstitutionId(key);
                return MapEntry(id, Substitution.fromData(value, id: id));
              },
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'groupType': groupType.name,
      'startDate': startDate?.toDateString,
      'endDate': endDate?.toDateString,
      'startTime': startTime.time,
      'endTime': endTime.time,
      'periodNumber': periodNumber,
      'weekday': weekday.name,
      'weektype': weektype.name,
      'teacher': teacher,
      'place': place,
    };
  }

  Lesson copyWith({
    DateTime? createdOn,
    String? lessonID,
    String? groupID,
    GroupType? groupType,
    Date? startDate,
    Date? endDate,
    Time? startTime,
    Time? endTime,
    int? periodNumber,
    WeekDay? weekday,
    WeekType? weektype,
    String? teacher,
    String? place,
    bool? isDropped,
    String? newPlace,
    Map<SubstitutionId, Substitution>? substitutions,
  }) {
    return Lesson(
      createdOn: createdOn ?? this.createdOn,
      groupType: groupType ?? this.groupType,
      lessonID: lessonID ?? this.lessonID,
      groupID: groupID ?? this.groupID,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      periodNumber: periodNumber ?? this.periodNumber,
      weekday: weekday ?? this.weekday,
      weektype: weektype ?? this.weektype,
      teacher: teacher ?? this.teacher,
      place: place ?? this.place,
      isDropped: isDropped ?? this.isDropped,
      newPlace: newPlace ?? this.newPlace,
      substitutions: substitutions ?? this.substitutions,
    );
  }

  /// Returns the substitution for the given [date].
  ///
  /// If there is no substitution for the given [date], `null` will be returned.
  Substitution? getSubstitutionFor(Date date) {
    return substitutions.values
        .firstWhereOrNull((substitution) => substitution.date == date);
  }

  @override
  String toString() {
    return "Lesson: id:$lessonID, groupId: $groupID";
  }
}

LessonLength calculateLessonLength(Time start, Time end) {
  final startTimeDate = _parseTimeString(start.time);
  final endTimeDate = _parseTimeString(end.time);

  final lengthInMinutes = endTimeDate.difference(startTimeDate).inMinutes;
  return LessonLength(lengthInMinutes);
}

DateTime _parseTimeString(String time) {
  return DateTime(
      2019, 1, 1, int.parse(time.split(":")[0]), int.parse(time.split(":")[1]));
}

enum SubstitutionType {
  /// The lesson is canceled.
  canceled,

  /// The lesson is moved to another room.
  placeChange,

  /// Unknown substitution type.
  unknown,
}

sealed class Substitution {
  final SubstitutionId id;
  final SubstitutionType type;

  /// The date of the substitution.
  final Date date;

  /// Defines, if the group members should be notified when the substitution is
  /// created.
  final bool notifyGroupMembers;

  const Substitution({
    required this.id,
    required this.type,
    required this.date,
    required this.notifyGroupMembers,
  });

  static Substitution fromData(
    Map<String, dynamic> data, {
    required SubstitutionId id,
  }) {
    final type = SubstitutionType.values
        .tryByName(data['type'], defaultValue: SubstitutionType.unknown);
    return switch (type) {
      SubstitutionType.canceled => SubstitutionCanceled(
          id: id,
          date: Date.parse(data['date'] as String),
          notifyGroupMembers: data['notifyGroupMembers'] as bool,
        ),
      SubstitutionType.placeChange => SubstitutionPlaceChange(
          id: id,
          date: Date.parse(data['date'] as String),
          notifyGroupMembers: data['notifyGroupMembers'] as bool,
          newPlace: data['newPlace'] as String,
        ),
      SubstitutionType.unknown => SubstitutionUnknown(
          id: id,
          date: Date.parse(data['date'] as String),
          notifyGroupMembers: data['notifyGroupMembers'] as bool,
        )
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'type': type.name,
      'date': date.toDateString,
      'notifyGroupMembers': notifyGroupMembers,
      'createdOn': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'type': type.name,
      'date': date.toDateString,
      'notifyGroupMembers': notifyGroupMembers,
      'updatedOn': FieldValue.serverTimestamp(),
    };
  }
}

class SubstitutionCanceled extends Substitution {
  const SubstitutionCanceled({
    required super.id,
    required super.date,
    required super.notifyGroupMembers,
  }) : super(type: SubstitutionType.canceled);
}

class SubstitutionPlaceChange extends Substitution {
  final String newPlace;

  const SubstitutionPlaceChange({
    required super.id,
    required this.newPlace,
    required super.date,
    required super.notifyGroupMembers,
  }) : super(type: SubstitutionType.placeChange);

  @override
  Map<String, dynamic> toCreateJson() {
    return {
      ...super.toCreateJson(),
      'newPlace': newPlace,
    };
  }

  @override
  Map<String, dynamic> toUpdateJson() {
    return {
      ...super.toCreateJson(),
      'newPlace': newPlace,
    };
  }
}

class SubstitutionUnknown extends Substitution {
  const SubstitutionUnknown({
    required super.id,
    required super.date,
    required super.notifyGroupMembers,
  }) : super(type: SubstitutionType.unknown);
}
