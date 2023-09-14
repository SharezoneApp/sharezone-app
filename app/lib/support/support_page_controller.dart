import 'dart:async';

import 'package:flutter/material.dart';

class SupportPageController extends ChangeNotifier {
  bool isUserSignedIn = false;
  late StreamSubscription<bool> _isUserSignedInSubscription;

  SupportPageController(Stream<bool> isUserSignedInStream) {
    _isUserSignedInSubscription = isUserSignedInStream.listen((isUserSignedIn) {
      this.isUserSignedIn = isUserSignedIn;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _isUserSignedInSubscription.cancel();
    super.dispose();
  }
}
