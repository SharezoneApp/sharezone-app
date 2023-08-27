// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:sharezone/timetable/src/models/timetable_element_properties.dart';
import 'package:sharezone/timetable/src/models/timetable_element_time_properties.dart';
import 'package:time/time.dart';

bool _areTimesConflicting(
  Time firstStart,
  Time firstEnd,
  Time secondStart,
  Time secondEnd,
) {
  if (secondStart.isAfter(firstEnd)) return false;
  if (secondStart == firstEnd) return false;
  if (secondEnd.isBefore(firstStart)) return false;
  if (secondEnd == firstStart) return false;
  return true;
}

Set<String> _getAllDeepConflicts(
  Set<String> restValues,
  Map<String, TimetableElementTimeProperties> elementTimeValues,
  String elementID,
) {
  restValues.remove(elementID);
  final element = elementTimeValues[elementID]!;
  final Set<String> results = {};
  final conflictsWith = restValues.where((otherElementID) {
    final otherLesson = elementTimeValues[otherElementID]!;
    return _areTimesConflicting(
      element.start,
      element.end,
      otherLesson.start,
      otherLesson.end,
    );
  }).toList();
  results.addAll(conflictsWith);
  restValues.removeAll(conflictsWith);
  for (final value in conflictsWith) {
    results.addAll(_getAllDeepConflicts(restValues, elementTimeValues, value));
  }
  return results;
}

class TimetablePositionLogic {
  final Map<String, TimetableElementTimeProperties> elementTimeProperties;

  const TimetablePositionLogic(this.elementTimeProperties);

  Map<String, TimetableElementProperties> get elementProperties {
    final restValues = elementTimeProperties.keys.toSet();
    final Map<String, TimetableElementProperties> newMap = {};
    while (restValues.isNotEmpty) {
      final lessonID = restValues.first;
      final deepConflicts =
          _getAllDeepConflicts(restValues, elementTimeProperties, lessonID);

      final propertiesBuilder = TimetablePositionBuilder(
        [
          ...deepConflicts,
          lessonID,
        ],
        elementTimeProperties,
      );
      newMap.addAll(propertiesBuilder.propertiesForConflictingElements);
    }

    return Map.fromEntries(elementTimeProperties.values.map((timeElement) {
      final properties =
          newMap[timeElement.id] ?? TimetableElementProperties.standard;
      return MapEntry(
        timeElement.id,
        properties,
      );
    }));
  }
}

class TimetablePositionBuilder {
  final List<String> conflictingElements;
  final Map<String, TimetableElementTimeProperties> elementTimeValues;

  const TimetablePositionBuilder(
      this.conflictingElements, this.elementTimeValues);

  Map<String, TimetableElementProperties> get propertiesForConflictingElements {
    if (conflictingElements.length <= 1) {
      return {};
    } else {
      return optionB() ?? optionA();
    }
  }

  // EVERY ELEMENT GETS ONE POSITION NEXT TO EACH OTHER => INEFFICENT
  Map<String, TimetableElementProperties> optionA() {
    final Map<String, TimetableElementProperties> newMap = {};
    final totalConflictElements = conflictingElements.length;
    for (final conflictID in conflictingElements) {
      int index = conflictingElements.indexOf(conflictID);
      newMap[conflictID] =
          TimetableElementProperties(totalConflictElements, index);
    }
    return newMap;
  }

  Map<String, TimetableElementProperties>? optionB() {
    final List<String> sortedTimes = conflictingElements.toList();
    sortedTimes.sort((e1, e2) {
      final timeData1 = elementTimeValues[e1]!;
      final timeData2 = elementTimeValues[e2]!;
      final compare1 = timeData1.start.compareTo(timeData2.start);
      if (compare1 != 0)
        return compare1;
      else
        return timeData2.end.compareTo(timeData1.end);
    });
    final Map<String, TimetableElementProperties> newMap = {};
    final elementID = sortedTimes.first;
    sortedTimes.removeAt(0);
    final timeProperties = elementTimeValues[elementID];
    final directConflicts = _getDirectConflicts(timeProperties!, sortedTimes);

    // THIS METHOD CANT YET HANDLE INDIRECT CONFLICTS => TO COMPLEX
    if ((directConflicts.length + 1) < conflictingElements.length) return null;

    newMap[elementID] = TimetableElementProperties(2, 0);
    for (final String otherElementID in directConflicts) {
      final otherElementTime = elementTimeValues[otherElementID];
      // THIS METHOD ONLY HANDLES TWO ENTRIES NEXT TO EACH OTHER...
      if (directConflicts.where((it) {
        if (it == otherElementID) return false;

        final itTime = elementTimeValues[it];
        return _areTimesConflicting(
          otherElementTime!.start,
          otherElementTime.end,
          itTime!.start,
          itTime.end,
        );
      }).isNotEmpty) return null;
      newMap[otherElementID] = TimetableElementProperties(2, 1);
    }
    return newMap;
  }

  Set<String> _getDirectConflicts(
      TimetableElementTimeProperties time, List<String> restValues) {
    return restValues.where((it) {
      final itTime = elementTimeValues[it]!;
      return _areTimesConflicting(
          time.start, time.end, itTime.start, itTime.end);
    }).toSet();
  }
}
