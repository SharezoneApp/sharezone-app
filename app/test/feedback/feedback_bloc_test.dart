// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:random_string/random_string.dart' as random;
import 'package:sharezone/feedback/src/analytics/feedback_analytics.dart';
import 'package:sharezone/feedback/src/bloc/feedback_bloc.dart';
import 'package:sharezone/feedback/src/cache/cooldown_exception.dart';
import 'package:sharezone/feedback/src/cache/feedback_cache.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

import 'mock_feedback_api.dart';
import 'mock_platform_information_retreiver.dart';

const rating = 5.0;
const likes = "likes";
const dislikes = "dislikes";
const missing = "missing";
const heardFrom = "heardFrom";
const uid = "uidABCDEF123891a";
const contactInfo = "Instagram: @jsan_l";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("Feedback tests", () {
    MockFeedbackApi api;
    ClearableFeedbackCache cache;
    MockPlatformInformationRetreiver platformInformationRetreiver;
    FeedbackBloc bloc;
    UserFeedback expectedResponseWithIdentifiableInfo;
    UserFeedback expectedAnonymousResponse;
    MockFeedbackAnalytics analytics;

    setUp(() {
      api = MockFeedbackApi();
      cache = ClearableFeedbackCache(InMemoryKeyValueStore());
      platformInformationRetreiver = MockPlatformInformationRetreiver();
      analytics = MockFeedbackAnalytics();
      bloc = FeedbackBloc(
          api, cache, platformInformationRetreiver, uid, analytics);
      platformInformationRetreiver.appName = "appName";
      platformInformationRetreiver.packageName = "packageName";

      expectedResponseWithIdentifiableInfo = UserFeedback.create().copyWith(
          rating: rating,
          likes: likes,
          dislikes: dislikes,
          missing: missing,
          heardFrom: heardFrom,
          uid: uid,
          userContactInformation: contactInfo,
          deviceInformation: FeedbackDeviceInformation.create().copyWith(
            appName: "appName",
            packageName: "packageName",
          ));

      expectedAnonymousResponse = UserFeedback.create().copyWith(
        rating: rating,
        likes: likes,
        dislikes: dislikes,
        missing: missing,
        heardFrom: heardFrom,
        uid: "",
        userContactInformation: "",
        deviceInformation: null,
      );
    });

    test(
        "Feedback is send with no identifiable information if the anonymous option is enable",
        () async {
      fillInAllFields(bloc);
      bloc.changeIsAnonymous(true);

      await bloc.submit();

      expect(api.wasOnlyInvokedWith(expectedAnonymousResponse), true);
    });
    test(
        "Feedback is send with uid, contact and device information, when not anonymous",
        () async {
      writeRdmValues(bloc);
      fillInAllFields(bloc);

      await bloc.submit();

      expect(
          api.wasOnlyInvokedWith(expectedResponseWithIdentifiableInfo), true);
    });

    test("submit does not call API if user is on cooldown", () async {
      await cache.setLastSubmit();

      writeRdmValues(bloc);

      expect(bloc.submit(), throwsA(isInstanceOf<CooldownException>()));
      expect(api.wasInvoked, false);
    });

    test("submit does call API if user is not on cooldown", () async {
      writeRdmValues(bloc);

      await bloc.submit();

      expect(api.wasInvoked, true);
    });

    test('"feedback send" analytics is logged when sending a valid feedback',
        () async {
      fillInAllFields(bloc);

      await bloc.submit();

      expect(analytics.feedbackSentLogged, true);
    });

    test(
        'submits Feedback if at least one of the text fields (except contact info) was filled out',
        () async {
      final fillOutTextFieldActions = [
        [() => bloc.changeLike('Sehr toller Hecht hier'), 'Mag ich'],
        [() => bloc.changeDislike('Nisch so legga'), 'Mag ich nicht'],
        [
          () => bloc.changeHeardFrom(
              'Von dem einem sein Freund dessen Oma dessen Schwester dessen Tochter'),
          'Von wo von Sharezone erfahren?'
        ],
        [
          () => bloc.changeMissing('Automatischer Ausredengenerator'),
          'Was fehlt?'
        ],
      ];

      // Hier wird jedes Textfeld einmal einzelnt ausgefüllt und geguckt, ob
      // dann ein Feedback an uns geschickt wird.
      // Nach jedem Ausfüllen und Abschicken eines einzelnen Textfeldes werden
      // diese gecleared und das nächste Textfeld ist dann an der Reihe.
      int nrOfInvocations = 0;
      for (final action in fillOutTextFieldActions) {
        final fillTextField = action[0] as Function;
        final textFieldName = action[1] as String;

        await fillTextField();
        try {
          await bloc.submit();
        } catch (e) {
          fail(
              'Error: Feedback should be submittable/sent if only the text field "$textFieldName" was filled out, but an error was thrown instead: $e');
        }

        final wasFeedbackSent = nrOfInvocations + 1 == api.invocations.length;
        expect(wasFeedbackSent, true,
            reason:
                'Feedback should be submittable/sent if only the text field "$textFieldName" was filled out.');

        bloc.clearFeedbackBox();
        await cache.clearCache();
        nrOfInvocations++;
      }
    });

    test(
        'throws EmptyFeedbackException if all fields are empty (only spaces/newlines)',
        () async {
      // Arrange
      bloc.changeLike('   ');
      bloc.changeDislike(' \n  \n\n ');

      // Act
      void exec() => bloc.submit();

      // Assert
      expect(exec, throwsA(isA<EmptyFeedbackException>()));
      expect(api.wasInvoked, false);
    });

    test(
        'throws EmptyFeedback if only a rating is given but no text was filled in',
        () {
      // Arrange
      bloc.changeRating(3);

      // Act
      void exec() => bloc.submit();

      // Assert
      expect(exec, throwsA(isA<EmptyFeedbackException>()));
      expect(api.wasInvoked, false);
    });

    test('throws EmptyFeedback if only contact info is given', () {
      // Arrange
      bloc.changeContactOptions('Twitter: @realdonaldtrump 🐒');

      // Act
      void exec() => bloc.submit();

      // Assert
      expect(exec, throwsA(isA<EmptyFeedbackException>()));
      expect(api.wasInvoked, false);
    });
  });
}

class MockFeedbackAnalytics implements FeedbackAnalytics {
  @override
  void logOpenRatingOfThankYouSheet() {}

  bool feedbackSentLogged = false;
  @override
  void logSendFeedback() {
    feedbackSentLogged = true;
  }

  @override
  void dispose() {}
}

class ClearableFeedbackCache extends FeedbackCache {
  final KeyValueStore _cache;

  ClearableFeedbackCache(this._cache) : super(_cache);

  Future<void> clearCache() {
    return _cache.clear();
  }
}

void fillInAllFields(FeedbackBloc bloc) {
  bloc.changeRating(rating);
  bloc.changeLike(likes);
  bloc.changeDislike(dislikes);
  bloc.changeMissing(missing);
  bloc.changeHeardFrom(heardFrom);
  bloc.changeIsAnonymous(false);
  bloc.changeContactOptions(contactInfo);
}

void writeRdmValues(FeedbackBloc bloc) {
  bloc.changeRating(random.randomBetween(1, 5).toDouble());
  bloc.changeLike(random.randomString(10));
  bloc.changeDislike(random.randomString(10));
  bloc.changeMissing(random.randomString(10));
  bloc.changeHeardFrom(random.randomString(10));
  bloc.changeContactOptions(random.randomString(10));
}
