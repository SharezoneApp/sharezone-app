// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/dashboard/update_reminder/release.dart';
import 'package:sharezone/dashboard/update_reminder/update_reminder_bloc.dart';
import 'package:sharezone/pages/settings/changelog/change.dart';

void main() {
  group('UpdateReminderBloc', () {
    UpdateReminderBloc bloc;
    Version currentVersion;
    Release latestRelease;
    Duration gracePeriod;
    DateTime Function() getCurrentDateTime;

    setUp(() {
      gracePeriod = Duration(days: 3);
      bloc = UpdateReminderBloc.internal(
        getCurrentVersion: () async => currentVersion,
        getLatestRelease: () async => latestRelease,
        updateGracePeriod: gracePeriod,
        getCurrentDateTime: () => getCurrentDateTime(),
      );
    });

    UpdateReminderBloc blocWithGracePeriodOf(Duration gracePeriod) {
      return UpdateReminderBloc.internal(
        getCurrentVersion: () async => currentVersion,
        getLatestRelease: () async => latestRelease,
        updateGracePeriod: gracePeriod,
        getCurrentDateTime: () => getCurrentDateTime(),
      );
    }

    test(
        'should prompt for Update if current version is old and not in the grace period',
        () async {
      // Arrange
      currentVersion = Version.parse(name: '1.3.4');

      getCurrentDateTime = () => DateTime(2020, 02, 07);
      final bloc = blocWithGracePeriodOf(Duration(days: 3));
      latestRelease =
          _releaseWith(version: '1.3.5', releaseTime: DateTime(2020, 02, 03));

      // Act
      final shouldShowReminder = await bloc.shouldRemindToUpdate();

      // Assert
      expect(shouldShowReminder, true,
          reason:
              'Da die neue Version vor vier Tagen (am 03.02.2020) released wurde '
              'und die "grace-period" bis der Update-Reminder angezeigt werden '
              'soll 3 Tage beträgt, sollte heute (am 07.02.2020) der '
              'Update-Reminder angezeigt werden.');
    });

    test(
        'should not prompt for Update if current version is old but the release date is still within the given grace period',
        () async {
      // Arrange
      currentVersion = Version.parse(name: '1.3.4');

      getCurrentDateTime = () => DateTime(2020, 02, 04);
      final bloc = blocWithGracePeriodOf(Duration(days: 3));
      latestRelease =
          _releaseWith(version: '1.3.5', releaseTime: DateTime(2020, 02, 03));

      // Act
      final shouldShowReminder = await bloc.shouldRemindToUpdate();

      // Assert
      expect(shouldShowReminder, false,
          reason:
              'Da die neue Version vor einem Tag (am 03.02.2020) released wurde '
              'und die "grace-period" bis der Update-Reminder angezeigt werden '
              'soll 3 Tage beträgt, sollte heute (am 04.02.2020) der '
              'Update-Reminder noch nicht angezeigt werden.');
    });

    test(
        'should not prompt for Update if the current version is newer than latest release loaded (can happen if update is not manually to DB added before releasing via app and playstore)',
        () async {
      currentVersion = Version.parse(name: '1.3.5');
      latestRelease = _releaseWith(version: '1.3.4');

      // Act
      final shouldShowReminder = await bloc.shouldRemindToUpdate();

      // Assert
      expect(shouldShowReminder, false);
    });

    test('should not prompt for Update if current version is newest', () async {
      // Arrange
      final release = _releaseWith(version: '1.3.4');
      currentVersion = release.version;
      latestRelease = release;

      // Act
      final shouldShowReminder = await bloc.shouldRemindToUpdate();

      // Assert
      expect(shouldShowReminder, false);
    });

    UpdateReminderBloc blocWithGetLatestReleaseThrowing(Exception toThrow) {
      return UpdateReminderBloc.internal(
        getCurrentVersion: () async => currentVersion,
        getLatestRelease: () async => throw toThrow,
        updateGracePeriod: gracePeriod,
        getCurrentDateTime: () => getCurrentDateTime(),
      );
    }

    test('should not prompt if latest Release cant be loaded', () async {
      // Arrange
      final bloc =
          blocWithGetLatestReleaseThrowing(Exception('Test-Exception'));
      currentVersion = Version.parse(name: '1.7.3');

      // Act
      final shouldShowReminder = await bloc.shouldRemindToUpdate();

      // Assert
      expect(shouldShowReminder, false);
    });
  });
}

Release _releaseWith({@required String version, DateTime releaseTime}) {
  return Release(
      version: Version.parse(name: version),
      releaseDate:
          releaseTime ?? DateTime(2020, 02, Random.secure().nextInt(25) + 1));
}
