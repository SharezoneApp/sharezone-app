// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'upload_task_snapshot.dart';
import 'upload_task_type.dart';

class UploadTaskEvent {
  final UploadTaskSnapshot snapshot;
  final UploadTaskEventType type;
  const UploadTaskEvent({
    this.snapshot,
    this.type,
  });
}
