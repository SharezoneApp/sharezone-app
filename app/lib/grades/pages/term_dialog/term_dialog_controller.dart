import 'package:flutter/foundation.dart';

class TermDialogController extends ChangeNotifier {
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
