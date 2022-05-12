// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/meeting/jitsi/jitsi_auth.dart';
import 'package:url_launcher_extended/url_launcher_extended.dart';

/// [JitsiLauncher] ermöglicht über das Beitreten zu einem Jitsi-Meeting. Für
/// Android & iOS wird die Jitsi SDK verwendet, für andere Geräte wird der Link
/// zum Meeting im Browser geöffnet.
class JitsiLauncher {
  JitsiLauncher(
    this._serverUrl,
    this._urlLauncherExtended,
  );

  /// Ist die URL des Jitsi-Servers, mit dem sich der Client verbindet.
  /// Beispiel: https://meet.sharezone.net
  final String _serverUrl;

  /// Mit [UrlLauncherExtended] wird die Meeting-URL im Browser geöffnet, falls
  /// die Jitsi-SDK auf dem Gerät nicht unterstützt wird.
  final UrlLauncherExtended _urlLauncherExtended;

  /// Tritt einem Jitsi-Meeting mit der [meetingId] über die Jitsi-SDK bei.
  /// Das verwendete Jitsi-Package unterstützt nur iOS & Android. Es wird
  /// mindestens iOS 11.0 und Android 6.0 (SDK 23) benötigt.
  ///
  /// [meetingName] ist der Name des Meetings, wie z.B. "Deutsch 8a", "Q2M",
  /// etc. Dieser Name wird nur dem jeweiligen Nutzer angezeigt und gilt nicht
  /// für die anderen Teilnehmer.
  ///
  /// [jwt] ist der JSON Web Token, der benötigt wird, um sich beim Jitsi-Server
  /// zu authentifizieren. In diesem Token sind ebenfalls weitere Informationen
  /// enthalten, wie z.B. Angabe, ob der Nutzer Jitsi-Moderator werden soll und
  /// somit das Meeting verwalten darf.
  /// Der [jwt] kann per [JitsiAuth] geladen werden.
  ///
  /// Falls das Gerät nicht diese Bedingungen unterstützt, dann crasht die App.
  Future<void> joinMobileMeeting({
    @required String meetingId,
    @required String meetingName,
    @required String jwt,
  }) async {
    final options = JitsiMeetingOptions(
      roomNameOrUrl: meetingId,
      serverUrl: _serverUrl,
      subject: meetingName,
      isVideoMuted: true,
      isAudioMuted: false,
      isAudioOnly: false,
      token: jwt,
      // Mithilfe der [FeatureFlagEnum] können bestimmte Features in der Jitsi
      // UI deaktiviert werden. Diese Einschränken gelten jedoch nur für die
      // Mobile Jitsi SDK. Für die Browser-Version müssen die Einschränkungen
      // über die "interface_config.js" beim Server getroffen werden. Mehr Infos
      // dazu in unserem Wiki:
      // https://gitlab.com/codingbrain/sharezone/sharezone-app/-/wikis/Jitsi
      featureFlags: {
        // Nutzer sollen nicht in dem Meeting die Option gezeigt bekommen, dass
        // man andere Nutzer einladen kann, da das Beitreten über die
        // Sharezone-App passieren soll.
        FeatureFlag.isAddPeopleEnabled: false,
        FeatureFlag.isInviteEnabled: false,
        // Call-Integration wird von uns nicht unterstützt.
        FeatureFlag.isCallIntegrationEnabled: false,
        // Aufnehmen von Jitsi-Meetings wird serverseitig nicht unterstützt und
        // würde sowieso mehrere rechtliche Fragen aufwerfen.
        FeatureFlag.isRecordingEnabled: false,
        // Ändern der Server-Url soll Nutzern verboten sein, da dies nicht
        // vorgesehen ist.
        FeatureFlag.isServerUrlChangeEnabled: false,
        // Für Lehrkräfte würde es erschrecken, wenn Schüler plötzlich auf
        // YouTube livestreamen. Aus diesem Grund sollte diese Option besser
        // deaktiviert werden.
        FeatureFlag.isLiveStreamingEnabled: false,
      },
    );
    await JitsiMeetWrapper.joinMeeting(options: options);
  }

  /// Gibt die Meeting-URL zurück, die ein Browser aufruft, um sich mit dem
  /// Meeting zu verbinden. [meeting] und [jwt] können einfach in die URL
  /// eingefügt werden.
  ///
  /// Beispiel: https://meet.sharezone.net/?jwt=eyJhbGciOiJIUzI1 (der JWT ist
  /// eigentlich deutlich länger)
  @visibleForTesting
  String getMeetingUrl(String meetingId, String jwt) {
    return '$_serverUrl/$meetingId?jwt=$jwt';
  }

  /// Da die Jitsi-SDK nur für iOS und Android (min. SDK 23) verfügbar ist,
  /// müssen andere Plattformen (Web, macOS, Android < 23) über den Browser dem
  /// Meeting beitreten.
  ///
  /// [meetingId] ist der Jitsi-Raum, mit dem sich verbunden werden soll.
  ///
  /// [jwt] ist der JSON Web Token, der benötigt wird, um sich beim Jitsi-Server
  /// zu authentifizieren. In diesem Token sind ebenfalls weitere Informationen
  /// enthalten, wie z.B. Angabe, ob der Nutzer Jitsi-Moderator werden soll und
  /// somit das Meeting verwalten darf.
  ///
  /// Der Token wird beim Aufruf des Jitsi-Meetings der Url angefügt
  /// (siehe [getMeetingUrl]). Wenn die Seite vollständig geladen wurde, dann
  /// wird dieser automatisch aus der URL entfernt, damit die Gefahr nicht
  /// besteht, dass ein Nutzer die URL mit seinem Token teilt.
  Future<void> joinBrowserMeeting({
    @required String meetingId,
    @required String jwt,
  }) async {
    final url = getMeetingUrl(meetingId, jwt);
    await _urlLauncherExtended.tryLaunchOrThrow(url);
  }
}
