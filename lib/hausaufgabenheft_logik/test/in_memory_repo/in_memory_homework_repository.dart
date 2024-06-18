// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'firebase_realtime_updating_lazy_loading_controller.dart';
import 'realtime_completed_homework_loader.dart';

class InMemoryHomeworkRepository<T extends BaseHomeworkReadModel> {
  IList<T> _homeworks = IList<T>(const []);
  IList<T> get _openHomeworks => _homeworks.where((h) {
        if (h is TeacherHomeworkReadModel) {
          return h.status == ArchivalStatus.open;
        } else {
          final hw = h as HomeworkReadModel;
          return hw.status == CompletionStatus.open;
        }
      }).toIList();
  IList<T> get _completedHomeworks => _homeworks.where((h) {
        if (h is TeacherHomeworkReadModel) {
          return h.status == ArchivalStatus.archived;
        } else {
          final hw = h as HomeworkReadModel;
          return hw.status == CompletionStatus.completed;
        }
      }).toIList();

  final _openHomeworkStream = BehaviorSubject<IList<T>>();
  final _completedHomeworkStream = BehaviorSubject<IList<T>>();
  final Duration fakeDelay;

  InMemoryHomeworkRepository({this.fakeDelay = Duration.zero}) {
    _openHomeworkStream.add(_homeworks);
  }

  Stream<IList<T>> get openHomeworks =>
      _openHomeworkStream.stream.delay(fakeDelay);

  final bool _loadedAllCompleted = false;
  bool get loadedAllCompleted => _loadedAllCompleted;

  Future<void> add(T homework) async {
    _homeworks = _homeworks.add(homework);
    addHomeworksToStreams();
  }

  Future<void> delete(T homework) async {
    _homeworks = _homeworks.removeWhere((h) => h.id == homework.id);
    addHomeworksToStreams();
  }

  Future<IList<T>> getAll() async {
    await Future.delayed(fakeDelay);
    return _homeworks;
  }

  Future<void> update(T homework) async {
    final index = _homeworks.indexWhere((h) => h.id == homework.id);
    _homeworks = _homeworks.replace(index, homework);
    addHomeworksToStreams();
  }

  Future<T> findById(HomeworkId id) {
    return Future.value(_homeworks.singleWhere((h) => h.id == id));
  }

  void addHomeworksToStreams() {
    _openHomeworkStream.add(_openHomeworks);
    _completedHomeworkStream.add(_completedHomeworks);
  }

  LazyLoadingController<T> getLazyLoadingCompletedHomeworksController(
      int nrOfInitialHomeworkToLoad) {
    return RealtimeUpdatingLazyLoadingController(
        InMemoryHomeworkLoader<T>(_completedHomeworkStream),
        initialNumberOfHomeworksToLoad: nrOfInitialHomeworkToLoad);
  }
}

class InMemoryHomeworkLoader<T extends BaseHomeworkReadModel>
    extends RealtimeCompletedHomeworkLoader<T> {
  final BehaviorSubject<IList<T>> _completedHomeworksSubject;

  InMemoryHomeworkLoader(this._completedHomeworksSubject);

  @override
  Stream<IList<T>> loadMostRecentHomeworks(int numberOfHomeworks) {
    return _completedHomeworksSubject.map((homeworks) {
      if (homeworks.length < numberOfHomeworks) return homeworks;
      return homeworks.sublist(0, numberOfHomeworks);
    });
  }
}
