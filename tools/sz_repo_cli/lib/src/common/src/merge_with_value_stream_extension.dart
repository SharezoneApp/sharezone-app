// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:rxdart/rxdart.dart';

extension MergeWithValueExtension<T> on Stream<T> {
  Stream<T> mergeWithValue(T value) => mergeWith([Stream.value(value)]);
  Stream<T> mergeWithValues(List<T> values) =>
      mergeWith([for (final value in values) Stream.value(value)]);
}
