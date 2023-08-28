// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:analytics/analytics.dart';
import 'package:sharezone_common/helper_functions.dart';

import 'comments_gateway.dart';

class CommentsAnalytics {
  final Analytics _analytics;

  CommentsAnalytics(this._analytics);

  void logCommentAdded(CommentLocation location) {
    _analytics.log(_CommentsUsedEvent(
        feature: location.baseCollection, action: _CommentAcition.add));
  }

  void logCommentDeleted(CommentLocation location) {
    _analytics.log(_CommentsUsedEvent(
        feature: location.baseCollection, action: _CommentAcition.delete));
  }
}

enum _CommentAcition { add, delete }

class _CommentsUsedEvent extends AnalyticsEvent {
  _CommentsUsedEvent({required this.feature, required _CommentAcition action})
      : assert(isNotEmptyOrNull(feature)),
        super('comment_${enumToString(action)}_');

  final String feature;

  @override
  Map<String, dynamic> get data => {"feature": feature};
}
