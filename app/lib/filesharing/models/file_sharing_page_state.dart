// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:key_value_store/key_value_store.dart';

enum FileSharingViewMode { list, grid }

/// The default view mode for the file sharing page.
///
/// Only used if the user has not set a view mode yet. Otherwise, the view mode
/// is fetched from the cache.
const FileSharingViewMode defaultViewMode = FileSharingViewMode.list;

abstract class FileSharingPageState {}

class FileSharingPageStateHome extends FileSharingPageState {}

const String _viewModeCacheKey = 'fileSharingViewMode';

/// Returns the [FileSharingViewMode] from the cache.
///
/// If the user has not set a view mode yet, returns [null].
FileSharingViewMode? getViewModeFromCache(KeyValueStore keyValueStore) {
  final viewMode = keyValueStore.getString(_viewModeCacheKey);
  if (viewMode == null) return null;
  return FileSharingViewMode.values.byName(viewMode);
}

void setViewModeToCache(
  KeyValueStore keyValueStore,
  FileSharingViewMode viewMode,
) {
  keyValueStore.setString(_viewModeCacheKey, viewMode.name);
}

class FileSharingPageStateGroup extends FileSharingPageState {
  final String groupID;
  final FolderPath path;
  final FileSharingData? initialFileSharingData;
  final FileSharingViewMode viewMode;

  FileSharingPageStateGroup({
    required this.groupID,
    required this.path,
    required this.initialFileSharingData,
    required FileSharingViewMode? viewMode,
  }) : viewMode = viewMode ?? defaultViewMode;

  FileSharingPageStateGroup copyWith({
    String? groupID,
    FolderPath? path,
    FileSharingData? initialFileSharingData,
    FileSharingViewMode? viewMode,
  }) {
    return FileSharingPageStateGroup(
      groupID: groupID ?? this.groupID,
      path: path ?? this.path,
      initialFileSharingData:
          initialFileSharingData ?? this.initialFileSharingData,
      viewMode: viewMode ?? this.viewMode,
    );
  }
}
