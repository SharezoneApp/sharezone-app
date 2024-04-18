import 'package:equatable/equatable.dart';

class SubjectSettingsPageView extends Equatable {
  final String subjectName;
  final String finalGradeTypeDisplayName;

  const SubjectSettingsPageView({
    required this.subjectName,
    required this.finalGradeTypeDisplayName,
  });

  @override
  List<Object?> get props => [subjectName, finalGradeTypeDisplayName];
}
