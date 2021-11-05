import 'package:sharezone/pages/blackboard/details/blackboard_item_read_by_users_list/blackboard_item_read_by_users_list_bloc.dart';
import 'package:sharezone/pages/blackboard/details/blackboard_item_read_by_users_list/user_view.dart';
import 'package:test/test.dart';
import 'package:user/user.dart';

void main() {
  group('blackboard_item_read_by_users_list', () {
    group('user_view', () {
      final ironman = _createMockView('Ironman', TypeOfUser.student);
      final captainAmerica =
          _createMockView('Captain America', TypeOfUser.student);
      final thor = _createMockView('Thor', TypeOfUser.student);
      final blackWidow = _createMockView('Black Widow', TypeOfUser.parent);
      final loki = _createMockView('Loki', TypeOfUser.teacher);

      final unsortedViews = [ironman, captainAmerica, thor, blackWidow, loki];

      test('get student user views sorted alphabetically', () {
        final sortedStudentView = [captainAmerica, ironman, thor];
        expect(
            unsortedViews
                .getViewsOfTypeOfUserSortedAlphabetically(TypeOfUser.student),
            sortedStudentView);
      });

      test('get teacher user views sorted alphabetically', () {
        final sortedTeacherView = [loki];
        expect(
            unsortedViews
                .getViewsOfTypeOfUserSortedAlphabetically(TypeOfUser.teacher),
            sortedTeacherView);
      });

      test('get parent user views sorted alphabetically', () {
        final sortedParentViews = [blackWidow];
        expect(
            unsortedViews
                .getViewsOfTypeOfUserSortedAlphabetically(TypeOfUser.parent),
            sortedParentViews);
      });

      test('Sort user views first by typeOfUser and second by alphabet', () {
        final sortedViews = [loki, captainAmerica, ironman, thor, blackWidow];

        expect(unsortedViews.sortViewsFirstByTypeOfUserSecondByAlphabet(),
            sortedViews);
      });
    });
  });
}

UserView _createMockView(String name, TypeOfUser typeOfUser) {
  return UserView(
    uid: "uid",
    hasRead: false,
    name: name,
    typeOfUser: typeOfUser.toReadableString(),
  );
}
