// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc_lib;
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
import 'package:sharezone/pages/homework/homework_dialog.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

import '../../../test/homework/homework_dialog_bloc_test.dart';
import '../../../test/homework/homework_dialog_test.dart';

// ignore_for_file: invalid_use_of_visible_for_testing_member

class MockHomeworkDialogBloc extends MockPresentationBloc<
    HomeworkDialogEvent,
    HomeworkDialogState,
    HomeworkDialogBlocPresentationEvent> implements HomeworkDialogBloc {}

void main() {
  group('HomeworkDialog', () {
    late MockHomeworkDialogBloc homeworkDialogBloc;

    setUp(() {
      homeworkDialogBloc = MockHomeworkDialogBloc();
    });

    Future<void> pumpAndSettleHomeworkDialog(WidgetTester tester,
        {required ThemeData theme, required bool isEditing}) async {
      await tester.pumpWidgetBuilder(
        bloc_lib.BlocProvider<HomeworkDialogBloc>(
          create: (context) => homeworkDialogBloc,
          child: Scaffold(
            body: HomeworkDialogMain(
              isEditing: isEditing,
              bloc: homeworkDialogBloc,
            ),
          ),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    testGoldens('renders empty create homework dialog as expected',
        (tester) async {
      whenListen(
        homeworkDialogBloc,
        Stream.value(emptyCreateHomeworkDialogState),
        initialState: emptyCreateHomeworkDialogState,
      );

      await pumpAndSettleHomeworkDialog(tester,
          isEditing: false, theme: lightTheme);

      await multiScreenGolden(
        tester,
        'homework_dialog_add_empty_light',
      );

      await pumpAndSettleHomeworkDialog(tester,
          isEditing: false, theme: darkTheme);

      await multiScreenGolden(
        tester,
        'homework_dialog_add_empty_dark',
      );
    });

    testGoldens('renders filled create homework dialog as expected',
        (tester) async {
      final state = Ready(
        title: ('S. 32 8a)', error: null),
        course: CourseChosen(
          courseId: CourseId('maths'),
          courseName: 'Maths',
          isChangeable: true,
        ),
        dueDate: (Date('2023-10-12'), error: null),
        submissions: const SubmissionsDisabled(isChangeable: false),
        description: 'Das ist eine Beschreibung',
        attachments: IList([
          FileView(
            fileId: FileId('foo'),
            fileName: 'foo.png',
            format: FileFormat.image,
            localFile: FakeLocalFile.empty(
              name: 'foo.png',
              mimeType: MimeType('png'),
            ),
          ),
          FileView(
            fileId: FileId('bar'),
            fileName: 'bar.pdf',
            format: FileFormat.pdf,
            localFile: FakeLocalFile.empty(
              name: 'bar.pdf',
              mimeType: MimeType('pdf'),
            ),
          ),
        ]),
        notifyCourseMembers: false,
        isPrivate: (true, isChangeable: true),
        hasModifiedData: true,
        isEditing: false,
      );

      whenListen(
        homeworkDialogBloc,
        Stream.value(state),
        initialState: state,
      );

      await pumpAndSettleHomeworkDialog(tester,
          isEditing: false, theme: lightTheme);

      await multiScreenGolden(
        tester,
        'homework_dialog_add_filled_1_light',
      );

      await pumpAndSettleHomeworkDialog(tester,
          isEditing: false, theme: darkTheme);

      await multiScreenGolden(
        tester,
        'homework_dialog_add_filled_1_dark',
      );
    });

    testGoldens(
        'renders homework dialog when uploading attachments as expected',
        (tester) async {
      final state = Ready(
        title: ('S. 32 8a)', error: null),
        course: CourseChosen(
          courseId: CourseId('maths'),
          courseName: 'Maths',
          isChangeable: true,
        ),
        dueDate: (Date('2023-10-12'), error: null),
        submissions: const SubmissionsDisabled(isChangeable: false),
        description: 'Das ist eine Beschreibung',
        attachments: IList([
          FileView(
            fileId: FileId('foo'),
            fileName: 'foo.png',
            format: FileFormat.image,
            localFile: FakeLocalFile.empty(
              name: 'foo.png',
              mimeType: MimeType('png'),
            ),
          ),
          FileView(
            fileId: FileId('bar'),
            fileName: 'bar.pdf',
            format: FileFormat.pdf,
            localFile: FakeLocalFile.empty(
              name: 'bar.pdf',
              mimeType: MimeType('pdf'),
            ),
          ),
        ]),
        notifyCourseMembers: false,
        isPrivate: (true, isChangeable: true),
        hasModifiedData: true,
        isEditing: false,
      );

      whenListen(
        homeworkDialogBloc,
        Stream.value(state),
        initialState: state,
      );

      whenListenPresentation(homeworkDialogBloc,
          initialEvents: [const StartedUploadingAttachments()]);
      await pumpAndSettleHomeworkDialog(tester,
          isEditing: false, theme: lightTheme);

      // Wait for the SnackBar to appear.
      await tester.pump(const Duration(milliseconds: 500));

      await multiScreenGolden(
        tester,
        'homework_dialog_add_uploading_attachments_light',
        // Is usually `pumpAndSettle` but as the SnackBar has an endless loading
        // animation we need to use `pump` here. Otherwise we get the error:
        // `pumpAndSettle timed out`.
        customPump: (tester) => tester.pump(),
      );

      // `whenListenPresentation` needs to be called again as internally only
      // a normal instead of a broadcast stream is used and thus it would fail
      // as a normal stream can only be listened to once.
      whenListenPresentation(homeworkDialogBloc,
          initialEvents: [const StartedUploadingAttachments()]);

      await pumpAndSettleHomeworkDialog(
        tester,
        isEditing: false,
        theme: darkTheme,
      );
      // Otherwise the theme is not completly applied (some text is still black
      // instead of white).
      await tester.pump(const Duration(milliseconds: 500));

      // Wait for the SnackBar to appear.
      await tester.pump(const Duration(milliseconds: 500));

      await multiScreenGolden(
        tester,
        'homework_dialog_add_uploading_attachments_dark',
        customPump: (tester) => tester.pump(),
      );
    });
    testGoldens(
        'renders homework dialog when uploading attachments as expected',
        (tester) async {
      final state = Ready(
        title: ('S. 32 8a)', error: null),
        course: CourseChosen(
          courseId: CourseId('maths'),
          courseName: 'Maths',
          isChangeable: true,
        ),
        dueDate: (Date('2023-10-12'), error: null),
        submissions: const SubmissionsDisabled(isChangeable: false),
        description: 'Das ist eine Beschreibung',
        attachments: IList([
          FileView(
            fileId: FileId('foo'),
            fileName: 'foo.png',
            format: FileFormat.image,
            localFile: FakeLocalFile.empty(
              name: 'foo.png',
              mimeType: MimeType('png'),
            ),
          ),
          FileView(
            fileId: FileId('bar'),
            fileName: 'bar.pdf',
            format: FileFormat.pdf,
            localFile: FakeLocalFile.empty(
              name: 'bar.pdf',
              mimeType: MimeType('pdf'),
            ),
          ),
        ]),
        notifyCourseMembers: false,
        isPrivate: (true, isChangeable: true),
        hasModifiedData: true,
        isEditing: false,
      );

      whenListen(
        homeworkDialogBloc,
        Stream.value(state),
        initialState: state,
      );

      whenListenPresentation(homeworkDialogBloc, initialEvents: [
        const StartedUploadingAttachments(),
        SavingFailed(Exception('Test Exception Message'), null)
      ]);
      await pumpAndSettleHomeworkDialog(tester,
          isEditing: false, theme: lightTheme);

      // Wait for the SnackBar to appear.
      await tester.pump(const Duration(milliseconds: 500));

      await multiScreenGolden(
        tester,
        'homework_dialog_uploading_attachment_failed_light',
        // Is usually `pumpAndSettle` but as the SnackBar has an endless loading
        // animation we need to use `pump` here. Otherwise we get the error:
        // `pumpAndSettle timed out`.
        customPump: (tester) => tester.pump(),
      );

      // `whenListenPresentation` needs to be called again as internally only
      // a normal instead of a broadcast stream is used and thus it would fail
      // as a normal stream can only be listened to once.
      whenListenPresentation(homeworkDialogBloc, initialEvents: [
        const StartedUploadingAttachments(),
        SavingFailed(Exception('Test Exception Message'), null)
      ]);

      await pumpAndSettleHomeworkDialog(
        tester,
        isEditing: false,
        theme: darkTheme,
      );
      // Otherwise the theme is not completly applied (some text is still black
      // instead of white).
      await tester.pump(const Duration(milliseconds: 500));

      // Wait for the SnackBar to appear.
      await tester.pump(const Duration(milliseconds: 500));

      await multiScreenGolden(
        tester,
        'homework_dialog_uploading_attachment_failed_dark',
        customPump: (tester) => tester.pump(),
      );
    });

    testGoldens('renders filled create homework dialog with errors as expected',
        (tester) async {
      // TODO: Use copyWith instead of creating a new state from scratch?
      final state = Ready(
        title: ('', error: const EmptyTitleException()),
        course: const NoCourseChosen(error: NoCourseChosenException()),
        dueDate: (
          Date('2023-10-12'),
          error: const NoDueDateSelectedException()
        ),
        submissions: const SubmissionsDisabled(isChangeable: false),
        description: 'Das ist eine Beschreibung',
        attachments: IList([
          FileView(
            fileId: FileId('foo'),
            fileName: 'foo.png',
            format: FileFormat.image,
            localFile: FakeLocalFile.empty(
              name: 'foo.png',
              mimeType: MimeType('png'),
            ),
          ),
          FileView(
            fileId: FileId('bar'),
            fileName: 'bar.pdf',
            format: FileFormat.pdf,
            localFile: FakeLocalFile.empty(
              name: 'bar.pdf',
              mimeType: MimeType('pdf'),
            ),
          ),
        ]),
        notifyCourseMembers: false,
        isPrivate: (true, isChangeable: true),
        hasModifiedData: true,
        isEditing: false,
      );

      whenListen(
        homeworkDialogBloc,
        Stream.value(state),
        initialState: state,
      );

      await pumpAndSettleHomeworkDialog(tester,
          isEditing: false, theme: lightTheme);

      await multiScreenGolden(
        tester,
        'homework_dialog_add_filled_with_error_light',
      );

      await pumpAndSettleHomeworkDialog(tester,
          isEditing: false, theme: darkTheme);

      await multiScreenGolden(
        tester,
        'homework_dialog_add_filled_with_error_dark',
      );
    });

    testGoldens('renders filled edit homework dialog as expected',
        (tester) async {
      final state = Ready(
        title: ('AB fertig bearbeiten', error: null),
        course: CourseChosen(
          courseId: CourseId('foo_course'),
          courseName: 'Foo course',
          isChangeable: false,
        ),
        dueDate: (Date('2024-01-14'), error: null),
        submissions: SubmissionsEnabled(deadline: Time(hour: 16, minute: 30)),
        description: 'Bitte bearbeite das angehängte AB schriftlich fertig.',
        attachments: IList([
          FileView(
            fileId: FileId('foo_attachment_id'),
            fileName: 'foo_attachment.pdf',
            format: FileFormat.pdf,
            cloudFile: randomAttachmentCloudFileWith(
              id: 'foo_attachment_id',
              name: 'foo_attachment.pdf',
              courseId: 'foo_course',
            ),
          ),
        ]),
        notifyCourseMembers: true,
        isPrivate: (false, isChangeable: false),
        hasModifiedData: true,
        isEditing: true,
      );

      whenListen(
        homeworkDialogBloc,
        Stream.value(state),
        initialState: state,
      );

      await pumpAndSettleHomeworkDialog(tester,
          isEditing: false, theme: lightTheme);

      await multiScreenGolden(
        tester,
        'homework_dialog_edit_filled_1_light',
      );

      await pumpAndSettleHomeworkDialog(tester,
          isEditing: false, theme: darkTheme);

      await multiScreenGolden(
        tester,
        'homework_dialog_edit_filled_1_dark',
      );
    });
  });
}

// Used temporarily when testing so one can see what happens "on the screen" in
// a widget test without having to use a real device / simulator to run these
// tests.
// --update-goldens
Future<void> generateGolden(String name) async {
  await expectLater(
      find.byType(MaterialApp), matchesGoldenFile('goldens/golden_$name.png'));
}
