// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_setup.dart';
import 'package:hausaufgabenheft_logik/src/completed_homeworks/completed_homeworks_view_bloc/completed_homeworks_view_bloc.dart'
    as completed;
import 'package:hausaufgabenheft_logik/src/completed_homeworks/lazy_loading_completed_homeworks_bloc/lazy_loading_completed_homeworks_bloc.dart'
    as lazy_loading;
import 'package:hausaufgabenheft_logik/src/completed_homeworks/views/completed_homework_list_view_factory.dart';
import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';
import 'package:hausaufgabenheft_logik/src/student_homework_page_bloc/homework_sorting_cache.dart';
import 'package:hausaufgabenheft_logik/src/views/color.dart';
import 'package:hausaufgabenheft_logik/src/views/student_homework_view_factory.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'create_homework_util.dart';
import 'in_memory_repo/in_memory_homework_repository.dart';

void main() {
  Bloc.observer = VerboseBlocObserver();
  group('GIVEN a Student with Homework WHEN he opens the homework page', () {
    late HomeworkPageBloc bloc;
    late InMemoryHomeworkRepository repository;
    late HomeworkSortingCache homeworkSortingCache;
    late KeyValueStore kvs;

    setUp(() {
      repository = createRepositoy();
      kvs = InMemoryKeyValueStore();
      bloc = createBloc(repository, keyValueStore: kvs);
      homeworkSortingCache = HomeworkSortingCache(kvs);
    });

    /// Adds the homeworks to the top level group repository, or if repo is
    /// specified into the given repository (for use in a sub-group, where
    /// the top level repository is not used)
    Future addToRepository(List<HomeworkReadModel> homeworks,
        [InMemoryHomeworkRepository? repo]) async {
      for (var homework in homeworks) {
        await (repo ?? repository).add(homework);
      }
    }

    test(
        // https://github.com/SharezoneApp/sharezone-app/issues/53
        // https://github.com/SharezoneApp/sharezone-app/pull/1134
        'Regressions test: Shows "Morgen" as section title if today is end of month (e.g. 31.10) and tomorrow is first of next month (e.g. 01.11)',
        () async {
      bloc = createBloc(repository,
          keyValueStore: kvs, getCurrentDateTime: () => DateTime(2023, 10, 31));
      await addToRepository([
        createHomework(
            id: 'hw', todoDate: const Date(year: 2023, month: 11, day: 1))
      ]);

      bloc.add(LoadHomeworks());

      Success success = await bloc.stream.whereType<Success>().first;
      expect(success.open.sections.first.title, 'Morgen');
    });

    test(
        'Regressions Test für #954 "Wenn man Hausaufgaben nach Fach sortiert und dann eine Aufgabe abhakt wechselt die App automatisch wieder in die Ansicht nach Datum."',
        () async {
      await addToRepository([createHomework(id: 'hw')]);

      bloc.add(LoadHomeworks());
      bloc.add(
          OpenHwSortingChanged(HomeworkSort.subjectSmallestDateAndTitleSort));
      await pumpEventQueue();
      bloc.add(CompletionStatusChanged('hw', true));

      Success success = await bloc.stream.whereType<Success>().first;

      expect(
          success.open.sorting, HomeworkSort.subjectSmallestDateAndTitleSort);
    });

    test(
        'THEN the homeworks should be sorted after the last chosen Sorting from the cache',
        () async {
      await addToRepository([createHomework(title: 'Hallo')]);
      await homeworkSortingCache
          .setLastSorting(HomeworkSort.subjectSmallestDateAndTitleSort);

      bloc.add(LoadHomeworks());
      Success success = await bloc.stream.whereType<Success>().first;

      expect(
          success.open.sorting, HomeworkSort.subjectSmallestDateAndTitleSort);
    });

    test(
        'THEN the homework should sorted via smallestDateSubjectAndTitle when having no Sort cached',
        () async {
      await addToRepository([createHomework(title: 'Hallo')]);
      bloc.add(LoadHomeworks());
      Success success = await bloc.stream.whereType<Success>().first;

      expect(success.open.sorting, HomeworkSort.smallestDateSubjectAndTitle);
    });

    test('THEN the current sorting should be cached', () async {
      await addToRepository([createHomework(title: 'Hallo')]);

      bloc.add(LoadHomeworks());
      bloc.add(
          OpenHwSortingChanged(HomeworkSort.subjectSmallestDateAndTitleSort));
      await bloc.stream.whereType<Success>().first;

      expect(await homeworkSortingCache.getLastSorting(),
          HomeworkSort.subjectSmallestDateAndTitleSort);
    });

    test(
        'THEN he should see all open homework sorted firstly by date then subject then title',
        () async {
      var h1 = createHomework(
          todoDate: const Date(year: 2019, month: 2, day: 10),
          subject: 'Biologie',
          title: 'Analyse',
          id: '1');
      var h2 = createHomework(
          todoDate: const Date(year: 2019, month: 2, day: 12),
          subject: 'Biologie',
          title: 'Buchstaben lernen',
          id: '2');
      var h3 = createHomework(
          todoDate: const Date(year: 2019, month: 2, day: 12),
          subject: 'Computerkurs',
          title: 'Neuland erkunden',
          id: '3');
      var h4 = createHomework(
          todoDate: const Date(year: 2020, month: 4, day: 20),
          subject: 'Afrikanisch',
          title: 'Analyse',
          id: '4');
      final homeworks = [h1, h2, h3, h4];
      await addToRepository(homeworks);

      bloc.add(LoadHomeworks());
      bloc.add(OpenHwSortingChanged(HomeworkSort.smallestDateSubjectAndTitle));

      final Future<HomeworkPageState> findState =
          bloc.stream.firstWhere((state) {
        if (state is Success) {
          final hws = state.open.orderedHomeworks;

          return hws.length == 4 &&
              hws[0].id == '1' &&
              hws[1].id == '2' &&
              hws[2].id == '3' &&
              hws[3].id == '4';
        }
        return false;
      });

      expect(findState, completes);
    });

    test(
        'THEN he should see all open homework subcategorized by passed, today, tomorrow, in 2 days and in further future',
        () async {
      final now = DateTime(2019, 01, 2);
      bloc = createBloc(repository, getCurrentDateTime: () => now);

      final old = createHomework(title: '1', todoDate: dateFromDay(1));
      final old2 = createHomework(title: '2', todoDate: dateFromDay(1));
      final today = createHomework(title: '3', todoDate: dateFromDay(2));
      final tomorrow = createHomework(title: '4', todoDate: dateFromDay(3));
      final in2Days = createHomework(title: '5', todoDate: dateFromDay(4));
      final future = createHomework(title: '6', todoDate: dateFromDay(5));
      final future2 = createHomework(title: '7', todoDate: dateFromDay(6));

      final homeworks = [old, old2, today, tomorrow, in2Days, future, future2];

      await addToRepository(homeworks);

      bloc.add(LoadHomeworks());
      bloc.add(OpenHwSortingChanged(HomeworkSort.smallestDateSubjectAndTitle));

      Success result = await bloc.stream.whereType<Success>().skip(1).first;

      final notDone = result.open;
      expect(notDone.sections.length, 5);

      final firstSection = notDone.sections[0];
      expect(firstSection.homeworks[0].title, '1');
      expect(firstSection.homeworks[1].title, '2');

      final secondSection = notDone.sections[1];
      expect(secondSection.homeworks[0].title, '3');

      final thirdSection = notDone.sections[2];
      expect(thirdSection.homeworks[0].title, '4');

      final fourthSection = notDone.sections[3];
      expect(fourthSection.homeworks[0].title, '5');

      final fithSection = notDone.sections[4];
      expect(fithSection.homeworks[0].title, '6');
      expect(fithSection.homeworks[1].title, '7');
    });

    test(
        'AND chooses to sort them by subject THEN the homeworks should be sorted by subject, (then) smallest date and title',
        () async {
      final h1 = createHomework(
        done: false,
        id: '1',
        subject: 'Englisch',
        title: 'Copy over vocabulary',
        todoDate: dateFromDay(2), // Is before h2 & h3 because of date
      );
      final h2 = createHomework(
        done: false,
        id: '2',
        subject: 'Englisch',
        title: 'A group project', // Is before h3 because of the title
        todoDate: dateFromDay(3),
      );
      final h3 = createHomework(
        done: false,
        id: '3',
        subject: 'Englisch',
        title: 'Buy utensils',
        todoDate: dateFromDay(3),
      );
      final h4 = createHomework(
        done: false,
        id: '4',
        subject: 'Mathematik', // Is the last because of the subject name
        title: 'S. 23, 4b',
        todoDate: dateFromDay(1),
      );
      final unsorted = [h2, h4, h1, h3];

      await addToRepository(unsorted);
      bloc.add(LoadHomeworks());

      bloc.add(
          OpenHwSortingChanged(HomeworkSort.subjectSmallestDateAndTitleSort));

      final Future<HomeworkPageState> findMatchingState =
          bloc.stream.firstWhere((state) {
        if (state is Success) {
          final sortedOpenHWs = state.open;
          if (sortedOpenHWs.numberOfHomeworks == unsorted.length) {
            final orderedIds =
                sortedOpenHWs.orderedHomeworks.map((hw) => hw.id).toList();
            return equals(orderedIds).matches(['1', '2', '3', '4'], {});
          }
        }
        return false;
      });

      expect(findMatchingState, completes);
    });

    test(
        'AND marks a homework as done THEN the homework should disapper from the open homework list and go to the done homework list',
        () async {
      var homework =
          createHomework(id: 'homeworkId', done: false, title: 'title');

      await addToRepository([homework]);
      bloc.add(LoadHomeworks());

      final Success uncompleted = await bloc.stream.whereType<Success>().first;
      expect(uncompleted.open.numberOfHomeworks, 1);
      expect(uncompleted.completed.numberOfHomeworks, 0);

      bloc.add(CompletionStatusChanged('homeworkId', true));

      final Success completed = await bloc.stream
          .whereType<Success>()
          .firstWhere((state) =>
              state.open.numberOfHomeworks == 0 &&
              state.completed.numberOfHomeworks == 1);

      expect(completed.open.numberOfHomeworks, 0);
      expect(completed.completed.numberOfHomeworks, 1);
    });

    test('date subcategory titles are only shown when necessary', () async {
      final tomorrow =
          createHomework(title: 'abc', todoDate: Date.now().addDays(1));
      await addToRepository([tomorrow]);
      bloc.add(LoadHomeworks());

      final Success latest = await bloc.stream.whereType<Success>().first;
      expect(latest.open.sections.length, 1);
    });

    test(
      'AND chooses to mark all overdue homework as done THEN all homework whose todo date lies before today should be marked as resolved',
      () async {
        final openHomeworks = List.generate(
            2,
            (_) => createHomework(
                title: 'überfällig',
                todoDate: const Date(day: 20, month: 02, year: 2018),
                done: false),
            growable: true)
          ..add(createHomework(
            title: 'zukunft',
            done: false,
            todoDate: const Date(year: 2121, month: 12, day: 21),
          ));

        await addToRepository(openHomeworks);
        bloc.add(LoadHomeworks());
        await bloc.stream.firstWhere((state) => state is Success);
        bloc.add(CompletedAllOverdue());
        final Success res = await bloc.stream.whereType<Success>().firstWhere(
            (state) =>
                state.completed.orderedHomeworks.length == 2 &&
                state.open.orderedHomeworks.length == 1);

        expect(res.open.orderedHomeworks.single.title, 'zukunft');
      },
    );

    test(
        'should show dialog to check all completed homework when more than 2 open overdue homeworks',
        () async {
      final yesterday =
          Date.fromDateTime(clock.now().subtract(const Duration(days: 1)));
      final homeworks = List.generate(
          3, (_) => createHomework(done: false, todoDate: yesterday));

      await addToRepository(homeworks);
      bloc.add(LoadHomeworks());

      final Success res = await bloc.stream.whereType<Success>().first;
      expect(res.open.showCompleteOverdueHomeworkPrompt, true);
    });
    test(
        'does not show dialog to check all completed homework with less than 3 overdue homeworks',
        () async {
      final yesterday =
          Date.fromDateTime(clock.now().subtract(const Duration(days: 1)));
      final tomorrow =
          Date.fromDateTime(clock.now().add(const Duration(days: 1)));

      final homeworks = [
        ...List.generate(
            2, (_) => createHomework(done: false, todoDate: yesterday),
            growable: false),
        createHomework(done: false, todoDate: tomorrow),
      ];

      await addToRepository(homeworks);
      bloc.add(LoadHomeworks());

      final Stream<HomeworkPageState> invalidStates = bloc.stream.where(
          (state) =>
              state is Success &&
              state.open.showCompleteOverdueHomeworkPrompt == true);

      expect(invalidStates, neverEmits(anything));
      await pumpEventQueue();
      await bloc.close();
    });

    group('CompletedHomeworks lazy loading ', () {
      HomeworkPageBloc bloc;
      late InMemoryHomeworkRepository repository;

      setUp(() {
        repository = createRepositoy();
        bloc = createBloc(repository);
      });

      List<HomeworkReadModel> generateCompleted(int nrOfCompletedHomeworks,
          {String Function(int index)? getTitle}) {
        String title(int i) => getTitle != null ? getTitle(i) : '$i';

        return List.generate(nrOfCompletedHomeworks,
            (i) => createHomework(id: '$i', done: true, title: title(i)));
      }

      test(
          'The bloc should give the appropiate status that not all completed homeworks were loaded yet if that is the case',
          () async {
        bloc = createBloc(repository, nrOfInitialCompletedHomeworksToLoad: 8);
        final completedHomeworks = generateCompleted(20);
        await addToRepository(completedHomeworks, repository);

        bloc.add(LoadHomeworks());
        final Success state = await bloc.stream.whereType<Success>().first;

        expect(state.completed.loadedAllCompletedHomeworks, false);
      });
      test(
        'all completed loaded is true when nrOfInitialCompletedHomeworksToLoad is the bigger as the given homeworks by the repository',
        () async {
          bloc = createBloc(repository, nrOfInitialCompletedHomeworksToLoad: 7);
          final completedHomeworks = generateCompleted(6);
          await addToRepository(completedHomeworks, repository);

          bloc.add(LoadHomeworks());
          final Success state = await bloc.stream.whereType<Success>().first;

          expect(state.completed.loadedAllCompletedHomeworks, true);
        },
      );
      test(
          'The nrOfInitialCompletedHomeworksToLoad should load only the specified number',
          () async {
        bloc = createBloc(repository, nrOfInitialCompletedHomeworksToLoad: 10);
        final completedHomeworks = generateCompleted(20);
        await addToRepository(completedHomeworks, repository);

        bloc.add(LoadHomeworks());

        final Future<HomeworkPageState> expectedPromise = bloc.stream
            .firstWhere((state) =>
                state is Success && state.completed.numberOfHomeworks == 10);
        expect(expectedPromise, completes);
      });

      test(
        'does load the next number of completed homeworks when requested',
        () async {
          bloc =
              createBloc(repository, nrOfInitialCompletedHomeworksToLoad: 10);
          final completedHomeworks = generateCompleted(20);
          await addToRepository(completedHomeworks, repository);

          bloc.add(LoadHomeworks());
          bloc.add(AdvanceCompletedHomeworks(10));
          final Future<HomeworkPageState> findExpectedState = bloc.stream
              .firstWhere((state) =>
                  state is Success &&
                  state.completed.numberOfHomeworks ==
                      20); // Skips loading and first Successful state, where the first 10 homeworks were loaded, to get the second successful state.

          expect(findExpectedState, completes);
        },
      );
      test(
          'should maintain the correct order when more homeworks are lazy loaded',
          () async {
        final alphabetString = String.fromCharCodes(
            List<int>.generate(26, (x) => 'a'.codeUnitAt(0) + x));
        final alphabet = alphabetString.split('');

        bloc = createBloc(repository, nrOfInitialCompletedHomeworksToLoad: 5);
        final completedHomeworks =
            generateCompleted(20, getTitle: (index) => alphabet[index]);
        await addToRepository(completedHomeworks, repository);

        bloc.add(LoadHomeworks());
        bloc.add(AdvanceCompletedHomeworks(5));
        bloc.add(AdvanceCompletedHomeworks(5));
        bloc.add(AdvanceCompletedHomeworks(5));

        final Success state = await bloc.stream
            .whereType<Success>()
            .firstWhere((state) => state.completed.numberOfHomeworks == 20);

        final orderedHomeworks = state.completed.orderedHomeworks;
        final orderedTitle = orderedHomeworks.map((h) => h.title).toList();
        final expectedOrderedTitles =
            List.generate(20, (index) => alphabet[index]);

        expect(orderedTitle, orderedEquals(expectedOrderedTitles));
      });
    });
  });
}

extension on OpenHomeworkListView {
  List<StudentHomeworkView> get orderedHomeworks {
    final listOfListOfHomeworks = sections.map((s) => s.homeworks).toList();
    if (listOfListOfHomeworks.isEmpty) return [];
    if (listOfListOfHomeworks.length == 1) return listOfListOfHomeworks.single;
    return listOfListOfHomeworks.reduce((l1, l2) => [...l1, ...l2]).toList();
  }
}

const uid = 'uid';
HomeworkPageBloc createBloc(
  InMemoryHomeworkRepository repository, {
  int nrOfInitialCompletedHomeworksToLoad = 1000,
  DateTime Function()? getCurrentDateTime,
  KeyValueStore? keyValueStore,
}) {
  return createHomeworkPageBloc(
    HausaufgabenheftDependencies(
      dataSource: repository,
      completionDispatcher: RepositoryHomeworkCompletionDispatcher(repository),
      getOpenOverdueHomeworkIds: () async {
        final open = await repository.openHomeworks.first;
        return HomeworkList(open).getOverdue().map((hw) => hw.id).toList();
      },
      keyValueStore: keyValueStore ?? InMemoryKeyValueStore(),
      getCurrentDateTime: getCurrentDateTime,
    ),
    HausaufgabenheftConfig(
      defaultCourseColorValue: const Color.fromRGBO(255, 255, 255, 1).value,
      nrOfInitialCompletedHomeworksToLoad: nrOfInitialCompletedHomeworksToLoad,
    ),
  );
}

completed.CompletedHomeworksViewBloc createCompletedHomeworksViewBloc(
    StudentHomeworkViewFactory viewFactory,
    InMemoryHomeworkRepository repository,
    {required int nrOfInitialCompletedHomeworksToLoad}) {
  final completedHomeworkListViewFactory =
      CompletedHomeworkListViewFactory(viewFactory);
  final lazyLoadingCompletedHomeworksBloc =
      lazy_loading.LazyLoadingCompletedHomeworksBloc(repository);
  final completedHomeworksViewBloc = completed.CompletedHomeworksViewBloc(
      lazyLoadingCompletedHomeworksBloc, completedHomeworkListViewFactory,
      nrOfInitialCompletedHomeworksToLoad: nrOfInitialCompletedHomeworksToLoad);
  return completedHomeworksViewBloc;
}

InMemoryHomeworkRepository createRepositoy() => InMemoryHomeworkRepository();

Date dateFromDay(int day) => Date(year: 2019, month: 1, day: day);

class RepositoryHomeworkCompletionDispatcher
    extends HomeworkCompletionDispatcher {
  final InMemoryHomeworkRepository _repository;

  RepositoryHomeworkCompletionDispatcher(this._repository);

  @override
  Future<void> dispatch(HomeworkCompletion homeworkCompletion) async {
    final hw = await _repository.findById(homeworkCompletion.homeworkId);
    final newHw = HomeworkReadModel(
      id: hw.id,
      title: hw.title,
      status: hw.status == CompletionStatus.open
          ? CompletionStatus.completed
          : CompletionStatus.open,
      subject: hw.subject,
      withSubmissions: hw.withSubmissions,
      todoDate: hw.todoDate,
    );
    await _repository.update(newHw);
  }
}

class VerboseBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stacktrace) {
    log('${bloc.runtimeType} error: $error, stacktrace: $stacktrace',
        error: error, stackTrace: stacktrace);
    super.onError(bloc, error, stacktrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log("${bloc.runtimeType} transition: $transition");
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log('${bloc.runtimeType} event: ${event.runtimeType}');
    super.onEvent(bloc, event);
  }
}
