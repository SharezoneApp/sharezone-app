import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_list_bloc/events.dart'
    as list_bloc;
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_list_bloc/open_homework_list_bloc.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_list_bloc/states.dart'
    as list_bloc;
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_view_bloc/events.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_view_bloc/open_homework_view_bloc.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_view_bloc/states.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/homework_sorts.dart';
import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/homework_section_view.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/open_homework_list_view.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/open_homework_list_view_factory.dart';
import 'package:test/test.dart';

void main() {
  group('OpenHomeworksViewBloc', () {
    OpenHomeworksViewBloc openHomeworksViewBloc;
    MockOpenHomeworkListBloc mockOpenHomeworkListBloc;
    MockOpenHomeworkListViewFactory mockOpenHomeworkListViewFactory;
    setUp(() {
      mockOpenHomeworkListBloc = MockOpenHomeworkListBloc();
      mockOpenHomeworkListViewFactory = MockOpenHomeworkListViewFactory();
      openHomeworksViewBloc = OpenHomeworksViewBloc(
          mockOpenHomeworkListBloc, mockOpenHomeworkListViewFactory);
    });

    test('returns correct homework', () async {
      var sections = [HomeworkSectionView('Some Section', const [])];
      mockOpenHomeworkListViewFactory.sectionsToReturn = sections;

      openHomeworksViewBloc
          .add(LoadHomeworks(SmallestDateSubjectAndTitleSort()));

      final Success success =
          await openHomeworksViewBloc.firstWhere((state) => state is Success);
      expect(success.openHomeworkListView.sections, sections);
    });
  });
}

class MockOpenHomeworkListViewFactory implements OpenHomeworkListViewFactory {
  List<HomeworkSectionView> sectionsToReturn = [];
  List<HomeworkReadModel> gotHomeworks = [];
  @override
  OpenHomeworkListView create(
      List<HomeworkReadModel> openHomeworks, Sort<HomeworkReadModel> sort) {
    gotHomeworks = openHomeworks;
    return OpenHomeworkListView(
      sectionsToReturn,
      showCompleteOverdueHomeworkPrompt: true,
      sorting: HomeworkSort.smallestDateSubjectAndTitle,
    );
  }
}

class MockOpenHomeworkListBloc extends Bloc<list_bloc.OpenHomeworkListBlocEvent,
    list_bloc.OpenHomeworkListBlocState> implements OpenHomeworkListBloc {
  var homeworkListToReturn = HomeworkList([]);

  @override
  list_bloc.OpenHomeworkListBlocState get initialState =>
      list_bloc.Success(homeworkListToReturn);

  @override
  Stream<list_bloc.OpenHomeworkListBlocState> mapEventToState(
      list_bloc.OpenHomeworkListBlocEvent event) {
    return Stream.value(list_bloc.Success(homeworkListToReturn));
  }
}
