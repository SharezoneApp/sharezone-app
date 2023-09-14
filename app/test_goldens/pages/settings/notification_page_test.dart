import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/blocs/settings/notifications_bloc.dart';
import 'package:sharezone/blocs/settings/notifications_bloc_factory.dart';
import 'package:sharezone/pages/settings/notification.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'notification_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NotificationsBloc>(),
  MockSpec<NotificationsBlocFactory>(),
])
void main() {
  group(NotificationPage, () {
    late MockNotificationsBloc mockNotificationsBloc;
    late MockNotificationsBlocFactory mockNotificationsBlocFactory;

    setUp(() {
      mockNotificationsBloc = MockNotificationsBloc();
      mockNotificationsBlocFactory = MockNotificationsBlocFactory();

      when(mockNotificationsBlocFactory.create())
          .thenReturn(mockNotificationsBloc);
    });

    Future<void> pumpNotificationPage(
      WidgetTester tester, {
      ThemeData? themeData,
    }) async {
      await tester.pumpWidgetBuilder(
        Provider<TypeOfUser?>(
          create: (_) => TypeOfUser.student,
          child: BlocProvider<NotificationsBlocFactory>(
            bloc: mockNotificationsBlocFactory,
            child: const NotificationPage(),
          ),
        ),
        wrapper: materialAppWrapper(theme: themeData),
      );
    }

    testGoldens('renders as expected (light mode)', (tester) async {
      await pumpNotificationPage(tester, themeData: lightTheme);

      await screenMatchesGolden(tester, 'notification_page_light');
    });

    testGoldens('renders as expected (dark mode)', (tester) async {
      await pumpNotificationPage(tester, themeData: darkTheme);

      await screenMatchesGolden(tester, 'notification_page_dark');
    });
  });
}
