// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:notifications/notifications.dart';

/// An [ActionRequest] encapsulates the request for something to happen when the
/// user interacts with a [PushNotification].
///
/// An [ActionRequest] object does not have any behavior in of itself except
/// ensuring that the data is valid (see example).
///
/// E.g.: A [PushNotification] is received that read "Homework XYZ was edited".
/// The accompanying [ActionRequest] might be called `ShowHomeworkRequest` which
/// will show the edited homework to the user when he taps on that notification.
/// The `ShowHomeworkRequest` class validates that the homework id that was
/// parsed from the [PushNotification] is valid (non-empty string).
///
/// [ActionRequest] is the input for [ActionRegistration.executeActionRequest]
/// which really executes the action in the end (e.g. navigates to a page
/// showing the homework).
abstract class ActionRequest extends Equatable {
  /// If [Equatable] should generate toString automatically.
  @override
  bool get stringify => true;
}
