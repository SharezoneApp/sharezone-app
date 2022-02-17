// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/pages/settings/changelog/change.dart';
import 'package:sharezone/pages/settings/changelog/changelog_gateway.dart';
import 'package:sharezone/util/platform_information_manager/platform_information_receiver.dart';

import 'release.dart';

class UpdateReminderBloc extends BlocBase {
  final Future<Release> Function() getLatestRelease;
  final Future<Version> Function() getCurrentVersion;
  final Duration updateGracePeriod;
  final DateTime Function() getCurrentDateTime;
  final CrashAnalytics crashAnalytics;

  factory UpdateReminderBloc({
    @required ChangelogGateway changelogGateway,
    @required PlatformInformationReceiver platformInformationRetreiver,
    @required CrashAnalytics crashAnalytics,

    /// Die Zeitspanne nach einem neuen Release, wo noch keine Update-Karte
    /// angezeigt werden soll.
    /// Falls beispielsweise ein Release am 02.02.2020 veröffentlich wird und
    /// die Grace-Periode 2 Tage beträgt, wird bis zum 04.02.2020 noch keine
    /// Update-Karte angezeigt, danach schon.
    @required Duration updateGracePeriod,
  }) {
    return UpdateReminderBloc.internal(
      getLatestRelease: () => changelogGateway
          .loadChange(to: 1)
          .then((change) => change.first.toChange()),
      getCurrentVersion: () => platformInformationRetreiver
          .init()
          .then((_) => Version(name: platformInformationRetreiver.version)),
      updateGracePeriod: updateGracePeriod,
      getCurrentDateTime: () => DateTime.now(),
      crashAnalytics: crashAnalytics,
    );
  }

  @visibleForTesting
  UpdateReminderBloc.internal({
    @required this.getLatestRelease,
    @required this.getCurrentVersion,
    @required this.updateGracePeriod,
    @required this.getCurrentDateTime,
    this.crashAnalytics,
  });

  /// Gibt zurück ob dem Nutzer ein Hinweis angezeigt werden soll, dass ein
  /// neues Update verfügbar ist.
  /// Falls nicht geladen werden kann was die neueste Version ist, dann wird
  /// false zurückgegeben.
  Future<bool> shouldRemindToUpdate() async {
    Release latestRelease;
    try {
      // Ich bin mir nicht sicher, ob es mit Firestore überhaupt jemals zu dem
      // Fall kommen könnte, aber sicherheitshalber habe ich es mal eingebaut.
      latestRelease = await getLatestRelease();
    } on Exception catch (e, s) {
      crashAnalytics?.recordError(e, s);
      return false;
    }
    // Version auf diesem Gerät
    final currentVersion = await getCurrentVersion();

    // Falls der Changelog noch nicht eingetragen wurde kann currentVersion
    // neuer als die vom latestRelease sein.
    final userHasNewestVerion = currentVersion >= latestRelease.version;

    return !userHasNewestVerion &&
        _hasLatestReleaseSurpassedGracePeriod(latestRelease);
  }

  bool _hasLatestReleaseSurpassedGracePeriod(Release latestChange) {
    final now = getCurrentDateTime();
    return now.difference(latestChange.releaseDate) > updateGracePeriod;
  }

  @override
  void dispose() {}
}
