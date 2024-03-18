import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_view.dart';
import 'package:sharezone/grades/pages/shared/saved_grade_id.dart';

class GradeDetailsPageController extends ChangeNotifier {
  final SavedGradeId id;

  GradeDetailsPageState state = const GradeDetailsPageLoading();

  late StreamSubscription<GradeDetailsView> _gradeDetailsSubscription;
  GradeDetailsPageController({
    required this.id,
  }) {
    const dummyValue = GradeDetailsView(
      gradeValue: '5',
      gradingSystem: '5-Point',
      subjectDisplayName: 'Math',
      date: '2021-09-01',
      gradeType: 'Test',
      termDisplayName: '1st Term',
      integrateGradeIntoSubjectGrade: true,
      topic: 'Algebra',
      details: 'This is a test grade for algebra.',
    );
    Stream.value(dummyValue).listen((grade) {
      state = GradeDetailsPageLoaded(grade);
      notifyListeners();
    }, onError: (error) {
      state = GradeDetailsPageError(error.toString());
      notifyListeners();
    });
  }

  void deleteGrade() {
    // todo: delete grade with gateway
  }

  @override
  void dispose() {
    _gradeDetailsSubscription.cancel();
    super.dispose();
  }
}

sealed class GradeDetailsPageState {
  const GradeDetailsPageState();
}

class GradeDetailsPageLoading extends GradeDetailsPageState {
  const GradeDetailsPageLoading();
}

class GradeDetailsPageError extends GradeDetailsPageState {
  final String message;

  const GradeDetailsPageError(this.message);
}

class GradeDetailsPageLoaded extends GradeDetailsPageState {
  final GradeDetailsView view;

  const GradeDetailsPageLoaded(this.view);
}
