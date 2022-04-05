// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'upload_task_event.dart';
import 'upload_task_snapshot.dart';

class UploadTask {
  /// Returns [UploadTaskSnapshot] if this [UploadTask] is finished wiht uploading.
  final Future<UploadTaskSnapshot> onComplete;

  /// Returns a [Stream] of [UploadTaskEvent] events.
  ///
  /// If the task is canceled or fails, the stream will send an error event.
  /// See [UploadTaskEventType] for more information of the different event types.
  ///
  /// If you do not need to know about on-going stream events, you can instead
  /// await this [UploadTask] directly.
  final Stream<UploadTaskEvent> events;

  const UploadTask({
    this.onComplete,
    this.events,
  });
}
