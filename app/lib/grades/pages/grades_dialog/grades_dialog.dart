// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/filesharing/dialog/course_tile.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart'
    hide InvalidGradeValueException;
import 'package:sharezone/grades/pages/create_term_page/create_term_page.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller_factory.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_view.dart';
import 'package:sharezone/grades/pages/shared/saved_grade_icons.dart';
import 'package:sharezone/grades/pages/shared/select_grade_type_dialog.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

part 'fields.dart';

class GradesDialog extends StatelessWidget {
  const GradesDialog({super.key, this.gradeId});

  static const tag = 'grades-dialog';

  /// The [GradeId] of the grade to edit, `null` if grade should be created.
  final GradeId? gradeId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GradesDialogController>(
      create: (context) {
        final factory = context.read<GradesDialogControllerFactory>();
        return factory.create(gradeId);
      },
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(actions: const [_SaveButton()]),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: SafeArea(child: MaxWidthConstraintBox(child: _Fields())),
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
    final unknownErrorMessage = 'Unbekannter Fehler: $e';
    String? message;

    if (e is SaveGradeException) {
      message = switch (e) {
        InvalidFieldsSaveGradeException() => _getInvalidFieldsMessage(e),
        UnknownSaveGradeException() => unknownErrorMessage,
      };
    } else {
      message = unknownErrorMessage;
    }

    showSnackSec(context: context, text: message);
  }

  String _getInvalidFieldsMessage(InvalidFieldsSaveGradeException e) {
    assert(e.invalidFields.isNotEmpty);

    if (e.invalidFields.length == 1) {
      return switch (e.invalidFields.first) {
        GradingDialogFields.gradeValue => 'Die Note fehlt oder ist ungültig.',
        GradingDialogFields.title => 'Der Titel fehlt oder ist ungültig.',
        GradingDialogFields.subject => 'Bitte gib ein Fach für die Note an.',
        GradingDialogFields.term => 'Bitte gib ein Halbjahr für die an.',
      };
    }
    final fields = e.invalidFields;
    final fieldMessages = fields.map((f) => f.toUiString()).join(', ');
    return 'Folgende Felder fehlen oder sind ungültig: $fieldMessages.';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(
      context,
      listen: false,
    );
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilledButton(
        onPressed: () async {
          try {
            sendDataToFrankfurtSnackBar(context);
            await controller.save();
            if (!context.mounted) return;

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
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
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
          _TakeIntoAccountSwitch(),
          _Title(),
          _Details(),
        ],
      ),
    );
  }
}
