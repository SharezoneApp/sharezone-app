import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/feedback/src/analytics/feedback_analytics.dart';
import 'package:sharezone/feedback/src/api/feedback_api.dart';
import 'package:sharezone/feedback/src/cache/cooldown_exception.dart';
import 'package:sharezone/feedback/src/cache/feedback_cache.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';
import 'package:sharezone/util/platform_information_manager/platform_information_retreiver.dart';

class FeedbackBloc extends BlocBase {
  /// The time between successful feedback submissions that has to been exeeded,
  /// before another feedback can be submitted.
  static const Duration feedbackCooldown = Duration(seconds: 30);

  final FeedbackApi _api;
  final FeedbackCache _cache;
  final FeedbackAnalytics feedbackAnalytics;
  final PlatformInformationRetreiver _platformInformationRetreiver;
  final String uid;

  final _ratingSubject = BehaviorSubject<double>();
  final _likeSubject = BehaviorSubject<String>();
  final _dislikeSubject = BehaviorSubject<String>();
  final _missingSubject = BehaviorSubject<String>();
  final _heardFromSubject = BehaviorSubject<String>();
  final _isAnonymousSubject = BehaviorSubject.seeded(false);
  final _contactOptions = BehaviorSubject<String>();

  FeedbackBloc(this._api, this._cache, this._platformInformationRetreiver,
      this.uid, this.feedbackAnalytics) {
    isAnonymous = _isAnonymousSubject.stream;
  }

  Function(double) get changeRating => _ratingSubject.sink.add;
  Function(String) get changeLike => _likeSubject.sink.add;
  Function(String) get changeDislike => _dislikeSubject.sink.add;
  Function(String) get changeMissing => _missingSubject.sink.add;
  Function(String) get changeHeardFrom => _heardFromSubject.sink.add;
  Function(bool) get changeIsAnonymous => _isAnonymousSubject.sink.add;
  Function(String) get changeContactOptions => _contactOptions.sink.add;

  ValueStream<double> get raiting => _ratingSubject;
  ValueStream<String> get like => _likeSubject;
  ValueStream<String> get dislike => _dislikeSubject;
  ValueStream<String> get missing => _missingSubject;
  ValueStream<String> get heardFrom => _heardFromSubject;
  ValueStream<String> get contactOptions => _contactOptions;

  /// Whether the user wants to remain anonymous.
  /// Defaults to false.
  Stream<bool> isAnonymous;

  /// Submits the feedback given to the [FeedbackApi].
  ///
  /// Will add uid, contact information and platform information to the
  /// [UserFeedback] as long as [changeIsAnonymous] was not passed true as the
  /// latest value.
  /// platform information will be read from the [PlatformInformationRetreiver].
  ///
  /// Throws a [CooldownException] if
  /// [FeedbackCache.hasFeedbackSubmissionCooldown] returns true.
  ///
  /// Throws an [EmptyFeedbackException] if no values (or only whitespace) have
  /// been given per [changeLike], [changeDislike], [changeMissing],
  /// [changeHeardFrom] - this is done by checking
  /// [UserFeedback.requiredUserInputIsEmpty].
  Future<void> submit() async {
    final isOnCooldown =
        await _cache.hasFeedbackSubmissionCooldown(feedbackCooldown);
    if (isOnCooldown)
      throw CooldownException(
          "User has not yet exeeded the cooldown.", feedbackCooldown);

    final isAnonymous = _isAnonymousSubject.valueOrNull;

    final rating = _ratingSubject.valueOrNull;
    final likes = _likeSubject.valueOrNull;
    final dislikes = _dislikeSubject.valueOrNull;
    final missing = _missingSubject.valueOrNull;
    final heardFrom = _heardFromSubject.valueOrNull;
    final uid = isAnonymous ? "" : this.uid;
    final userContactInformation =
        isAnonymous ? "" : _contactOptions.valueOrNull;

    await _platformInformationRetreiver.init();

    final deviceInfo = FeedbackDeviceInformation.create().copyWith(
      appName: _platformInformationRetreiver.appName,
      packageName: _platformInformationRetreiver.packageName,
      versionName: _platformInformationRetreiver.version,
      versionNumber: _platformInformationRetreiver.versionNumber,
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
