// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../test/timetable/mock/mock_course_gateway.dart';
import '../../test/timetable/mock/mock_school_class_filter_analytics.dart';
import '../../test/timetable/mock/mock_school_class_gateway.dart';
import '../../test/timetable/mock/mock_timetable_gateway.dart';
import '../../test/timetable/mock/mock_user_gateway.dart';
import 'timetable_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionService>(),
  MockSpec<SubscriptionEnabledFlag>(),
])
void main() {
  group(TimetablePage, () {
    group(SchoolClassFilter, () {
      SchoolClass _createSchoolClass(String id) {
        final data = {
          'name': id,
          'myRole': 'standard',
          'publicKey': '123456',
          'joinLink': 'https://sharez.one/RpvEuUZMLEjb522N8',
          'meetingID': 'l7hj-y1hw-s2we',
          'personalSharecode': '654321',
          'personalJoinLink': 'https://sharez.one/RpvEuUZMLEjb522N7',
          'settings': null
        };

        return SchoolClass.fromData(data, id: id);
      }

      late TimetableBloc bloc;
      late MockSchoolClassGateway schoolClassGateway;
      late MockSubscriptionService subscriptionService;
      late MockSubscriptionEnabledFlag subscriptionEnabledFlag;

      setUp(() {
        schoolClassGateway = MockSchoolClassGateway();
        subscriptionService = MockSubscriptionService();
        subscriptionEnabledFlag = MockSubscriptionEnabledFlag();

        bloc = TimetableBloc(
          schoolClassGateway,
          MockUserGateway(),
          MockTimetableGateway(),
          MockCourseGateway(),
          MockSchoolClassFilterAnalytics(),
        );

        schoolClassGateway.addSchoolClass(_createSchoolClass('10a'));
        schoolClassGateway.addSchoolClass(_createSchoolClass('5b'));

        when(subscriptionEnabledFlag.isEnabled).thenReturn(true);
      });

      Future<void> _pumpSchoolClassSelection(
        WidgetTester tester, {
        ThemeData? themeData,
      }) async {
        await tester.pumpWidget(
          FeatureDiscovery(
            child: MultiProvider(
              providers: [
                Provider<SubscriptionService>.value(value: subscriptionService),
                ChangeNotifierProvider<SubscriptionEnabledFlag>.value(
                    value: subscriptionEnabledFlag),
              ],
              child: MaterialApp(
                theme: themeData,
                home: BlocProvider(
                  bloc: bloc,
                  child: SingleChildScrollView(
                    child: SchoolClassFilterBottomBar(),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      Future<void> _openSchoolClassSelection(WidgetTester tester) async {
        await tester.tap(find.byIcon(Icons.group));
        await tester.pumpAndSettle();
      }

      Future<void> _testSchoolClassSelection(
        WidgetTester tester, {
        required String variant,
        ThemeData? themeData,
      }) async {
        await _pumpSchoolClassSelection(tester, themeData: themeData);

        await _openSchoolClassSelection(tester);

        await screenMatchesGolden(tester, 'school_class_filter_$variant');
      }

      group('with Sharezone Plus', () {
        setUp(() {
          when(subscriptionEnabledFlag.isEnabled).thenReturn(true);
          when(subscriptionService.isSubscriptionActive()).thenReturn(true);
        });

        testGoldens('should render as expected (light mode)', (tester) async {
          await _testSchoolClassSelection(
            tester,
            variant: 'with_plus_light',
            themeData: lightTheme,
          );
        });

        testGoldens('should render as expected (dark mode)', (tester) async {
          await _testSchoolClassSelection(
            tester,
            variant: 'with_plus_dark',
            themeData: lightTheme,
          );
        });
      });

      group('without Sharezone Plus', () {
        setUp(() {
          when(subscriptionService.isSubscriptionActive()).thenReturn(false);
        });

        testGoldens('should render as expected (light mode)', (tester) async {
          await _testSchoolClassSelection(
            tester,
            variant: 'with_without_plus_light',
            themeData: lightTheme,
          );
        });

        testGoldens('should render as expected (light mode)', (tester) async {
          await _testSchoolClassSelection(
            tester,
            variant: 'with_without_plus_dark',
            themeData: darkTheme,
          );
        });
      });
    });
  });
}
