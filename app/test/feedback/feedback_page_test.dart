// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:sharezone/feedback/feedback_box_page.dart';
import 'package:sharezone/feedback/src/bloc/feedback_bloc.dart';
import 'package:sharezone/feedback/src/cache/cooldown_exception.dart';
import 'package:sharezone/feedback/src/cache/feedback_cache.dart';
import 'package:test_randomness/test_randomness.dart' as random;

import 'feedback_bloc_test.dart';
import 'mock_feedback_api.dart';
import 'mock_platform_information_retreiver.dart';

const likes = "likes";
const dislikes = "dislikes";
const missing = "missing";
const heardFrom = "heardFrom";
const uid = "uidABCDEF123891a";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("Feedback tests", () {
    late MockFeedbackApi api;
    late FeedbackCache cache;
    MockPlatformInformationRetriever platformInformationRetriever;
    late FeedbackBloc bloc;
    UserFeedback? expectedResponseWithIdentifiableInfo;

    setUp(() {
      api = MockFeedbackApi();
      cache = FeedbackCache(InMemoryKeyValueStore());
      platformInformationRetriever = MockPlatformInformationRetriever();
      bloc = FeedbackBloc(
        api,
        cache,
        platformInformationRetriever,
        uid,
        MockFeedbackAnalytics(),
      );
      platformInformationRetriever.appName = "appName";
      platformInformationRetriever.packageName = "packageName";

      expectedResponseWithIdentifiableInfo = UserFeedback.create().copyWith(
        likes: likes,
        dislikes: dislikes,
        missing: missing,
        heardFrom: heardFrom,
        uid: uid,
        deviceInformation: FeedbackDeviceInformation.create().copyWith(
          appName: "appName",
          packageName: "packageName",
        ),
      );
    });

    tearDown(() {
      bloc.dispose();
    });

    Future<void> pumpFeedbackPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: BlocProvider(bloc: bloc, child: const FeedbackPageBody()),
          ),
        ),
      );
    }

    test("Feedback is send with uid and device information", () async {
      writeRdmValues(bloc);
      fillInAllFields(bloc);

      await bloc.submit();

      expect(
        api.wasOnlyInvokedWith(expectedResponseWithIdentifiableInfo),
        true,
      );
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

      await pumpFeedbackPage(tester);
      await tester.pump();

      expect(find.text(likes), findsOneWidget);
      expect(find.text(dislikes), findsOneWidget);
      expect(find.text(missing), findsOneWidget);
      expect(find.text(heardFrom), findsOneWidget);
    });
  });
}

void fillInAllFields(FeedbackBloc bloc) {
  bloc.changeLike(likes);
  bloc.changeDislike(dislikes);
  bloc.changeMissing(missing);
  bloc.changeHeardFrom(heardFrom);
}

void writeRdmValues(FeedbackBloc bloc) {
  bloc.changeLike(random.randomString(10));
  bloc.changeDislike(random.randomString(10));
  bloc.changeMissing(random.randomString(10));
  bloc.changeHeardFrom(random.randomString(10));
}
