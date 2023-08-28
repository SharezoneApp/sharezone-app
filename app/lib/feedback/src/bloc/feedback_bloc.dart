// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/feedback/src/analytics/feedback_analytics.dart';
import 'package:sharezone/feedback/src/api/feedback_api.dart';
import 'package:sharezone/feedback/src/cache/cooldown_exception.dart';
import 'package:sharezone/feedback/src/cache/feedback_cache.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';
import 'package:sharezone/util/platform_information_manager/platform_information_retreiver.dart';

class FeedbackBloc extends BlocBase {
  /// The time between successful feedback submissions that has to been exceeded,
  /// before another feedback can be submitted.
  static const Duration feedbackCoolDown = Duration(seconds: 30);

  final FeedbackApi _api;
  final FeedbackCache _cache;
  final FeedbackAnalytics feedbackAnalytics;
  final PlatformInformationRetriever _platformInformationRetriever;
  final String uid;

  final _ratingSubject = BehaviorSubject<double?>();
  final _likeSubject = BehaviorSubject<String?>();
  final _dislikeSubject = BehaviorSubject<String?>();
  final _missingSubject = BehaviorSubject<String?>();
  final _heardFromSubject = BehaviorSubject<String?>();
  final _isAnonymousSubject = BehaviorSubject.seeded(false);
  final _contactOptions = BehaviorSubject<String?>();

  FeedbackBloc(this._api, this._cache, this._platformInformationRetriever,
      this.uid, this.feedbackAnalytics) {
    isAnonymous = _isAnonymousSubject.stream;
  }

  Function(double?) get changeRating => _ratingSubject.sink.add;
  Function(String?) get changeLike => _likeSubject.sink.add;
  Function(String?) get changeDislike => _dislikeSubject.sink.add;
  Function(String?) get changeMissing => _missingSubject.sink.add;
  Function(String?) get changeHeardFrom => _heardFromSubject.sink.add;
  Function(bool) get changeIsAnonymous => _isAnonymousSubject.sink.add;
  Function(String?) get changeContactOptions => _contactOptions.sink.add;

  ValueStream<double?> get rating => _ratingSubject;
  ValueStream<String?> get like => _likeSubject;
  ValueStream<String?> get dislike => _dislikeSubject;
  ValueStream<String?> get missing => _missingSubject;
  ValueStream<String?> get heardFrom => _heardFromSubject;
  ValueStream<String?> get contactOptions => _contactOptions;

  /// Whether the user wants to remain anonymous.
  /// Defaults to false.
  late Stream<bool> isAnonymous;

  /// Submits the feedback given to the [FeedbackApi].
  ///
  /// Will add uid, contact information and platform information to the
  /// [UserFeedback] as long as [changeIsAnonymous] was not passed true as the
  /// latest value.
  /// platform information will be read from the [PlatformInformationRetriever].
  ///
  /// Throws a [CoolDownException] if
  /// [FeedbackCache.hasFeedbackSubmissionCoolDown] returns true.
  ///
  /// Throws an [EmptyFeedbackException] if no values (or only whitespace) have
  /// been given per [changeLike], [changeDislike], [changeMissing],
  /// [changeHeardFrom] - this is done by checking
  /// [UserFeedback.requiredUserInputIsEmpty].
  Future<void> submit() async {
    final isOnCoolDown =
        await _cache.hasFeedbackSubmissionCoolDown(feedbackCoolDown);
    if (isOnCoolDown)
      throw CoolDownException(
          "User has not yet exceeded the cool down.", feedbackCoolDown);

    final isAnonymous = _isAnonymousSubject.valueOrNull!;

    final rating = _ratingSubject.valueOrNull;
    final likes = _likeSubject.valueOrNull;
    final dislikes = _dislikeSubject.valueOrNull;
    final missing = _missingSubject.valueOrNull;
    final heardFrom = _heardFromSubject.valueOrNull;
    final uid = isAnonymous ? "" : this.uid;
    final userContactInformation =
        isAnonymous ? "" : _contactOptions.valueOrNull;

    await _platformInformationRetriever.init();

    final deviceInfo = FeedbackDeviceInformation.create().copyWith(
      appName: _platformInformationRetriever.appName,
      packageName: _platformInformationRetriever.packageName,
      versionName: _platformInformationRetriever.version,
      versionNumber: _platformInformationRetriever.versionNumber,
    );

    final feedback = UserFeedback.create().copyWith(
      rating: rating,
      likes: likes,
      dislikes: dislikes,
      missing: missing,
      heardFrom: heardFrom,
      uid: uid,
      userContactInformation: userContactInformation,
      deviceInformation: isAnonymous ? null : deviceInfo,
    );

    if (feedback.requiredUserInputIsEmpty) throw EmptyFeedbackException();
    await _api.sendFeedback(feedback);
    _logSendFeedback();
    await _cache.setLastSubmit();
  }

  void _logSendFeedback() {
    feedbackAnalytics.logSendFeedback();
  }

  /// Clears all Fields of the Feedback-Box
  void clearFeedbackBox() {
    changeRating(null);
    changeDislike(null);
    changeMissing(null);
    changeLike(null);
    changeHeardFrom(null);
    changeContactOptions(null);
    changeIsAnonymous(false);
  }

  @override
  void dispose() {
    _contactOptions.close();
    _dislikeSubject.close();
    _heardFromSubject.close();
    _isAnonymousSubject.close();
    _likeSubject.close();
    _missingSubject.close();
    _ratingSubject.close();
  }
}

class EmptyFeedbackException implements Exception {
  @override
  String toString() => "EmptyFeedbackException";
}
