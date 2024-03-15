import 'package:sharezone/grades/models/term_id.dart';
import 'package:sharezone/grades/pages/term_details_page/term_details_page_controller.dart';

class TermDetailsPageControllerFactory {
  const TermDetailsPageControllerFactory();

  TermDetailsPageController create(TermId termId) {
    return TermDetailsPageController(termId: termId);
  }
}
