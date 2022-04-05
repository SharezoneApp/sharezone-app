// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:meta/meta.dart';

abstract class FileSharingPageState {}

class FileSharingPageStateHome extends FileSharingPageState {}

class FileSharingPageStateGroup extends FileSharingPageState {
  final String groupID;
  final FolderPath path;
  final FileSharingData initialFileSharingData;

  FileSharingPageStateGroup({
    @required this.groupID,
    @required this.path,
    @required this.initialFileSharingData,
  });
}
