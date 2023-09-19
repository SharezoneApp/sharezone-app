// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:collection';

import 'package:analytics/analytics.dart';
import 'package:analytics/null_analytics_backend.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart' hide Color;
import 'package:flutter/material.dart' as flutter show Color;
import 'package:flutter_test/flutter_test.dart';
import 'package:hausaufgabenheft_logik/color.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone/homework/teacher/src/teacher_archived_homework_list.dart';
import 'package:sharezone/homework/teacher/src/teacher_homework_bottom_action_bar.dart';
import 'package:sharezone/homework/teacher/src/teacher_homework_tile.dart';
import 'package:sharezone/homework/teacher/src/teacher_open_homework_list.dart';
import 'package:sharezone/homework/teacher/teacher_homework_page.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';

class MockTeacherHomeworkPageBloc extends TeacherHomeworkPageBloc {
  final _queuedStates = Queue<TeacherHomeworkPageState>();

  final receivedEvents = <TeacherHomeworkPageEvent>[];

  MockTeacherHomeworkPageBloc() : super() {
    on<TeacherHomeworkPageEvent>((event, emit) {
      if (_queuedStates.isNotEmpty) {
        emit(_queuedStates.removeFirst());
      }
    });
  }

  void emitNewState(TeacherHomeworkPageState state) {
    _queuedStates.add(state);
    add(LoadHomeworks());
  }

  @override
  void onEvent(TeacherHomeworkPageEvent event) {
    receivedEvents.add(event);
    super.onEvent(event);
  }
}

enum HomeworkTab { open, archived }

Future<void> pumpHomeworkPage(
  WidgetTester tester, {
  required TeacherHomeworkPageBloc bloc,
  HomeworkTab initialTab = HomeworkTab.open,
}) async {
  /// Wir müssen hier die Hausaufgaben-Seite nachbauen, weil
  /// [TeacherHomeworkPage] implizit (per [SharezoneMainScaffold]) auf den
  /// nicht mockbaren [SharezoneContext] angewiesen ist.
  /// Das sollte in Zukunft verbessert werden ([SharezoneMainScaffold]
  /// sollte in Tests verwendbar sein), so können wir aber schon mal das
  /// meiste ohne viel Arbeit testen.
  ///
  /// https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1459
  /// https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1458
  await tester.pumpWidget(
    MaterialApp(
      home: AnalyticsProvider(
        /// [NullAnalyticsBackend] does nothing, just used as a replacement for
        /// testing (else warnings would be printed out for tests.)
        analytics: Analytics(NullAnalyticsBackend()),
        child: ChangeNotifierProvider<BottomOfScrollViewInvisibilityController>(
          create: (_) => BottomOfScrollViewInvisibilityController(),
          child: MultiBlocProvider(
            blocProviders: [
              BlocProvider<NavigationBloc>(bloc: NavigationBloc()),
              BlocProvider<TeacherHomeworkPageBloc>(bloc: bloc),
            ],
            child: (context) => BlocProvider(
              bloc: NavigationBloc(),
              child: BlocProvider(
                bloc: MockTeacherHomeworkPageBloc(),
                child: DefaultTabController(
                  length: 2,
                  initialIndex: initialTab == HomeworkTab.open ? 0 : 1,
                  child: const Scaffold(
                    body: TeacherHomeworkBody(),
                    appBar: HomeworkTabBar(
                      tabs: [Tab(text: 'OFFEN'), Tab(text: 'ARCHIVIERT')],
                    ),
                    bottomNavigationBar: AnimatedTabVisibility(
                      visibleInTabIndicies: [0],
                      maintainState: true,
                      child: TeacherHomeworkBottomActionBar(
                        // We dont care in the tests currently
                        backgroundColor: flutter.Color.fromRGBO(0, 0, 0, 255),
                      ),
                    ),
                    floatingActionButton:
                        BottomOfScrollViewInvisibility(child: HomeworkFab()),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('TeacherHomeworkPage', () {
    late MockTeacherHomeworkPageBloc homeworkPageBloc;

    // Can't use this because of weird async behavior:
    // https://github.com/flutter/flutter/issues/5728
    // setUp(() {
    //   homeworkPageBloc = MockTeacherHomeworkPageBloc();
    // });

    tearDown(() {
      homeworkPageBloc.close();
    });

    testWidgets(
        'placeholder is shown on open homework page when no homeworks are to do',
        (tester) async {
      // If I comment this out (--> use the bloc from setUp) it won't work anymore
      homeworkPageBloc = MockTeacherHomeworkPageBloc();

      await _pumpHomeworkPageWithNoHomeworks(tester,
          bloc: homeworkPageBloc, initialTab: HomeworkTab.open);

      expect(_finders.openHomeworkTab.noHomeworkPlaceholder, findsOneWidget);
    });

    testWidgets(
        'placeholder is shown in archived homework page when no homework is archived',
        (tester) async {
      homeworkPageBloc = MockTeacherHomeworkPageBloc();

      await _pumpHomeworkPageWithNoHomeworks(tester,
          bloc: homeworkPageBloc, initialTab: HomeworkTab.archived);

      expect(
          _finders.archivedHomeworkTab.noHomeworkPlaceholder, findsOneWidget);
    });

    testWidgets('shows open homeworks with section titles in given order',
        (tester) async {
      homeworkPageBloc = MockTeacherHomeworkPageBloc();

      await pumpHomeworkPage(tester,
          bloc: homeworkPageBloc, initialTab: HomeworkTab.open);

      homeworkPageBloc.emitNewState(Success(
        TeacherOpenHomeworkListView([
          TeacherHomeworkSectionView('Section 1', [
            randomHomeworkViewWith(title: 'HW in first Section'),
          ]),
          TeacherHomeworkSectionView('Section 2', [
            randomHomeworkViewWith(title: 'HW in second Section'),
          ]),
        ], sorting: HomeworkSort.subjectSmallestDateAndTitleSort),
        TeacherArchivedHomeworkListView(
          [],
          loadedAllArchivedHomeworks: true,
        ),
      ));

      await tester.pump();

      final sectionTitle1Offset = tester.getCenter(find.text('Section 1'));
      final ha1TitleOffset = tester.getCenter(find.text('HW in first Section'));
      final sectionTitle2Offset = tester.getCenter(find.text('Section 2'));
      final ha2TitleOffset =
          tester.getCenter(find.text('HW in second Section'));

      // Offset starts from the top left.
      // The Y-Axis (height) is positive going to the bottom.
      // This means that a widget with dy == 0 is on top of one with dy == 100.

      // We're expecting following positions:
      // Section 1
      // Homework 1
      // Section 2
      // Homework 2

      // "Section Title 1 is on top of homework title 1"
      expect(sectionTitle1Offset.dy, lessThan(ha1TitleOffset.dy));
      expect(ha1TitleOffset.dy, lessThan(sectionTitle2Offset.dy));
      expect(sectionTitle2Offset.dy, lessThan(ha2TitleOffset.dy));
    });

    testWidgets('shows curent sorting text inside of sort button',
        (tester) async {
      homeworkPageBloc = MockTeacherHomeworkPageBloc();

      await pumpHomeworkPage(tester,
          bloc: homeworkPageBloc, initialTab: HomeworkTab.open);

      // It doesn't matter if there are homeworks or not for this test
      homeworkPageBloc.emitNewState(
          _openHomeworksWith(HomeworkSort.smallestDateSubjectAndTitle));

      await tester.pump();

      expect(find.text(TeacherSortButton.sortByDateSortButtonUiString),
          findsOneWidget);

      homeworkPageBloc.emitNewState(
          _openHomeworksWith(HomeworkSort.subjectSmallestDateAndTitleSort));

      await tester.pumpAndSettle();

      expect(find.text(TeacherSortButton.sortBySubjectSortButtonUiString),
          findsOneWidget);
    });

    Future<void> scrollDownToEndOfArchivedHomeworkList(WidgetTester tester) {
      return tester.drag(
          find.byWidgetPredicate(
              (widget) => widget is TeacherArchivedHomeworkList),
          const Offset(0, -5000));
    }

    List<TeacherHomeworkView> generateRandomHomeworks({required int count}) {
      return List.generate(
          count, (index) => randomHomeworkViewWith(/*Random content*/));
    }

    testWidgets('lazy-loads archived homeworks', (tester) async {
      homeworkPageBloc = MockTeacherHomeworkPageBloc();

      await pumpHomeworkPage(tester,
          bloc: homeworkPageBloc, initialTab: HomeworkTab.archived);

      final firstHomeworkBatch = generateRandomHomeworks(count: 30);

      homeworkPageBloc.emitNewState(
        Success(
          _noOpenHomeworks,
          TeacherArchivedHomeworkListView(
            firstHomeworkBatch,
            loadedAllArchivedHomeworks: false,
          ),
        ),
      );

      await tester.pump();

      expect(
          homeworkPageBloc.receivedEvents.whereType<AdvanceArchivedHomeworks>(),
          isEmpty,
          reason:
              'The UI should not trigger loading the next homeworks if the user has not scrolled down far enough (to save bandwidth and only load new homeworks when necessary).');

      // Originally I wanted to scroll only until the last visible homework but I
      // couldn't get it to work. So this is the stupid solution :)
      // As we manually control returning new homworks to the UI we can't "overscroll"
      // here so the UI should only ask the bloc once.
      await scrollDownToEndOfArchivedHomeworkList(tester);

      expect(
          homeworkPageBloc.receivedEvents.whereType<AdvanceArchivedHomeworks>(),
          hasLength(1),
          reason:
              "After scrolling down to near the last loaded homework the bloc should've received the event to load the next archived homeworks (as there are more to load in this test).");

      final allLoadedHomeworks = [
        ...firstHomeworkBatch,
        ...generateRandomHomeworks(count: 10)
      ];

      homeworkPageBloc.emitNewState(
        Success(
          _noOpenHomeworks,
          TeacherArchivedHomeworkListView(
            allLoadedHomeworks,
            // Now all homeworks are loaded
            loadedAllArchivedHomeworks: true,
          ),
        ),
      );

      await scrollDownToEndOfArchivedHomeworkList(tester);

      expect(
          homeworkPageBloc.receivedEvents.whereType<AdvanceArchivedHomeworks>(),
          // Same as above - the UI didn't ask again this time
          hasLength(1),
          reason:
              "The UI should not ask the bloc for new homework when scrolling to the end of the homework list (as all homeworks have already been loaded).");

      // In the teacher homework page bloc which is just a mock right now we use
      // `await Future.delayed(const Duration(milliseconds: 1200))` to simulate
      // the loading of homeworks.
      // Since testWidgets uses fakeAsync interally and Future.delayed uses a
      // Timer internally we need to pump (advance the fakeAsync time) so that
      // this test doesn't fail because of this:
      //  The following assertion was thrown running a test:
      //  A Timer is still pending even after the widget tree was disposed.
      tester.pump(const Duration(seconds: 2));
    });

    testWidgets(
        'pressing the sort button changes sorting to subject sort when current sort is date sort',
        (tester) async {
      homeworkPageBloc = MockTeacherHomeworkPageBloc();

      await pumpHomeworkPage(tester,
          bloc: homeworkPageBloc, initialTab: HomeworkTab.open);

      homeworkPageBloc.emitNewState(
          _openHomeworksWith(HomeworkSort.smallestDateSubjectAndTitle));

      await tester.pump();

      await tester.tap(_finders.openHomeworkTab.bnbSortButton);

      expect(
          homeworkPageBloc.receivedEvents
              .whereType<OpenHwSortingChanged>()
              .single,
          OpenHwSortingChanged(HomeworkSort.subjectSmallestDateAndTitleSort));
    });

    testWidgets(
        'pressing sort button changes sorting to date sort when current sort is subject sort',
        (tester) async {
      homeworkPageBloc = MockTeacherHomeworkPageBloc();

      await pumpHomeworkPage(tester,
          bloc: homeworkPageBloc, initialTab: HomeworkTab.open);

      homeworkPageBloc.emitNewState(
          _openHomeworksWith(HomeworkSort.subjectSmallestDateAndTitleSort));

      await tester.pump();

      await tester.tap(_finders.openHomeworkTab.bnbSortButton);

      expect(
          homeworkPageBloc.receivedEvents
              .whereType<OpenHwSortingChanged>()
              .single,
          OpenHwSortingChanged(HomeworkSort.smallestDateSubjectAndTitle));
    });

    Future<void> pumpHomeworkTiles(
        WidgetTester tester, List<TeacherHomeworkView> views) async {
      homeworkPageBloc = MockTeacherHomeworkPageBloc();

      await pumpHomeworkPage(tester,
          bloc: homeworkPageBloc, initialTab: HomeworkTab.open);

      homeworkPageBloc.emitNewState(Success(
        TeacherOpenHomeworkListView([
          TeacherHomeworkSectionView('Section 1', views),
        ], sorting: HomeworkSort.subjectSmallestDateAndTitleSort),
        TeacherArchivedHomeworkListView(
          [],
          loadedAllArchivedHomeworks: true,
        ),
      ));

      await tester.pump();
    }

    testWidgets(
        'shows number of students who have done the homework as a counter in the homework tile',
        (tester) async {
      const nrOfCompletionsForNormalHomework = 5;
      const nrOfCompletionsForSubmittableHomework = 8;

      await pumpHomeworkTiles(tester, [
        randomHomeworkViewWith(
          title: 'normal HW',
          withSubmissions: false,
          nrOfStudentsCompletedOrSubmitted: nrOfCompletionsForNormalHomework,
        ),
        randomHomeworkViewWith(
          title: 'submittable HW',
          withSubmissions: true,
          nrOfStudentsCompletedOrSubmitted:
              nrOfCompletionsForSubmittableHomework,
        ),
      ]);

      expect(
          find.widgetWithText(
              TeacherHomeworkTile, '$nrOfCompletionsForNormalHomework'),
          findsOneWidget);
      expect(
          find.widgetWithText(
              TeacherHomeworkTile, '$nrOfCompletionsForSubmittableHomework'),
          findsOneWidget);
    });

    testWidgets(
        'displays no placeholder on archived homework tab when there are no homeworks loaded locally but not all homeworks have been loaded from the backend',
        (tester) async {
      homeworkPageBloc = MockTeacherHomeworkPageBloc();

      await pumpHomeworkPage(tester,
          bloc: homeworkPageBloc, initialTab: HomeworkTab.archived);

      homeworkPageBloc.emitNewState(Success(
        _noOpenHomeworks,
        TeacherArchivedHomeworkListView(
          // No homeworks loaded already
          [],
          // but there are homeworks to load
          loadedAllArchivedHomeworks: false,
        ),
      ));

      await tester.pump();

      expect(_finders.archivedHomeworkTab.noHomeworkPlaceholder, findsNothing);

      // See test further above for why we need to pump here.
      tester.pump(const Duration(seconds: 2));
    });
  });
}

// Convenience class for more readable tests.
final _finders = _HomeworkPageFinders();

class _HomeworkPageFinders {
  Finder get floatingActionButton => find.byType(HomeworkFab);
  _OpenHomeworkTabFinders get openHomeworkTab => _OpenHomeworkTabFinders();
  _ArchivedHomeworkListFinders get archivedHomeworkTab =>
      _ArchivedHomeworkListFinders();
}

class _OpenHomeworkTabFinders {
  Finder get homeworkList => find.byType(TeacherOpenHomeworkList);
  Finder get bnbSortButton => find.byType(TeacherSortButton);
  Finder get noHomeworkPlaceholder =>
      // Widget is private. Not sure if this is the best way or if we should make
      // the Widget public and use the type directly.
      find.byKey(
          const ValueKey('no-homework-teacher-placeholder-for-open-homework'));
}

class _ArchivedHomeworkListFinders {
  Finder get homeworkList => find.byType(TeacherArchivedHomeworkList);
  Finder get noHomeworkPlaceholder => find
      // Widget is private. Not sure if this is the best way or if we should make
      // the Widget public and use the type directly.
      .byKey(const ValueKey(
          'no-homework-teacher-placeholder-for-archived-homework'));
}

bool _randomBool() {
  // 👈😎👉 SO SMART 👈😎👉
  return randomBetween(0, 2).isEven;
}

TeacherHomeworkView randomHomeworkViewWith({
  String? title,
  int? nrOfStudentsCompletedOrSubmitted,
  bool? withSubmissions,
}) {
  return TeacherHomeworkView(
    id: HomeworkId(randomAlphaNumeric(10)),
    title: title ?? 'S. ${randomBetween(1, 300)} Nr. ${randomBetween(1, 20)}',
    abbreviation: 'E',
    colorDate: false,
    nrOfStudentsCompletedOrSubmitted: nrOfStudentsCompletedOrSubmitted ?? 2,
    subject: 'Englisch',
    subjectColor: const Color.fromARGB(200, 200, 200, 255),
    todoDate: '03.04.2021',
    withSubmissions: withSubmissions ?? _randomBool(),
    canViewCompletionOrSubmissionList: _randomBool(),
    canDeleteForEveryone: _randomBool(),
    canEditForEveryone: _randomBool(),
  );
}

Success _openHomeworksWith(HomeworkSort sort) {
  return Success(
    TeacherOpenHomeworkListView([
      TeacherHomeworkSectionView('Heute', [
        randomHomeworkViewWith(title: 'S. 32'),
        randomHomeworkViewWith(title: 'S. 34'),
        randomHomeworkViewWith(title: 'S. 31'),
      ])
    ], sorting: sort),
    _noArchivedHomeworks,
  );
}

final _noHomeworks = Success(
  TeacherOpenHomeworkListView(
    [],
    sorting: HomeworkSort.smallestDateSubjectAndTitle,
  ),
  TeacherArchivedHomeworkListView(
    [],
    loadedAllArchivedHomeworks: true,
  ),
);

final _noOpenHomeworks = TeacherOpenHomeworkListView([],
    sorting: HomeworkSort.smallestDateSubjectAndTitle);
final _noArchivedHomeworks =
    TeacherArchivedHomeworkListView([], loadedAllArchivedHomeworks: true);

Future<void> _pumpHomeworkPageWithNoHomeworks(
  WidgetTester tester, {
  required MockTeacherHomeworkPageBloc bloc,
  HomeworkTab initialTab = HomeworkTab.open,
}) async {
  await pumpHomeworkPage(tester, bloc: bloc, initialTab: initialTab);

  bloc.emitNewState(_noHomeworks);

  await tester.pump();
}
