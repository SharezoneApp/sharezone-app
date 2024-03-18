import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller.dart';
import 'package:sharezone/grades/pages/shared/saved_grade_id.dart';

class GradeDetailsPageControllerFactory {
  GradeDetailsPageController create(SavedGradeId id) {
    return GradeDetailsPageController(id: id);
  }
}
