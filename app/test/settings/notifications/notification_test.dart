import 'package:async/async.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/blocs/settings/notifications_bloc.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_common/sharezone_time_of_day.dart';
import 'package:test/test.dart';
import 'package:user/user.dart';

class MockUserApi extends Mock implements UserGateway {}

class MockUser extends Mock implements AppUser {}

void main() {
  group("NotificationBloc", () {
    NotificationsBloc bloc;
    MockUserApi api;
    MockUserApi apiWithUserWithReminder;
    NotificationsBloc blocWithUserWithReminder;
    MockUser user;
    setUp(() {
      api = MockUserApi();
      user = MockUser();

      final userWithReminder = MockUser();
      when(userWithReminder.reminderTime).thenAnswer((_) => "15:30");
      apiWithUserWithReminder = MockUserApi();
      when(apiWithUserWithReminder.userStream)
          .thenAnswer((_) => Stream.fromIterable([userWithReminder]));
      when(apiWithUserWithReminder.setHomeworkReminderTime(null))
          .thenAnswer((_) => Future.value());
      blocWithUserWithReminder = NotificationsBloc(apiWithUserWithReminder);
    });

    test(
        "should emit that messaging is enabled if the api stream gives back a user with reminder time",
        () {
      expect(blocWithUserWithReminder.notificationsForHomeworks, emits(true));
      blocWithUserWithReminder.dispose();
      expect(blocWithUserWithReminder.notificationsForHomeworks,
          neverEmits(false));
    });

    test(
        "should emit that messaging is disabled if the api stream gives back a user with no reminder time",
        () async {
      when(user.reminderTime).thenAnswer((_) => null);
      when(api.userStream).thenAnswer((_) => Stream.fromIterable([user]));
      bloc = NotificationsBloc(api);
      // Warten, dass die Stream-Events von oben "ankommen"
      await pumpEventQueue();
      expect(bloc.notificationsForHomeworks, emitsInOrder([false, emitsDone]));
      bloc.dispose();
    });

    test(
        "should call the api and change reminder status when messaging status gets turned off",
        () async {
      when(user.reminderTime).thenAnswer((_) => "12:30");
      BehaviorSubject<AppUser> userStream =
          BehaviorSubject<AppUser>.seeded(user);
      when(api.userStream).thenAnswer((_) => userStream);
      when(api.setHomeworkReminderTime(null)).thenAnswer((_) => Future.value());
      bloc = NotificationsBloc(api);

      StreamQueue queue = StreamQueue<bool>(bloc.notificationsForHomeworks);

      expect(await queue.next, true);

      bloc.changeNotificationsForHomeworks(false);
      verify(api.setHomeworkReminderTime(null)).called(1);

      when(user.reminderTime).thenAnswer((_) => null);
      userStream.add(user);

      expect(await queue.next, false);

      bloc.changeNotificationsForHomeworks(true);
      verify(api.setHomeworkReminderTime(NotificationsBloc.seedValue))
          .called(1);
      when(user.reminderTime).thenAnswer((_) => "18:30"); // arbitrary value
      userStream.add(user);
      expect(await queue.next, true);

      userStream.close();
    });

    test('should call the api when the reminderTime is changed', () async {
      blocWithUserWithReminder.changeNotificationsTimeForHomeworks(
          SharezoneTimeOfDay(hour: 13, minute: 30));
      verify(apiWithUserWithReminder
          .setHomeworkReminderTime(SharezoneTimeOfDay(hour: 13, minute: 30)));
    });

    test("should not call api if timeOfDay is same as before", () async {
      blocWithUserWithReminder.changeNotificationsTimeForHomeworks(
          SharezoneTimeOfDay(hour: 15, minute: 30));
      verifyNever(apiWithUserWithReminder
          .setHomeworkReminderTime(SharezoneTimeOfDay(hour: 15, minute: 30)));
    });
    group(".convertReminderTimeToTimeOfDay", () {
      test("convertes correctly", () {
        when(user.reminderTime).thenAnswer((_) => "12:30");
        when(api.userStream).thenAnswer((_) => Stream.fromIterable([user]));
        bloc = NotificationsBloc(api);
        expect(bloc.convertReminderTimeToTimeOfDay("12:30"),
            SharezoneTimeOfDay(hour: 12, minute: 30));
      });
    });
  });

  group('SharezoneTimeOfDay', () {
    test('returns correct short String', () {
      expect(SharezoneTimeOfDay(hour: 14, minute: 30).toStringShort(), "14:30");
      expect(SharezoneTimeOfDay(hour: 1, minute: 3).toStringShort(), "01:03");
      expect(SharezoneTimeOfDay(hour: 0, minute: 0).toStringShort(), "00:00");
    });
  });
}
