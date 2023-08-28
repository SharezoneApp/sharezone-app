// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notifications/notifications.dart';
import 'package:sharezone/notifications/action_requests/action_requests.dart';
import 'package:sharezone/notifications/setup_push_notification_action_handler.dart';

import 'scaffolding.dart';

void main() {
  test('generateNotificationMutations docs example', () {
    /// [generateNotificationMutations] is used in the tests to generate
    /// different [PushNotification] in a concise way.
    ///
    /// For every attribute one can pass different values into the function
    /// which will combine the different possibilites of the different
    /// attributes into the [PushNotification] that are returned.
    ///
    /// Not all possible mutations of [PushNotification] are actually generated.
    /// For more information see the docs of [generateNotificationMutations].

    final notifications = generateNotificationMutations(
      actionType: {'do-something', 'do-something-aswell'},
      actionData: {
        <String, dynamic>{},
        {'link': null},
        {'link': ''},
      },
      title: {null, '', 'my title'},
      body: {null, '', 'my body'},
    );

    expect(notifications, [
      PushNotification(
        actionType: 'do-something',
        actionData: {},
        title: null,
        body: null,
      ),
      PushNotification(
        actionType: 'do-something-aswell',
        actionData: {'link': null},
        title: '',
        body: '',
      ),
      PushNotification(
        actionType: 'do-something-aswell',
        actionData: {'link': ''},
        title: 'my title',
        body: 'my body',
      ),
    ]);
  });
  group('PushNotificationActionHandler', () {
    group('[actionType: ${ShowNotificationDialogRequest.actionTypes}]:', () {
      test(
          'returns a $ShowNotificationDialogRequest with answerSupport set false if no actionData is given',
          () {
        TestHandlerFor.success<ShowNotificationDialogRequest>(
            generateNotifications: () => [
                  ...generateNotificationMutations(
                    actionType: {null, ''},
                    actionData: <String, dynamic>{
                      'showSupportOption': null,
                    },
                    // If there is a title the body can be omitted
                    body: {null, ''},
                    title: 'This is some title',
                  ),
                  ...generateNotificationMutations(
                    actionType: {null, ''},
                    actionData: <String, dynamic>{},
                    // If there is a body the title can be omitted
                    body: 'This is some body',
                    title: {null, ''},
                  ),
                ],
            expectActionToExecute: (actionRequest) {
              expect(actionRequest, hasNonEmptyMessage);
              expect(actionRequest.shouldShowAnswerToSupportOption, false);
            });
      });
      test(
          'returns a $ShowNotificationDialogRequest with answerSupport set true if actionData says true',
          () {
        TestHandlerFor.success<ShowNotificationDialogRequest>(
            generateNotifications: () => [
                  ...generateNotificationMutations(
                    actionType: {null, ''},
                    actionData: {
                      {
                        'showSupportOption': true,
                        // to make sure it works with other stuff inside the map
                        'irrelevant': true
                      },
                      {
                        'showSupportOption': 'true',
                        // to make sure it works with other stuff inside the map
                        'irrelevant': 'true'
                      },
                    },
                    body: 'This is some body',
                    title: 'This is some title',
                  ),
                ],
            expectActionToExecute: (actionRequest) {
              expect(actionRequest, hasNonEmptyMessage);
              expect(actionRequest.shouldShowAnswerToSupportOption, true);
            });
      });
      test(
          'returns a $ShowNotificationDialogRequest with answerSupport set false if actionData says false',
          () {
        TestHandlerFor.success<ShowNotificationDialogRequest>(
            generateNotifications: () => [
                  ...generateNotificationMutations(
                    actionType: {null, ''},
                    actionData: {
                      {
                        'showSupportOption': false,
                      },
                      {
                        'showSupportOption': 'false',
                      },
                    },
                    body: 'This is some body',
                    title: 'This is some title',
                  ),
                ],
            expectActionToExecute: (actionRequest) {
              expect(actionRequest, hasNonEmptyMessage);
              expect(actionRequest.shouldShowAnswerToSupportOption, false);
            });
      });
      List<PushNotification> _with({required dynamic actionData}) {
        return generateNotificationMutations(
          actionType: {null, ''},
          actionData: actionData,
          body: 'This is some body',
          title: 'This is some title',
        );
      }

      test(
          'returns a $ShowNotificationDialogRequest with answerSupport set false if actionData cant be parsed / is invalid',
          () {
        TestHandlerFor.success<ShowNotificationDialogRequest>(
            generateNotifications: () => [
                  ..._with(
                    actionData: {
                      'showSupportOption': '',
                    },
                  ),
                  ..._with(
                    actionData: {
                      'showSupportOption': 3,
                    },
                  ),
                  ..._with(
                    actionData: {
                      'showSupportOption': "wadawdawdwad",
                    },
                  ),
                ],
            expectActionToExecute: (actionRequest) {
              expect(actionRequest, hasNonEmptyMessage);
              expect(actionRequest.shouldShowAnswerToSupportOption, false);
            });
      });
      test(
          'returns $ShowNotificationDialogRequest when there is no action type but a title or body that can be displayed',
          () {
        TestHandlerFor.success<ShowNotificationDialogRequest>(
            generateNotifications: () => [
                  ...generateNotificationMutations(
                    actionType: {null, ''},
                    actionData: {
                      <String, dynamic>{},
                      {'foo': 'bar'}
                    },
                    body: 'This is some body',
                    // Can be omitted if there is body
                    title: {null, ''},
                  ),
                  ...generateNotificationMutations(
                    actionType: {null, ''},
                    actionData: {
                      <String, dynamic>{},
                      {'foo': 'bar'}
                    },
                    // Can be omitted if there is a title
                    body: {null, ''},
                    title: 'This is some title',
                  ),
                ],
            expectActionToExecute: (actionRequest) {
              expect(actionRequest.shouldShowAnswerToSupportOption, false);
            });
      });
      test('throws Error if there is no content that could be displayed', () {
        TestHandlerFor.fatalParsingFailure(
            generateNotifications: () => generateNotificationMutations(
                  actionType: {null, ''},
                  actionData: {
                    <String, dynamic>{},
                    {'foo': 'bar'}
                  },
                  body: {null, ''},
                  title: {null, ''},
                ),
            resultsInFatalParsingError: (error) {
              expect(error!.error, isNotNull);
            });
      });
      test(
          'notifies of non-fatal parsing error when action data cant be parsed',
          () {
        TestHandlerFor.nonFatalParsingExceptions<ShowNotificationDialogRequest>(
            generateNotifications: () => [
                  ..._with(actionData: {
                    'showSupportOption': 3,
                  }),
                ],
            expectParsingErrors: (parsingErrors) {
              final parsingError = parsingErrors.single;
              expect(parsingError.attributeName, 'showSupportOption');
              expect(parsingError.fallbackValueChosen, false);
              // Not sure if we neccessarily need to check that an
              // error/exception was logged here (as a failure can be expected
              // by the code - it could handle it without an exception)
              expect(parsingError.error, isNotNull);
              // We just assume it's the right one
              expect(parsingError.notification, isNotNull);
            });
      });
      test(
          'regression test: does not notify of non fatal parsing error if the value is null / just not given',
          () {
        TestHandlerFor.success<ShowNotificationDialogRequest>(
          failOnNonFatalParsingErrors: true,
          generateNotifications: () => [
            ..._with(actionData: <String, dynamic>{}),
            ..._with(actionData: {
              'showSupportOption': null,
            }),
          ],
          expectActionToExecute: (_) {},
        );
      });
    });
    group('[actionType: ${ShowTimetableEventRequest.actionTypes}]:', () {
      test(
          'returns a $ShowTimetableEventRequest if actionData is a non-empty string',
          () {
        TestHandlerFor.success<ShowTimetableEventRequest>(
            generateNotifications: () => generateNotificationMutations(
                  actionType: ShowTimetableEventRequest.actionTypes,
                  actionData: {
                    'id': 'timetable-event-id',
                  },
                  body: {null, '', 'This is some body'},
                  title: {null, '', 'This is some title'},
                ),
            expectActionToExecute: (actionRequest) {
              expect(actionRequest.timetableEventId,
                  TimetableEventId('timetable-event-id'));
            });
      });

      test(
          'results in parsing error when when receiving receiving empty or invalid actionData',
          () {
        TestHandlerFor.fatalParsingFailure(
          generateNotifications: () => generateNotificationMutations(
            actionType: ShowTimetableEventRequest.actionTypes,
            actionData: {
              <String, dynamic>{},
              {'id': null},
              {'id': ''},
              // bad id, should be a string
              {'id': 3},
            },
            title: {null, '', 'foo'},
            body: {null, '', 'foo'},
          ),
          resultsInFatalParsingError: (error) {
            expect(error!.error, isNotNull);
          },
        );
      });
    });
    group('[actionType: ${ShowHomeworkRequest.actionTypes}]:', () {
      test('returns a $ShowHomeworkRequest if actionData is a non-empty string',
          () {
        TestHandlerFor.success<ShowHomeworkRequest>(
            generateNotifications: () => generateNotificationMutations(
                  actionType: ShowHomeworkRequest.actionTypes,
                  actionData: {'id': 'homework-item-id'},
                  body: {null, '', 'This is some body'},
                  title: {null, '', 'This is some title'},
                ),
            expectActionToExecute: (actionRequest) {
              expect(actionRequest.homeworkId, HomeworkId('homework-item-id'));
            });
      });
      test(
          'results in parsing error when receiving empty or invalid actionData',
          () {
        TestHandlerFor.fatalParsingFailure(
          generateNotifications: () => generateNotificationMutations(
            actionType: ShowHomeworkRequest.actionTypes,
            actionData: {
              <String, dynamic>{},
              {'id': null},
              {'id': ''},
              // bad id, should be a string
              {'id': 3}
            },
            title: {null, '', 'foo'},
            body: {null, '', 'foo'},
          ),
          resultsInFatalParsingError: (error) {
            expect(error!.error, isNotNull);
          },
        );
      });
    });
    group('[actionType: ${ShowBlackboardItemRequest.actionTypes}]:', () {
      test(
          'returns a $ShowBlackboardItemRequest if actionData is a non-empty string',
          () {
        TestHandlerFor.success<ShowBlackboardItemRequest>(
            generateNotifications: () => generateNotificationMutations(
                  actionType: ShowBlackboardItemRequest.actionTypes,
                  actionData: {'id': 'blackboard-item-id'},
                  body: {null, '', 'This is some body'},
                  title: {null, '', 'This is some title'},
                ),
            expectActionToExecute: (actionRequest) {
              expect(actionRequest.blackboardItemId,
                  BlackboardItemId('blackboard-item-id'));
            });
      });
      test(
          'results in parsing error when receiving empty or invalid actionData',
          () {
        TestHandlerFor.fatalParsingFailure(
          generateNotifications: () => generateNotificationMutations(
            actionType: ShowBlackboardItemRequest.actionTypes,
            actionData: {
              <String, dynamic>{},
              {'id': null},
              {'id': ''},
              // bad id, should be a string
              {'id': 3},
            },
            title: {null, '', 'foo'},
            body: {null, '', 'foo'},
          ),
          resultsInFatalParsingError: (error) {
            expect(error!.error, isNotNull);
          },
        );
      });
    });
    group('[actionType: ${OpenLinkRequest.actionTypes}]:', () {
      test('returns a $OpenLinkRequest if actionData is a non-empty string',
          () {
        TestHandlerFor.success<OpenLinkRequest>(
            generateNotifications: () => generateNotificationMutations(
                  actionType: OpenLinkRequest.actionTypes,
                  actionData: {'link': 'https://www.example.com'},
                  body: {null, '', 'This is some body'},
                  title: {null, '', 'This is some title'},
                ),
            expectActionToExecute: (actionRequest) {
              expect(actionRequest.linkToOpen, 'https://www.example.com');
            });
      });
      test(
          'results in parsing error when receiving empty or invalid actionData',
          () {
        TestHandlerFor.fatalParsingFailure(
          generateNotifications: () => [
            ...generateNotificationMutations(
              actionType: OpenLinkRequest.actionTypes,
              actionData: {
                <String, dynamic>{},
                {'link': null},
                {'link': ''},
                {'id': 3},
              },
              title: {null, '', 'foo'},
              body: {null, '', 'foo'},
            ),
          ],
          resultsInFatalParsingError: (error) {
            expect(error!.error, isNotNull);
          },
        );
      });
    });
    group('[actionType: ${NavigateToLocationRequest.actionTypes}]:', () {
      test(
          'returns a $NavigateToLocationRequest when actionData is a non-empty string.',
          () {
        TestHandlerFor.success<NavigateToLocationRequest>(
            generateNotifications: () => generateNotificationMutations(
                  actionType: NavigateToLocationRequest.actionTypes,
                  actionData: {'page-tag': 'homework-page'},
                  body: {null, '', 'This is some body'},
                  title: {null, '', 'This is some title'},
                ),
            expectActionToExecute: (actionRequest) {
              expect(actionRequest.navigationTag, 'homework-page');
            });
      });
      test(
          'results in parsing error when receiving empty or invalid actionData',
          () {
        TestHandlerFor.fatalParsingFailure(
          generateNotifications: () => generateNotificationMutations(
            actionType: NavigateToLocationRequest.actionTypes,
            actionData: {
              <String, dynamic>{},
              {'page-tag': null},
              {'page-tag': ''},
              // bad tag, should be a string
              {'page-tag': 3},
            },
            title: {null, '', 'foo'},
            body: {null, '', 'foo'},
          ),
          resultsInFatalParsingError: (error) {
            expect(error!.error, isNotNull);
          },
        );
      });
    });
    test(
        'will notify instrumentation when failing because of an unknown action type',
        () {
      final notification = PushNotification(
          actionType: 'some-unknown-action-type', title: 'foo', body: 'bar');
      final result = handlePushNotification(notification);
      expect(result.instrumentation!.hasFailedOnUnknownActionType, true);
    });
    group('shows error dialog with reason: ', () {
      /// These tests are kind of an integration test between the generic
      /// [PushNotificationActionHandler] and the pre-configured instance for in-app
      /// use created by [setupPushNotificationActionHandler].
      /// They more specifically test the behavior in
      /// [setupPushNotificationActionHandler] for a fatal parsing error and an
      /// unknown action type.
      ///
      /// With [TestHandlerFor.fatalParsingFailure] and a seperate "unknown
      /// action type" test we test the generic part of the handler for these
      /// cases so we don't couple our tests to how an error might be surfaced
      /// in the app to the end-user.
      /// In this way our unit-tests that are mostly concerned with parsing a
      /// notification don't have to know anything about how an error might be
      /// later shown to the user (if at all).
      test(
          'fatal conversion error if conversion of notification to actionRequest throws exception/error',
          () {
        TestHandlerFor.errorDialog(
          addRegistrations: [
            ActionRegistration(
              registerForActionTypeStrings: {'faulty-test'},
              parseActionRequestFromNotification: (_, __) =>
                  throw Exception('this represents a fatal parsing error'),
              executeActionRequest: (_) {},
            )
          ],
          generateNotifications: () => generateNotificationMutations(
            actionType: 'faulty-test',
            actionData: {
              <String, dynamic>{},
              {'foo': 'bar'}
            },
            body: {null, '', 'This is some body'},
            title: {null, '', 'This is some title'},
          ),
          shouldShowErrorDialog: (errorDialogInvocation) {
            expect(errorDialogInvocation!.errorReason,
                NotificationHandlerErrorReason.fatalParsingError);
            expect(errorDialogInvocation.errorOrNull, isNotNull);
            expect(errorDialogInvocation.notification, isNotNull);
          },
        );
      });
      test('"Unknown action type" when receiving unknown action type', () {
        TestHandlerFor.errorDialog(
          generateNotifications: () => generateNotificationMutations(
            actionType: 'some-unknown-action-type',
            actionData: {
              <String, dynamic>{},
              {'foo': 'bar'}
            },
            body: {null, '', 'This is some body'},
            title: {null, '', 'This is some title'},
          ),
          shouldShowErrorDialog: (errorDialogInvocation) {
            expect(errorDialogInvocation!.errorReason,
                NotificationHandlerErrorReason.unknownActionType);
            // If we know that its an unknown type it isn't an unexpected case.
            // We don't need an error.
            expect(errorDialogInvocation.errorOrNull, isNull);
            expect(errorDialogInvocation.notification, isNotNull);
          },
        );
      });
    });
    test(
        'calls correct instrumentation methods when successful handling notification',
        () {
      final testActionRegistration = ActionRegistration<TestActionRequest>(
        registerForActionTypeStrings: {'abc'},
        parseActionRequestFromNotification: (_, __) => TestActionRequest(),
        executeActionRequest: (_) {},
      );

      final notification = PushNotification(
        actionType: 'abc',
        title: 'title',
        body: 'body',
      );

      final result = handlePushNotification(notification,
          testRegistrations: [testActionRegistration]);
      final instrumentation = result.instrumentation!;

      expect(instrumentation.calledHandlingPushNotification, true);
      expect(instrumentation.calledParsingSucceeded, true);
      expect(instrumentation.calledActionExecutedSuccessfully, true);
      expect(instrumentation.calledActionExecutionFailed, false);
      expect(instrumentation.hasFailedOnUnknownActionType, false);
      expect(instrumentation.hasNonFatalParsingExceptions, false);
      expect(instrumentation.hasFatalParsingError, false);
    });

    test(
        'throws error if several registrations have registered for the same action type',
        () {
      final foo = ActionRegistration<TestActionRequest>(
        registerForActionTypeStrings: {'foo'},
        parseActionRequestFromNotification: (_, __) => TestActionRequest(),
        executeActionRequest: (_) {},
      );

      final barAndFoo = ActionRegistration<TestActionRequest2>(
        registerForActionTypeStrings: {'bar', 'foo'},
        parseActionRequestFromNotification: (_, __) => TestActionRequest2(),
        executeActionRequest: (_) {},
      );

      final bar = ActionRegistration<TestActionRequest>(
        registerForActionTypeStrings: {'bar'},
        parseActionRequestFromNotification: (_, __) => TestActionRequest(),
        executeActionRequest: (_) {},
      );

      final baz = ActionRegistration<TestActionRequest>(
        registerForActionTypeStrings: {'baz'},
        parseActionRequestFromNotification: (_, __) => TestActionRequest(),
        executeActionRequest: (_) {},
      );

      PushNotificationActionHandler create() => PushNotificationActionHandler(
          instrumentation: TestInstrumentation(),
          actionRegistrations: [foo, barAndFoo, bar, baz],
          onUnhandledActionType: (_) {},
          onFatalParsingError: (_, __) {});

      try {
        create();
        fail('should throw DuplicateRegistrationsError');
        // ignore: avoid_catching_errors
      } on DuplicateRegistrationsError catch (e) {
        expect(e.duplicateRegistrations, {foo, barAndFoo, bar});
      }
    });
  });
}

class TestActionRequest extends ActionRequest {
  @override
  List<Object> get props => [];
}

class TestActionRequest2 extends ActionRequest {
  @override
  List<Object> get props => [];
}

class HasNonEmptyMessage extends Matcher {
  @override
  Description describe(Description description) {
    description.add('should have title or body set');
    return description;
  }

  @override
  bool matches(covariant ShowNotificationDialogRequest item, Map matchState) {
    final isTitleNonEmpty = _isNonEmptyString(item.title);
    final isBodyNonEmpty = _isNonEmptyString(item.body);
    return isTitleNonEmpty || isBodyNonEmpty;
  }

  bool _isNonEmptyString(String? s) => s != null && s.trim() != '';
}

final hasNonEmptyMessage = HasNonEmptyMessage();
