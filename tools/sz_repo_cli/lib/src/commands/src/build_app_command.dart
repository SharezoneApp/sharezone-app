// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sz_repo_cli/src/common/common.dart';

class BuildAppCommand extends CommandBase {
  BuildAppCommand(super.context);

  @override
  String get description => 'Build the Sharezone app in release mode.';

  @override
  String get name => 'app';
}
