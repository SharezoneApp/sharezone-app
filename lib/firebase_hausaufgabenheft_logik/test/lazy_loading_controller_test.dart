// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:firebase_hausaufgabenheft_logik/src/realtime_updating_lazy_loading_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart' as rx;
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'in_memory_homework_loader.dart';

class ReportingInMemoryHomeworkLoader extends InMemoryHomeworkLoader {
  ReportingInMemoryHomeworkLoader(
      rx.BehaviorSubject<List<HomeworkReadModel>> completedHomeworksSubject)
      : super(completedHomeworksSubject);

  bool wasInvoked = false;
  @override
  Stream<List<HomeworkReadModel>> loadMostRecentHomeworks(
      int numberOfHomeworks) {
    wasInvoked = true;
    return super.loadMostRecentHomeworks(numberOfHomeworks);
  }
}

List<HomeworkReadModel> listOfHomeworksWithLength(int length) => List.generate(
      length,
      (index) => HomeworkReadModel(
          id: HomeworkId("$index"),
          todoDate: DateTime.now(),
          status: CompletionStatus.completed,
          subject: Subject("Mathe"),
          title: const Title("ABC"),
          withSubmissions: false),
    );

Stream<List<HomeworkReadModel>> getHomeworkResultsAsStream(
        Stream<LazyLoadingResult> resultStream) =>
    resultStream.map((res) => res.homeworks);

void main() {
  group('LazyLoadingController', () {
    late ReportingInMemoryHomeworkLoader homeworkLoader;
    late rx.BehaviorSubject<List<HomeworkReadModel>> homeworkSubject;

    void addToDataSource(List<HomeworkReadModel> homeworks) {
      final hws = homeworkSubject.valueOrNull;
      if (hws != null) {
        hws.addAll(homeworks);
        homeworkSubject.add(hws);
      } else {
        homeworkSubject.add(homeworks);
      }
    }

    setUp(() {
      homeworkSubject = rx.BehaviorSubject<List<HomeworkReadModel>>();
      homeworkLoader = ReportingInMemoryHomeworkLoader(homeworkSubject);
    });

    tearDown(() {
      homeworkSubject.close();
    });

    test(
        'the controller does not call the data source if the nr of initial homeworks to load is 0',
        () {
      RealtimeUpdatingLazyLoadingController(homeworkLoader,
          initialNumberOfHomeworksToLoad: 0);
      expect(homeworkLoader.wasInvoked, false);
    });

    test(
        'the controller calls the data source if initialNumberOfHomeworksToLoad is bigger than 0',
        () {
      RealtimeUpdatingLazyLoadingController(homeworkLoader,
          initialNumberOfHomeworksToLoad: 3);
      expect(homeworkLoader.wasInvoked, true);
    });

    test(
        'throws an ArgumentError if the initial number of homeworks to load is less than 0',
        () {
      void create() => RealtimeUpdatingLazyLoadingController(homeworkLoader,
          initialNumberOfHomeworksToLoad: -2);
      expect(create, throwsArgumentError);
    });
    test(
        'loads the first 2 homeworks from the data source if initialNumberOfHomeworksToLoad is 2',
        () async {
      var homeworks = listOfHomeworksWithLength(3);
      addToDataSource(homeworks);

      final controller = RealtimeUpdatingLazyLoadingController(homeworkLoader,
          initialNumberOfHomeworksToLoad: 2);

      final homeworkStream = getHomeworkResultsAsStream(controller.results);
      expect(homeworkStream, emits(homeworks.sublist(0, 2)));
    });

    test(
        'gives back 4 homeworks if initial number of homeworks to load is 2 and the homeworks get advanced by 2',
        () async {
      final homeworks = listOfHomeworksWithLength(7);
      addToDataSource(homeworks);

      final controller = RealtimeUpdatingLazyLoadingController(homeworkLoader,
          initialNumberOfHomeworksToLoad: 2);
      controller.advanceBy(2);

      final homeworkStream = getHomeworkResultsAsStream(controller.results);
      expect(homeworkStream, emitsThrough(homeworks.sublist(0, 4)));
    });

    test(
        'returns empty homework list if initial homeworks to load is 0 and indicates that more homeworks are available',
        () {
      final controller = RealtimeUpdatingLazyLoadingController(homeworkLoader,
          initialNumberOfHomeworksToLoad: 0);

      expect(controller.results, emits(LazyLoadingResult.empty()));
    });

    test('indicates that more homeworks are available when this is the case',
        () {
      addToDataSource(listOfHomeworksWithLength(5));
      final controller = RealtimeUpdatingLazyLoadingController(homeworkLoader,
          initialNumberOfHomeworksToLoad: 2);

      final moreAvailableStream =
          controller.results.map((res) => res.moreHomeworkAvailable);
      expect(moreAvailableStream, emits(true));
    });

    test(
        'indicates that no more homeworks are available when all are requested',
        () async {
      addToDataSource(listOfHomeworksWithLength(10));
      final controller = RealtimeUpdatingLazyLoadingController(homeworkLoader,
          initialNumberOfHomeworksToLoad: 5);
      var results = controller.results.asBroadcastStream();

      // Delay so that the first request (inital number of homeworks) gets
      // executed before the stream subscription in the lazy loading controller
      // for the first request gets cancelled because of the advanceBy call.
      final first = await results.first;
      controller.advanceBy(12);
      final second = await results.first;

      expect(first.moreHomeworkAvailable, true);
      expect(second.moreHomeworkAvailable, false);
    });
  });
}
