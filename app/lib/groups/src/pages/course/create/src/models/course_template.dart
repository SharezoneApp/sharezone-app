import 'package:group_domain_models/group_domain_models.dart';

class CourseTemplate {
  final String subject;
  final String abbreviation;

  Course toCourse() {
    return Course.create()
        .copyWith(subject: subject, abbreviation: abbreviation);
  }

  const CourseTemplate(this.subject, this.abbreviation);
}
