// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:clock/clock.dart';
import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_page.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_view.dart';
import 'package:sharezone/grades/pages/shared/saved_grade_icons.dart';
import 'package:sharezone/groups/src/pages/course/course_card.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

part 'fields.dart';

class GradesDialog extends StatelessWidget {
  const GradesDialog({super.key});

  static const tag = 'grades-dialog';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GradesDialogController>(
      create: (context) {
        final api = BlocProvider.of<SharezoneContext>(context).api;
        return GradesDialogController(
          gradesService: Provider.of<GradesService>(
            context,
            listen: false,
          ),
          coursesStream: api.course.streamCourses(),
        );
      },
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            actions: const [_SaveButton()],
          ),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: SafeArea(
              child: MaxWidthConstraintBox(
                child: _Fields(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  void showConfirmationSnackBar(BuildContext context) {
    showSnackSec(context: context, text: 'Note gespeichert');
  }

  void showErrorSnackBar(BuildContext context, Object e) {
    if (e is SaveGradeException) {
      switch (e) {
        case MultipleInvalidFieldsSaveGradeException():
          showSnackSec(
            context: context,
            text:
                'Folgende Felder fehlen oder sind ungültig: ${e.invalidFields.map((f) => f.toUiString()).join(', ')}.',
          );
          break;
        case InvalidTitleSaveGradeException():
          showSnackSec(
            context: context,
            text: 'Der Titel fehlt oder ist ungültig.',
          );
          break;
        case UnknownSaveGradeException():
          unknownErrorSnackBar(context, e);
          break;
      }
    } else {
      unknownErrorSnackBar(context, e);
    }
  }

  void unknownErrorSnackBar(BuildContext context, Object e) {
    showSnackSec(context: context, text: 'Unbekannter Fehler: $e');
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        Provider.of<GradesDialogController>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilledButton(
        onPressed: () {
          try {
            controller.save();
            showConfirmationSnackBar(context);
            Navigator.of(context).pop();
          } catch (e) {
            if (!context.mounted) return;
            showErrorSnackBar(context, e);
          }
        },
        child: const Text("Speichern"),
      ),
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields();

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      data: Theme.of(context).listTileTheme.copyWith(
            subtitleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GradeValue(),
          _GradingSystem(),
          _Subject(),
          _Date(),
          _GradingType(),
          _Term(),
          _IntegrateGradeIntoSubjectGrade(),
          _Title(),
          _Details(),
        ],
      ),
    );
  }
}
