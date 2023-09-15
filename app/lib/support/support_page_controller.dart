// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
