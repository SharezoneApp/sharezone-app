// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2


import 'package:sharezone/feedback/src/models/user_feedback.dart';

// ignore: one_member_abstracts
abstract class FeedbackApi {
  Future<void> sendFeedback(UserFeedback feedback);
}
