// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'dashboard_bloc.dart';

/// Bestimmt, welcher Index in [views] jetzt oder als nächstes stattfindet.
/// Hat man jetzt z.B. Deutsch als zweites Fach am Tag, wird der Index 1
/// zurückgegeben. Es wird also bei 0 angefangen zu zählen.
int getCurrentLessonIndex(List<LessonView> views) {
  // Prüfun, ob bisher noch keine Schulstunde stattgefunden hat (also ob die
  // Schule noch nicht angefangen hat)
  if (views.where((view) => view.timeStatus == LessonTimeStatus.isYetToCome).length ==
      views.length)
    return 0;
  else {
    // Prüfun, ob alle Schulstunden schon bisher stattgefunden haben (Schulschluss).
    if (views
            .where((view) => view.timeStatus == LessonTimeStatus.hasAlreadyTakenPlace)
            .length ==
        views.length) throw AllLessonsAreOver();

    // Jede Stunde prüfen, ob diese gerade stattfindet. Falls ja, wird der
    // Index der Schulstunde zurückgegeben, die als erstes die Bedingung erfüllt.
    for (int i = 0; i < views.length; i++) {
      if (views[i].timeStatus == LessonTimeStatus.isNow) return i;
    }

    // Herausfinden, ob der Nutzer gerade in einer Freistunde / Pause ist. Falls ja,
    // wird die nächste Stunde als aktueller Index zurückgegeben.
    if (views.length >= 2) {
      for (int i = 1; i < views.length; i++) {
        if (views[i - 1].timeStatus == LessonTimeStatus.hasAlreadyTakenPlace &&
            views[i].timeStatus == LessonTimeStatus.isYetToCome) return i;
      }
    }

    return 0;
  }
}

class AllLessonsAreOver implements Exception {}
