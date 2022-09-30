// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:rxdart/rxdart.dart';

class TwoStreamSnapshot<T0 extends Object?, T1 extends Object?> {
  final T0? data0;
  final T1? data1;

  const TwoStreamSnapshot(this.data0, this.data1);
}

class TwoStreams<T0 extends Object, T1 extends Object> {
  final Stream<T0?> stream0;
  final Stream<T1?> stream1;

  TwoStreams(this.stream0, this.stream1);

  Stream<TwoStreamSnapshot<T0?, T1?>> get stream {
    return CombineLatestStream([stream0, stream1], (snapshots) {
      return TwoStreamSnapshot(snapshots[0] as T0?, snapshots[1] as T1?);
    });
  }
}
