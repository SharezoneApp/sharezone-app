import 'package:flutter/foundation.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

class TermDialogController extends ChangeNotifier {
  final GradesService gradesService;
  TermDialogController(this.gradesService);

  String termName = '';

  void setTermName(String value) {
    termName = value;
    notifyListeners();
  }

  Future<void> createTerm() async {
    await Future.delayed(Duration.zero);
    return;
  }
}
