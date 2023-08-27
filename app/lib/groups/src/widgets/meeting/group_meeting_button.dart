// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class GroupMeetingButton extends StatelessWidget {
  const GroupMeetingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _MeetingDisabledListTile(),
              ],
            ),
            onTap: () => showLeftRightAdaptiveDialog(
                right: AdaptiveDialogAction.ok,
                left: null,
                context: context,
                title: 'Meetings deaktiviert.',
                content: Text(
                    'Videokonferenzen wurden für alle Nutzer:innen von Sharezone endgültig deaktiviert.')),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 375),
            child: _MeetingIsDisabledHint(),
          )
        ],
      ),
    );
  }
}

class _MeetingIsDisabledHint extends StatelessWidget {
  const _MeetingIsDisabledHint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _TextBelowButton(
      "Videokonferenzen wurden aus Sharezone entfernt.",
      key: ValueKey('meeting-is-disabled-hint-widget-test'),
    );
  }
}

class _TextBelowButton extends StatelessWidget {
  const _TextBelowButton(this.text, {Key? key}) : super(key: key);

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
    Key? key,
    required this.isLoading,
    required this.isThreeLine,
    required this.enabled,
    required this.subtitle,
    required this.trailing,
  }) : super(key: key);

  final bool isLoading;
  final bool isThreeLine;
  final bool enabled;
  final Widget subtitle;
  final Widget? trailing;

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
