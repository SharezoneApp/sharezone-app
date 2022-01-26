// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharezone/pages/settings/changelog/change.dart';
import 'package:sharezone/pages/settings/changelog/change_database_model.dart';
import 'package:sharezone/pages/settings/changelog/change_view.dart';
import 'package:sharezone/pages/settings/changelog/changelog_bloc.dart';
import 'package:sharezone/pages/settings/changelog/changelog_gateway.dart';
import 'package:sharezone/pages/settings/changelog/changelog_page_view.dart';
import 'package:sharezone/util/platform_information_manager/platform_information_retreiver.dart';
import 'package:test/test.dart';

void main() {
  test('paginated loading', () async {
    final _gateway = LocalChangeGateway();
    final _platformInformationManager = MockInformationManager();
    final bloc = ChangelogBloc(_gateway, _platformInformationManager, 3);
    StreamQueue<ChangelogPageView> queue =
        StreamQueue<ChangelogPageView>(bloc.changes);
    final firstLoad = await queue.next;
    expect(firstLoad.userHasNewestVersion, false);
    expect(firstLoad.changes.length, 3);
    expect(firstLoad.changes[1].version, second.version);
    expect(firstLoad.changes[1].isNewerThanCurrentVersion, true);

    bloc.loadNext(3);
    final secondLoad = await queue.next;
    expect(secondLoad.userHasNewestVersion, false);
    expect(secondLoad.changes.length, 6);
    expect(secondLoad.changes[1].version, firstLoad.changes[1].version);
    expect(secondLoad.changes[5].version, sixth.version);
    expect(secondLoad.changes[5].isNewerThanCurrentVersion, false);
  });

  test('version', () {
    expect(Version(name: "3.0.0") > Version(name: "1.0.0"), true);
    expect(Version(name: "3.0.0") < Version(name: "1.0.0"), false);
    expect(Version(name: "3.0.0") == Version(name: "1.0.0"), false);
    expect(Version(name: "3.0.0") == Version(name: "3.0.0"), true);
    expect(Version(name: "3.0.1") >= Version(name: "3.0.0"), true);
    expect(Version(name: "3.0.0") >= Version(name: "3.0.0"), true);
    expect(Version(name: "2.9.9") >= Version(name: "3.0.0"), false);
    expect(Version(name: "2.9.9") <= Version(name: "3.0.0"), true);
    expect(Version(name: "3.0.0") <= Version(name: "3.0.0"), true);
    expect(Version(name: "3.0.1") <= Version(name: "3.0.0"), false);
  });
}

class LocalChangeGateway implements ChangelogGateway {
  List<ChangeDatabaseModel> changes = mockData;

  @override
  Future<List<ChangeDatabaseModel>> loadChange({int from = 0, int to}) async {
    return changes.sublist(from, to);
  }

  @override
  CollectionReference<Map<String, dynamic>> get changelogCollection =>
      throw UnimplementedError();
}

class MockInformationManager extends PlatformInformationRetreiver {
  @override
  String get appName => "Sharezone";

  @override
  Future<void> init() {
    return null;
  }

  @override
  String get packageName => "Sharezone";

  @override
  String get version => "3.0.0";

  @override
  String get versionNumber => "300";
}

ChangeView asView(ChangeDatabaseModel model) =>
    ChangeView(version: model.version);

final first = ChangeDatabaseModel.create().copyWith(version: "6.0.0");
final second = ChangeDatabaseModel.create().copyWith(version: "5.0.0");
final third = ChangeDatabaseModel.create().copyWith(version: "4.0.0");
final fourth = ChangeDatabaseModel.create().copyWith(version: "3.0.0");
final fifth = ChangeDatabaseModel.create().copyWith(version: "2.0.0");
final sixth = ChangeDatabaseModel.create().copyWith(version: "1.0.0");

final mockData = [
  first,
  second,
  third,
  fourth,
  fifth,
  sixth,
];
