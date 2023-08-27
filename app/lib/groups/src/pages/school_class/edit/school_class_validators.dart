// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'dart:async';

import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/validators.dart';

class SchoolClassValidators {
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (NotEmptyOrNullValidator(name).isValid()) {
      sink.add(name);
    } else {
      sink.addError(EmptyNameException().toString());
    }
  });
}
