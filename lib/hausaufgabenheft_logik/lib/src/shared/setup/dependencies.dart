// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/src/shared/homework_page_api.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class HausaufgabenheftDependencies {
  final HomeworkPageApi api;

  final KeyValueStore keyValueStore;

  final SharezoneLocalizations localizations;

  final DateTime Function()? getCurrentDateTime;

  /// Optional filter stream for course IDs. If provided and non-empty, homework
  /// lists will only include items from the given course IDs.
  final Stream<ISet<CourseId>>? courseFilterStream;

  HausaufgabenheftDependencies({
    required this.api,
    required this.keyValueStore,
    required this.localizations,
    this.getCurrentDateTime,
    this.courseFilterStream,
  });
}
