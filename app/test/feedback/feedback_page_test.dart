// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:random_string/random_string.dart' as random;
import 'package:sharezone/feedback/feedback_box_page.dart';
import 'package:sharezone/feedback/src/bloc/feedback_bloc.dart';
import 'package:sharezone/feedback/src/cache/cooldown_exception.dart';
import 'package:sharezone/feedback/src/cache/feedback_cache.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

import 'feedback_bloc_test.dart';
import 'mock_feedback_api.dart';
import 'mock_platform_information_retreiver.dart';

const likes = "likes";
const dislikes = "dislikes";
const missing = "missing";
const heardFrom = "heardFrom";
const uid = "uidABCDEF123891a";
const contactInfo = "Instagram: @jsan_l";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("Feedback tests", () {
    late MockFeedbackApi api;
    late FeedbackCache cache;
    MockPlatformInformationRetriever platformInformationRetriever;
    late FeedbackBloc bloc;
    UserFeedback? expectedResponseWithIdentifiableInfo;
    UserFeedback? expectedAnonymousResponse;

    setUp(() {
      api = MockFeedbackApi();
      cache = FeedbackCache(InMemoryKeyValueStore());
      platformInformationRetriever = MockPlatformInformationRetriever();
      bloc = FeedbackBloc(api, cache, platformInformationRetriever, uid,
          MockFeedbackAnalytics());
      platformInformationRetriever.appName = "appName";
      platformInformationRetriever.packageName = "packageName";

      expectedResponseWithIdentifiableInfo = UserFeedback.create().copyWith(
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
        likes: likes,
        dislikes: dislikes,
        missing: missing,
        heardFrom: heardFrom,
        uid: "",
        userContactInformation: "",
        deviceInformation: null,
      );
    });

    tearDown(() {
      bloc.dispose();
    });

    Future<void> _pumpFeedbackPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BlocProvider(
              bloc: bloc,
              child: FeedbackPageBody(),
            ),
          ),
        ),
      );
    }

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

      expect(bloc.submit(), throwsA(isA<CoolDownException>()));
      expect(api.wasInvoked, false);
    });

    test("submit does call API if user is not on cooldown", () async {
      writeRdmValues(bloc);

      await bloc.submit();

      expect(api.wasInvoked, true);
    });

    testWidgets('prefills the textfields from last draft', (tester) async {
      fillInAllFields(bloc);

      await _pumpFeedbackPage(tester);
      await tester.pump();

      expect(find.text(likes), findsOneWidget);
      expect(find.text(dislikes), findsOneWidget);
      expect(find.text(missing), findsOneWidget);
      expect(find.text(heardFrom), findsOneWidget);
      expect(find.text(contactInfo), findsOneWidget);
    });
  });
}

void fillInAllFields(FeedbackBloc bloc) {
  bloc.changeLike(likes);
  bloc.changeDislike(dislikes);
  bloc.changeMissing(missing);
  bloc.changeHeardFrom(heardFrom);
  bloc.changeIsAnonymous(false);
  bloc.changeContactOptions(contactInfo);
}

void writeRdmValues(FeedbackBloc bloc) {
  bloc.changeLike(random.randomString(10));
  bloc.changeDislike(random.randomString(10));
  bloc.changeMissing(random.randomString(10));
  bloc.changeHeardFrom(random.randomString(10));
  bloc.changeContactOptions(random.randomString(10));
}
