// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/pages/settings/changelog/change.dart';
import 'package:sharezone/pages/settings/changelog/change_view.dart';
import 'package:sharezone/pages/settings/changelog/changelog_gateway.dart';
import 'package:sharezone/pages/settings/changelog/changelog_page_view.dart';
import 'package:sharezone/util/platform_information_manager/platform_information_receiver.dart';

class ChangelogBloc extends BlocBase {
  final ChangelogGateway _gateway;
  final PlatformInformationReceiver _platformInformationManager;
  final _changesSubject = BehaviorSubject<ChangelogPageView>();
  final int numberOfInitialChanges;

  ChangelogBloc(this._gateway, this._platformInformationManager,
      [this.numberOfInitialChanges = 4]) {
    elementsToLoad += numberOfInitialChanges;
    _start();
  }

  Future<void> _start() async {
    await _platformInformationManager.init();
    final view = await _loadChangelogData(to: numberOfInitialChanges);
    _changesSubject.add(view);
  }

  int elementsToLoad = 0;

  void loadNext([int numberOfChangesToLoad = 3]) =>
      _loadNext(numberOfChangesToLoad);

  Future<void> _loadNext(int numberOfChangesToLoad) async {
    elementsToLoad += numberOfChangesToLoad;
    final changelogPageView = await _loadChangelogData(to: elementsToLoad);
    _changesSubject.add(changelogPageView);
  }

  Future<ChangelogPageView> _loadChangelogData(
      {int from = 0, @required int to}) async {
    assert(from <= to);
    final currentVersion = Version(name: _platformInformationManager.version);

    final dbModels = await _gateway.loadChange(from: from, to: to);
    final changes = dbModels.map((model) => model.toChange()).toList();
    for (final change in changes) {
      change.currentUserVersion = currentVersion;
    }

    bool allChangesLoaded = changes.length < (to - from);

    final userHasNewestVersion =
        changes.where((change) => change.version > currentVersion).isEmpty;

    final changeViews = changes
        .map((model) => ChangeView.fromModel(model, currentVersion))
        .toList();

    return ChangelogPageView(
      changes: changeViews,
      userHasNewestVersion: userHasNewestVersion,
      allChangesLoaded: allChangesLoaded,
    );
  }

  Stream<ChangelogPageView> get changes => _changesSubject;

  @override
  void dispose() {
    _changesSubject.close();
  }
}
