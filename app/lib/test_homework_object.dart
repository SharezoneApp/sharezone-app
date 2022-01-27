// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';

class TestHomeworkObject {
  static HomeworkDto ha1 =
      HomeworkDto.create(courseReference: null, courseID: "").copyWith(
          id: "ABC",
          subject: "Geschichte",
          subjectAbbreviation: "GE",
          title: "Geschichtshausaufgabe",
          todoUntil: DateTime.now(),
          forUsers: {"UserID": true});

  static HomeworkDto generateRandomHomework() {
    print(_randomString(10));
    HomeworkDto ha = HomeworkDto.create(courseReference: null, courseID: "")
        .copyWith(
            id: _randomString(15),
//    ..reference = Firestore.instance.doc(_randomString(15)),
            subject: _randomString(8),
            subjectAbbreviation: _randomString(3),
            title: _randomString(10),
            todoUntil: DateTime.now(),
            forUsers: {
          "fhtyXj1VhkXNIOA1lfmMUbTV8Yo1": _randomString(1).codeUnitAt(0).isEven
        });
    return ha;
  }

  static String _randomString(int length) {
    var rand = Random();
    var codeUnits = List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return String.fromCharCodes(codeUnits);
  }
}
