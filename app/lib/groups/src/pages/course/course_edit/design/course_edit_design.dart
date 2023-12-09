// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:animations/animations.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/groups/src/pages/course/course_edit/design/src/bloc/course_edit_design_bloc.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

part 'src/dialog/select_design_dialog.dart';
part 'src/dialog/select_type_dialog.dart';

enum EditDesignType {
  course,
  personal,
}

Future<void> editCourseDesign(BuildContext context, String courseId) async {
  final courseGateway = BlocProvider.of<SharezoneContext>(context).api.course;
  final bloc = CourseEditDesignBloc(courseId, courseGateway);

  final selectTypePopResult = await showDialog<_SelectTypePopResult>(
      context: context, builder: (context) => _SelectTypeDialog(bloc: bloc));

  if (selectTypePopResult != null && context.mounted) {
    final initialDesign = selectTypePopResult.initialDesign;

    final selectDesignPopResult = await selectDesign(context, initialDesign,
        type: selectTypePopResult.editDesignType);
    if (!context.mounted) return;

    if (selectDesignPopResult != null) {
      if (selectDesignPopResult.navigateBackToSelectType) {
        editCourseDesign(context, courseId);
      } else if (selectDesignPopResult.removePersonalColor) {
        bloc.removePersonalDesign();
        showSnackSec(
          context: context,
          text: "Persönliche Farbe wurde entfernt.",
          seconds: 2,
        );
      } else if (selectDesignPopResult.design != null) {
        if (selectTypePopResult.editDesignType == EditDesignType.personal) {
          bloc.submitPersonalDesign(
            selectedDesign: selectDesignPopResult.design!,
            initialDesign: initialDesign,
          );
          showSnackSec(
            context: context,
            text: "Persönliche Farbe wurde gesetzt.",
            seconds: 2,
          );
        } else if (selectTypePopResult.editDesignType ==
            EditDesignType.course) {
          sendDataToFrankfurtSnackBar(context);
          try {
            await bloc.submitCourseDesign(
              selectedDesign: selectDesignPopResult.design!,
              initialDesign: initialDesign,
            );
            if (!context.mounted) return;

            showSnackSec(
              context: context,
              text: "Farbe wurde erfolgreich für den gesamten Kurs geändert.",
              seconds: 2,
            );
          } on ChangingDesignFailedException catch (_) {
            showSnackSec(
              context: context,
              text: "Farbe konnte nicht geändert werden.",
            );
          } catch (e, s) {
            showSnackSec(
              context: context,
              text: handleErrorMessage('$e', s),
            );
          }
        }
      }
    }
  }
}
