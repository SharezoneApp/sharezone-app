// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:sharezone_common/validators.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

mixin SchoolClassValidators {
  SharezoneLocalizations get l10n;

  late final StreamTransformer<String, String> validateName =
      StreamTransformer<String, String>.fromHandlers(
        handleData: (name, sink) {
          if (NotEmptyOrNullValidator(name).isValid()) {
            sink.add(name);
          } else {
            sink.addError(l10n.commonErrorNameMissing);
          }
        },
      );
}
