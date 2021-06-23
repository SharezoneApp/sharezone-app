import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/crash_analytics/crash_analytics_bloc.dart';
import 'package:sharezone/meeting/bloc/meeting_bloc.dart';
import 'package:sharezone/meeting/bloc/meeting_bloc_factory.dart';
import 'package:sharezone/meeting/models/meeting_id.dart';
import 'package:sharezone/meeting/widgets/meeting_copied_meeting_url_dialog.dart';
import 'package:sharezone/meeting/widgets/meeting_error_dialog.dart';
import 'package:sharezone/meeting/widgets/meeting_warning.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/additional.dart';
import 'package:sharezone_widgets/widgets.dart';

import 'package:url_launcher_extended/url_launcher_extended.dart';
import 'group_meeting_button_view.dart';

class GroupMeetingButton extends StatefulWidget {
  const GroupMeetingButton({
    Key key,
    @required this.view,
    @required this.groupName,
    @required this.meetingId,
    @required this.groupType,
    @required this.groupId,
  })  : assert(view != null),
        super(key: key);

  final GroupMeetingView view;

  final String groupName;
  final MeetingId meetingId;
  final GroupType groupType;
  final GroupId groupId;

  @override
  _GroupMeetingButtonState createState() => _GroupMeetingButtonState();
}

class _GroupMeetingButtonState extends State<GroupMeetingButton> {
  /// Dies ist der [LoadingStatus] für das Laden der Meeting-Daten (JWT). Dies
  /// ist nicht der Ladestatus des gesamten Buttons (also view.isLoading).
  LoadingStatus status;

  MeetingBloc bloc;

  @override
  Widget build(BuildContext context) {
    // Der Bloc wie üblich im initState erstellt werden, da ansonsten die
    // MeetingId nicht geupdatet wird, das Widget mit einer neuen MeetingId
    // aufgerufen wird. Ansonsten kann es zu einem Bug kommen, wenn das Backend
    // noch nicht die MeetingId erstellt hat und diese nachgeladen wird, siehe:
    // https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1403
    //
    // Wenn der Bloc in der UI aufgerufen wird, wir automatisch ein neuer Bloc
    // erstellt. Da der Nutzer keine Daten in den Bloc schreibt (z.B.
    // TextField), ist dies auch kein Problem.
    _createBloc();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            key: const ValueKey("group-meeting-card-button-widget-test"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    "Videokonferenz",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                if (widget.view.isEnabled)
                  _MeetingEnabledListTile(
                    meetingId: widget.view.meetingId,
                    isLoading: widget.view.isLoading,
                    trailing: _getIcon(context, loadingStatus: status),
                  )
                else
                  _MeetingDisabledListTile(),
              ],
            ),
            onTap: widget.view.isEnabled ? () => _onTap(context) : null,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 375),
            child:
                widget.view.isEnabled ? Container() : _MeetingIsDisabledHint(),
          )
        ],
      ),
    );
  }

  void _createBloc() {
    bloc = BlocProvider.of<MeetingBlocFactory>(context).create(
      meetingId: widget.meetingId,
      groupId: widget.groupId,
      groupType: widget.groupType,
      groupName: widget.groupName,
    );
  }

  Widget _getIcon(
    BuildContext context, {
    @required LoadingStatus loadingStatus,
  }) {
    // IconButton is (mis)used here as it automatically handels centering,
    // paddding, sizing, etc. It is not intended to be pressed.
    if (loadingStatus == LoadingStatus.loading)
      return const IconButton(
        tooltip: 'Meeting-Daten werden geladen...',
        key: ValueKey("join-meeting-icon-loading-widget-test"),
        icon: LoadingCircle(),
        onPressed: null,
      );

    if (loadingStatus == LoadingStatus.failed)
      return IconButton(
        tooltip: 'Fehler beim Beitritt',
        key: const ValueKey("join-meeting-icon-failed-widget-test"),
        icon: Icon(Icons.error, color: Colors.red),
        onPressed: null,
      );

    // No icon is needed, when group meeting but wasn't tapped. Container() &
    // null will cause a lot of ui exception. An empty text is working as a
    // workaround.
    return Text("", key: const ValueKey("join-meeting-icon-empty-widget-test"));
  }

  Future<void> _onTap(BuildContext context) async {
    if (bloc.shouldShowMeetingWarning()) {
      final confirm = await showMeetingWarning(context);
      if (confirm) {
        bloc.setMeetingWarningWasAcknowledged();
      } else {
        // Meeting soll nicht gestartet werden, weil der Nutzer den Hinweis
        // weggedrückt hat.
        return;
      }
    }

    _startLoadingAnimation();

    try {
      await bloc.joinGroupMeeting();

      _removeLoadingIcon();

      // Sollte meist nur im Web passieren, es kann aber auch bei sehr alten
      // Android-Geräten auftreten. Die Exception sollte nur in äußerst seltenen
      // Fällen auftreten.
    } on CouldNotLaunchUrlException catch (e) {
      showCopiedMeetingUrlDialog(context);
      _copyJitsiLink(e.url);

      // Even if url could not be launched it is still a successful state, because
      // the JSON Web Token (JWT) could successful loaded.
      _removeLoadingIcon();
    } catch (e, s) {
      setState(() => status = LoadingStatus.failed);

      _logError(context, e, s);
      showMeetingErrorDialog(context, e, s, widget.view.meetingId);
    }
  }

  void _removeLoadingIcon() {
    Future.delayed(const Duration(seconds: 3))
        .then((_) => setState(() => status = null));
  }

  void _startLoadingAnimation() {
    setState(() => status = LoadingStatus.loading);
  }

  void _copyJitsiLink(String url) {
    Clipboard.setData(ClipboardData(text: url));
  }

  void _logError(BuildContext context, dynamic e, StackTrace s) {
    BlocProvider.of<CrashAnalyticsBloc>(context)
        .crashAnalytics
        .recordError(e, s);
  }
}

class _MeetingIsDisabledHint extends StatelessWidget {
  const _MeetingIsDisabledHint({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _TextBelowButton(
      "Videokonferenzen für diese Gruppe wurden von einem Administrator.",
      key: ValueKey('meeting-is-disabled-hint-widget-test'),
    );
  }
}

class _TextBelowButton extends StatelessWidget {
  const _TextBelowButton(this.text, {Key key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey(text),
      padding: const EdgeInsets.only(top: 4, left: 4),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}

class _MeetingEnabledListTile extends StatelessWidget {
  const _MeetingEnabledListTile({
    Key key,
    @required this.isLoading,
    @required this.meetingId,
    @required this.trailing,
  }) : super(key: key);

  final String meetingId;
  final Widget trailing;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return _MeetingBasicListTile(
      enabled: true,
      isThreeLine: true,
      subtitle: Text("Videokonferenz mit Jitsi\nID: $meetingId"),
      trailing: trailing,
      isLoading: isLoading,
    );
  }
}

class _MeetingDisabledListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MeetingBasicListTile(
      enabled: false,
      isThreeLine: false,
      subtitle: const Text("Videokonferenz mit Jitsi"),
      trailing: null,
      isLoading: false,
    );
  }
}

class _MeetingBasicListTile extends StatelessWidget {
  const _MeetingBasicListTile({
    Key key,
    @required this.isLoading,
    @required this.isThreeLine,
    @required this.enabled,
    @required this.subtitle,
    @required this.trailing,
  }) : super(key: key);

  final bool isLoading;
  final bool isThreeLine;
  final bool enabled;
  final Widget subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: GrayShimmer(
        key: ObjectKey(isLoading),
        enabled: isLoading,
        child: ListTile(
          leading: const Icon(Icons.video_call),
          title:
              Text(isLoading ? "Lade Meeting-Daten..." : "Meeting beitreten"),
          subtitle: subtitle,
          isThreeLine: isThreeLine,
          enabled: enabled,
          // Da der onTap Parameter beim ListTile null ist, wird der normale Mourse
          // Cursor verwendet und blockt gleichzeitig den clickable Mouse Cursor der
          // CustomCard. Dadurch weiß ein Nutzer nicht, ob man die Karte nun
          // anklicken kann. Mit [MouseCursor.defer] wird nun der clickable Mourse
          // Cursor wieder angezeigt.
          mouseCursor: MouseCursor.defer,
          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            // Container() verursacht UI-Fehler, deswegen als Workaround Text("")
            child: trailing ?? Text(""),
          ),
        ),
      ),
    );
  }
}
