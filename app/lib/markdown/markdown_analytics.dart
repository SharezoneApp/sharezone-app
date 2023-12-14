// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:helper_functions/helper_functions.dart';

class MarkdownAnalytics extends BlocBase {
  final Analytics _analytics;

  MarkdownAnalytics(this._analytics);

  void logMarkdownUsedHomework() {
    _analytics.log(MarkdownUsedEvent(feature: 'homework'));
  }

  void logMarkdownUsedBlackboard() {
    _analytics.log(MarkdownUsedEvent(feature: 'blackboard'));
  }

  void logMarkdownUsedEvent() {
    _analytics.log(MarkdownUsedEvent(feature: 'event'));
  }

  /// Prüft, die meistgenutzten Elemente von Markdown im [text]
  /// enthalten.
  bool containsMarkdown(String? text) {
    if (text != null) {
      return text.contains(RegExp(r'[*\_]{2,}|\`|\#'));
    }
    return false;
  }

  @override
  void dispose() {}
}

class MarkdownUsedEvent extends AnalyticsEvent {
  MarkdownUsedEvent({required this.feature})
      : assert(isNotEmptyOrNull(feature)),
        super('markdown_used');

  final String feature;

  @override
  Map<String, dynamic> get data => {"feature": feature};
}
