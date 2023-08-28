// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:sharezone_common/helper_functions.dart';

import 'comments_gateway.dart';

class CommentsAnalytics {
  final Analytics _analytics;

  CommentsAnalytics(this._analytics);

  void logCommentAdded(CommentsLocation location) {
    _analytics.log(_CommentsUsedEvent(
        feature: location.baseCollection, action: _CommentAction.add));
  }

  void logCommentDeleted(CommentLocation location) {
    _analytics.log(_CommentsUsedEvent(
        feature: location.baseCollection, action: _CommentAction.delete));
  }
}

enum _CommentAction { add, delete }

class _CommentsUsedEvent extends AnalyticsEvent {
  _CommentsUsedEvent({required this.feature, required _CommentAction action})
      : assert(isNotEmptyOrNull(feature)),
        super('comment_${action.name}_');

  final String feature;

  @override
  Map<String, dynamic> get data => {"feature": feature};
}
