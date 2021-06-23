import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/mock_crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/crash_analytics/crash_analytics_bloc.dart';
import 'package:sharezone/groups/src/widgets/meeting/group_meeting_button.dart';
import 'package:sharezone/groups/src/widgets/meeting/group_meeting_button_view.dart';
import 'package:sharezone/meeting/analytics/meeting_analytics.dart';
import 'package:sharezone/meeting/bloc/meeting_bloc.dart';
import 'package:sharezone/meeting/bloc/meeting_bloc_factory.dart';
import 'package:sharezone/meeting/cache/meeting_cache.dart';
import 'package:sharezone/meeting/jitsi/jitsi_auth.dart';
import 'package:sharezone/meeting/models/meeting_id.dart';
import 'package:sharezone/meeting/jitsi/jitsi_launcher.dart';
import 'package:sharezone_utils/src/device_information_manager/mobile_device_information_manager.dart';
import 'package:sharezone_widgets/additional.dart';
import 'package:url_launcher_extended/url_launcher_extended.dart';

import 'mock/mock_meeting_bloc.dart';

void main() {
  group('GroupMeetingButton', () {
    MockMeetingBloc bloc;
    MockCrashAnalytics mockCrashAnalytics;
    MockMeetingBlocFactory blocFactory;

    /// Default view is the view that the user gets in most of all times
    /// (loading completed and meeting enabled)
    final defaultView = GroupMeetingView(
      isLoading: false,
      isEnabled: true,
      meetingId: 'meetingId',
    );

    setUp(() {
      mockCrashAnalytics = MockCrashAnalytics();
      bloc = MockMeetingBloc();
      blocFactory = MockMeetingBlocFactory(bloc);
    });

    Future<void> _pumpGroupMeetingButton(
        WidgetTester tester, GroupMeetingView view) async {
      await tester.pumpWidget(
        BlocProvider<CrashAnalyticsBloc>(
          bloc: CrashAnalyticsBloc(mockCrashAnalytics),
          child: BlocProvider<MeetingBlocFactory>(
            bloc: blocFactory,
            child: MaterialApp(
              home: Material(
                child: GroupMeetingButton(
                  view: view,
                  groupId: GroupId("groupId"),
                  groupType: GroupType.course,
                  groupName: "groupName",
                  meetingId: MeetingId("12345678"),
                ),
              ),
            ),
          ),
        ),
      );
    }

    group('GroupMeetingView', () {
      testWidgets(
          "gray shimmer is enabled if loading attribute in view is true",
          (tester) async {
        final view = GroupMeetingView(
          isLoading: true,
          isEnabled: true,
          meetingId: 'meetingId',
        );
        await _pumpGroupMeetingButton(tester, view);

        final GrayShimmer grayShimmer =
            tester.firstWidget(find.byType(GrayShimmer));
        expect(grayShimmer.enabled, true);
      });

      testWidgets(
          "gray shimmer is disabled if loading attribute in view is false",
          (tester) async {
        final view = GroupMeetingView(
          isLoading: false,
          isEnabled: true,
          meetingId: 'meetingId',
        );
        await _pumpGroupMeetingButton(tester, view);

        final GrayShimmer grayShimmer =
            tester.firstWidget(find.byType(GrayShimmer));
        expect(grayShimmer.enabled, false);
      });

      testWidgets(
          "shows meeting is disabled hint, if meetings are disabled in view",
          (tester) async {
        final view = GroupMeetingView(
          isLoading: false,
          isEnabled: false,
          meetingId: 'meetingId',
        );
        await _pumpGroupMeetingButton(tester, view);

        expect(
          find.byKey(const ValueKey("meeting-is-disabled-hint-widget-test")),
          findsOneWidget,
        );
      });

      testWidgets(
          'does not show "meeting is disabled" hint, if meetings are enabled in view',
          (tester) async {
        final view = GroupMeetingView(
          isLoading: false,
          isEnabled: true,
          meetingId: 'meetingId',
        );
        await _pumpGroupMeetingButton(tester, view);

        expect(
          find.byKey(const ValueKey("meeting-is-disabled-hint-widget-test")),
          findsNothing,
        );
      });

      testWidgets("shows meeting id", (tester) async {
        final view = GroupMeetingView(
          isLoading: false,
          isEnabled: true,
          meetingId: 'meetingId',
        );
        await _pumpGroupMeetingButton(tester, view);

        expect(
          find.textContaining('meetingId'),
          findsOneWidget,
        );
      });
    });

    group('tap join meeting button', () {
      testWidgets('shows meeting warning if user never joined a meeting',
          (tester) async {
        await _pumpGroupMeetingButton(tester, defaultView);

        await tester.tap(
          find.byKey(
            const ValueKey("group-meeting-card-button-widget-test"),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey("meeting-warning-widget-test")),
          findsOneWidget,
        );
      });

      testWidgets(
          'marks meeting warning as shown if user taps on okay in warning',
          (tester) async {
        await _pumpGroupMeetingButton(tester, defaultView);

        await tester.tap(
          find.byKey(
            const ValueKey("group-meeting-card-button-widget-test"),
          ),
        );
        await tester.pump();

        expect(bloc.calledMeetingWarningAsAcknowledged, false);

        await tester.tap(
          find.byKey(
            const ValueKey('meeting-warning-okay-button-widget-test'),
          ),
        );
        // Wait until loadings animation finished
        await tester.pumpAndSettle();

        expect(bloc.calledMeetingWarningAsAcknowledged, true);
      });

      testWidgets('calls join method in bloc', (tester) async {
        await _pumpGroupMeetingButton(tester, defaultView);

        expect(
          bloc.calledJoinGroupMeetingMethod,
          false,
          reason: 'Join meeting method should not be called at the beginning',
        );

        // Skips meeting warning, because user doesn't tap join meeting for the
        // first time.
        bloc.setShouldShowMeetingWarning(false);

        await tester.tap(
          find.byKey(
            const ValueKey("group-meeting-card-button-widget-test"),
          ),
        );
        // Wait until loadings animation finished
        await tester.pumpAndSettle();

        expect(bloc.calledJoinGroupMeetingMethod, true);
      });

      testWidgets('shows no loading icon after 3 seconds', (tester) async {
        await _pumpGroupMeetingButton(tester, defaultView);

        // Skip meeting warning, because user doesn't taps join meeting for the
        // first time.
        bloc.setShouldShowMeetingWarning(false);

        await tester.tap(
          find.byKey(
            const ValueKey("group-meeting-card-button-widget-test"),
          ),
        );
        // Wait until loadings animation finished
        await tester.pumpAndSettle();

        expect(
          find.byKey(const ValueKey("join-meeting-icon-empty-widget-test")),
          findsOneWidget,
        );
      });

      testWidgets('shows failed icon if bloc throws expection', (tester) async {
        await _pumpGroupMeetingButton(tester, defaultView);

        // Skips meeting warning, because user doesn't tap join meeting for the
        // first time.
        bloc.setShouldShowMeetingWarning(false);

        bloc.shouldThrowExpectionWhenJoinGroupMeeting(Exception());

        await tester.tap(
          find.byKey(
            const ValueKey("group-meeting-card-button-widget-test"),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey("join-meeting-icon-failed-widget-test")),
          findsOneWidget,
        );
      });

      testWidgets('shows error dialog if bloc throws expection',
          (tester) async {
        await _pumpGroupMeetingButton(tester, defaultView);

        // Skips meeting warning, because user doesn't tap join meeting for the
        // first time.
        bloc.setShouldShowMeetingWarning(false);

        bloc.shouldThrowExpectionWhenJoinGroupMeeting(Exception());

        await tester.tap(
          find.byKey(
            const ValueKey("group-meeting-card-button-widget-test"),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey('meeting-error-dialog-text-widget-test')),
          findsOneWidget,
        );
      });

      testWidgets(
          'shows "copyied meeting url" dialog if url launcher could not open url',
          (tester) async {
        await _pumpGroupMeetingButton(tester, defaultView);

        // Skips meeting warning, because user doesn't tap join meeting for the
        // first time.
        bloc.setShouldShowMeetingWarning(false);

        bloc.shouldThrowExpectionWhenJoinGroupMeeting(
          CouldNotLaunchUrlException('url'),
        );

        await tester.tap(
          find.byKey(
            const ValueKey("group-meeting-card-button-widget-test"),
          ),
        );
        // Wait until loadings animation finished
        await tester.pumpAndSettle();

        expect(
          find.byKey(
              const ValueKey('copied-meeting-url-dialog-text-widget-test')),
          findsOneWidget,
        );
      });

      /// This test preventes this bug:
      /// https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1403
      testWidgets('creates a bloc if a meeting id is loaded', (tester) async {
        final firstMeetingId = MeetingId("first");
        final secondMeetingId = MeetingId("second");

        const duration = Duration(seconds: 3);

        Future<MeetingId> meetingIdFuture() async {
          await Future.delayed(duration);
          return secondMeetingId;
        }

        await tester.pumpWidget(
          FutureBuilder<MeetingId>(
            future: meetingIdFuture(),
            initialData: firstMeetingId,
            builder: (context, snapshot) {
              return BlocProvider<CrashAnalyticsBloc>(
                bloc: CrashAnalyticsBloc(mockCrashAnalytics),
                child: BlocProvider<MeetingBlocFactory>(
                  bloc: blocFactory,
                  child: MaterialApp(
                    home: Material(
                      child: GroupMeetingButton(
                        view: defaultView,
                        groupId: GroupId("groupId"),
                        groupType: GroupType.course,
                        groupName: "groupName",
                        meetingId: snapshot.data,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
        expect(blocFactory.meetingId, firstMeetingId);

        await tester.pump(duration);

        expect(blocFactory.meetingId, secondMeetingId);
      });

      testWidgets('logs crash analytics if joining fails', (tester) async {
        await _pumpGroupMeetingButton(tester, defaultView);
        expect(
          mockCrashAnalytics.logCalledRecordError,
          false,
          reason: 'Crash analytics should not be called at the beginning.',
        );

        // Skip meeting warning, because user doesn't taps join meeting for the
        // first time.
        bloc.setShouldShowMeetingWarning(false);

        bloc.shouldThrowExpectionWhenJoinGroupMeeting(Exception());

        await tester.tap(
          find.byKey(
            const ValueKey("group-meeting-card-button-widget-test"),
          ),
        );
        await tester.pump();

        expect(mockCrashAnalytics.logCalledRecordError, true);
      });

      testWidgets('does not show a loading icon if user did not tap on button',
          (tester) async {
        await _pumpGroupMeetingButton(tester, defaultView);

        expect(
          find.byKey(const ValueKey("join-meeting-icon-empty-widget-test")),
          findsOneWidget,
        );
      });
    });
  });
}

class MockMeetingBlocFactory implements MeetingBlocFactory {
  final MockMeetingBloc bloc;

  MockMeetingBlocFactory(this.bloc);

  @override
  MeetingAnalytics get analytics => throw UnimplementedError();

  @override
  MeetingCache get cache => throw UnimplementedError();

  MeetingId meetingId;

  @override
  MeetingBloc create({
    MeetingId meetingId,
    GroupId groupId,
    GroupType groupType,
    String groupName,
  }) {
    this.meetingId = meetingId;
    return bloc;
  }

  @override
  void dispose() {}

  @override
  JitsiAuth get jitsiAuth => throw UnimplementedError();

  @override
  JitsiLauncher get jitsiLauncher => throw UnimplementedError();

  @override
  MobileDeviceInformationRetreiver get mobileDeviceInformationRetreiver =>
      throw UnimplementedError();
}
