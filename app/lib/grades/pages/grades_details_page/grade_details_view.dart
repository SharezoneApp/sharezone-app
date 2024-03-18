import 'package:equatable/equatable.dart';

class GradeDetailsView extends Equatable {
  final String gradeValue;
  final String gradingSystem;
  final String subjectDisplayName;
  final String date;
  final String gradeType;
  final String termDisplayName;
  final bool? integrateGradeIntoSubjectGrade;
  final String? topic;
  final String? details;

  const GradeDetailsView({
    required this.gradeValue,
    required this.gradingSystem,
    required this.subjectDisplayName,
    required this.date,
    required this.gradeType,
    required this.termDisplayName,
    this.integrateGradeIntoSubjectGrade,
    this.topic,
    this.details,
  });

  @override
  List<Object?> get props => [
        gradeValue,
        gradingSystem,
        subjectDisplayName,
        date,
        gradeType,
        termDisplayName,
        integrateGradeIntoSubjectGrade,
        topic,
        details,
      ];
}
