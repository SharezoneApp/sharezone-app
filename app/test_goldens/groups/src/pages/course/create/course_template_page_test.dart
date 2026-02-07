// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/groups/src/pages/course/create/bloc/course_create_bloc.dart';
import 'package:sharezone/groups/src/pages/course/create/bloc/course_create_bloc_factory.dart';
import 'package:sharezone/groups/src/pages/course/create/models/course_template.dart';
import 'package:sharezone/groups/src/pages/course/create/pages/course_template_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

import '../../../../../flutter_test_config.dart';
import 'course_template_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CourseCreateBloc>()])
void main() {
  group(CourseTemplatePage, () {
    late CourseCreateBlocFactory courseCreateBlocFactory;
    late MockCourseCreateBloc courseCreateBloc;

    setUp(() {
      courseCreateBloc = MockCourseCreateBloc();
      courseCreateBlocFactory = _FakeCourseCreateBlocFactory(courseCreateBloc);

      when(courseCreateBloc.isCourseTemplateAlreadyAdded(any)).thenAnswer((
        invocation,
      ) {
        final template = invocation.positionalArguments.first as CourseTemplate;
        return template.subject.length.isEven;
      });
    });

    Future<void> pushCourseTemplatePage(
      WidgetTester tester,
      ThemeData theme,
    ) async {
      await tester.pumpWidgetBuilder(
        BlocProvider<CourseCreateBlocFactory>(
          bloc: courseCreateBlocFactory,
          child: const CourseTemplatePage(),
        ),
        wrapper: materialAppWrapper(
          theme: theme,
          localeOverrides: defaultLocales,
          localizations: SharezoneLocalizations.localizationsDelegates,
        ),
      );
    }

    testGoldens('renders as expected (light mode)', (tester) async {
      await pushCourseTemplatePage(tester, getLightTheme());
      await multiScreenGolden(tester, 'course_template_page_light');
    });

    testGoldens('renders as expected (dark mode)', (tester) async {
      await pushCourseTemplatePage(tester, getDarkTheme());
      await multiScreenGolden(tester, 'course_template_page_dark');
    });
  });
}

class _FakeCourseCreateBlocFactory implements CourseCreateBlocFactory {
  final CourseCreateBloc _bloc;

  _FakeCourseCreateBlocFactory(this._bloc);

  @override
  CourseCreateBloc create({
    required SharezoneLocalizations l10n,
    SchoolClassId? schoolClassId,
  }) {
    return _bloc;
  }

  @override
  void dispose() {}
}
