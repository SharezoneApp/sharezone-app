// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/dashboard/models/homework_view.dart';
import 'package:sharezone/homework/homework_details/homework_details.dart';
import 'package:sharezone/homework/homework_details/homework_details_view_factory.dart';
import 'package:sharezone/submissions/homework_create_submission_page.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone/widgets/homework/homework_card.dart';
import 'package:sharezone/widgets/homework/homework_tile_template.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

enum HomeworkStatus { open, completed }

typedef StatusChangeCallback = void Function(HomeworkStatus newStatus);

class HomeworkTile extends StatefulWidget {
  final StudentHomeworkView homework;
  final StatusChangeCallback onChanged;

  const HomeworkTile({
    Key? key,
    required this.homework,
    required this.onChanged,
  }) : super(key: key);

  @override
  State createState() => _HomeworkTileState();
}

class _HomeworkTileState extends State<HomeworkTile> {
  late bool isCompleted;

  @override
  void initState() {
    isCompleted = widget.homework.isCompleted;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeworkTileTemplate(
      title: widget.homework.title,
      trailing: widget.homework.withSubmissions
          ? _SubmissionUploadButton(
              onPressed: () => _navigateToSubmissionPage(context),
            )
          : _Checkbox(
              isHomeworkCompleted: widget.homework.isCompleted,
              onCompletionChange: _changeCompletionState,
            ),
      courseName: widget.homework.subject,
      courseAbbreviation: widget.homework.abbreviation,
      courseColor: Color(widget.homework.subjectColor.value),
      todoDate: widget.homework.todoDate,
      todoDateColor: widget.homework.colorDate
          ? Colors.redAccent
          : Theme.of(context).textTheme.bodyMedium!.color,
      onTap: () => _showHomeworkDetails(context),
      onLongPress: () => _showLongPressDialog(context),
      key: Key(widget.homework.id),
    );
  }

  void _changeCompletionState(bool? newCompletionState) {
    if (newCompletionState == null) return;

    /// [mounted] prüft, dass das Widget noch im Widget-Tree ist. Es ist ein Fehler
    /// [setState] aufzurufen, falls [mounted] `false` ist.
    ///
    /// Nach schwacher Erinnerung wurde dies eingabut, weil es eine
    /// Race-Condition zwischen verschwinden der Hausaufgabe im Hausaufgaben-Tab
    /// und der Abhak-Animation dieser Hausaufgabe (bzw. der Checkbox) gab, wo
    /// die Animation noch nach dem Entfernen des Widgets aus dem Tree spielte
    /// bzw. spielen wollte (was ein Fehler ist).
    ///
    /// Ich (Jonas) bin mir allerdings nicht sicher, inwieweit die Begründung
    /// wirklich stimmt oder ob sie noch korrekt ist.
    if (mounted) {
      setState(() {
        isCompleted = newCompletionState;
      });
    }

    widget.onChanged(
        isCompleted ? HomeworkStatus.completed : HomeworkStatus.open);
  }

  Future<void> _navigateToSubmissionPage(BuildContext context) {
    return Navigator.push(
      context,
      IgnoreWillPopScopeWhenIosSwipeBackRoute(
        builder: (_) => HomeworkUserCreateSubmissionPage(
          homeworkId: widget.homework.id,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<bool> _showHomeworkDetails(BuildContext context) async {
    final detailsViewFactory =
        BlocProvider.of<HomeworkDetailsViewFactory>(context);
    final homeworkDetailsView =
        await detailsViewFactory.fromStudentHomeworkView(widget.homework);
    if (!context.mounted) return false;

    return pushWithDefault<bool>(
      context,
      HomeworkDetails(homeworkDetailsView),
      defaultValue: false,
      name: HomeworkDetails.tag,
    );
  }

  Future<void> _showLongPressDialog(BuildContext context) async {
    final dbModel = await getHomeworkDbModel(widget.homework);
    if (!context.mounted) return;
    final courseGateway = BlocProvider.of<SharezoneContext>(context).api.course;
    await showLongPressIfUserHasPermissions(
      context,
      (newStatus) => widget.onChanged(
          newStatus ? HomeworkStatus.completed : HomeworkStatus.open),
      HomeworkView.fromHomework(dbModel, courseGateway),
    );
  }

  /// Lädt das HomeworkDbModel, weil ein paar Funktionen noch dieses verlangen.
  Future<HomeworkDto> getHomeworkDbModel(
      StudentHomeworkView homeworkView) async {
    final CollectionReference<Map<String, dynamic>> homeworkCollection =
        FirebaseFirestore.instance.collection("Homework");

    final homeworkId = homeworkView.id;
    final homeworkDocument = await homeworkCollection.doc(homeworkId).get();
    final homework =
        HomeworkDto.fromData(homeworkDocument.data()!, id: homeworkDocument.id);
    return homework;
  }
}

class _SubmissionUploadButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmissionUploadButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.file_upload),
      onPressed: onPressed,
    );
  }
}

class _Checkbox extends StatelessWidget {
  final bool isHomeworkCompleted;
  final void Function(bool? isCompleted) onCompletionChange;

  const _Checkbox({
    Key? key,
    required this.isHomeworkCompleted,
    required this.onCompletionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final analytics = AnalyticsProvider.ofOrNullObject(context);
    return Checkbox(
      value: isHomeworkCompleted,
      onChanged: (isCompleted) async {
        if (isCompleted!) {
          analytics.log(const AnalyticsEvent("homework_done"));
        } else {
          analytics.log(const AnalyticsEvent("homework_undone"));
        }
        onCompletionChange(isCompleted);
      },
    );
  }
}
