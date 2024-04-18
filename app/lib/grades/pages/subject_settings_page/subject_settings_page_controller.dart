import 'package:flutter/material.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/models/subject_id.dart';
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page_view.dart';

class SubjectSettingsPageController extends ChangeNotifier {
  final GradesService gradesService;
  final SubjectId subjectId;

  SubjectSettingsPageController({
    required this.subjectId,
    required this.gradesService,
  }) {
    final subject = gradesService.getSubject(subjectId);
  }

  SubjectSettingsPageView get view {
    return const SubjectSettingsPageView(
      subjectName: 'Math',
      finalGradeTypeDisplayName: 'Final Grade',
    );
  }
}
