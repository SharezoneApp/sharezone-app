// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/shared/homework_page_api.dart';
import 'package:key_value_store/key_value_store.dart';

class HausaufgabenheftDependencies {
  final HomeworkPageApi api;

  final KeyValueStore keyValueStore;

  final DateTime Function()? getCurrentDateTime;

  HausaufgabenheftDependencies({
    required this.api,
    required this.keyValueStore,
    this.getCurrentDateTime,
  });
}
