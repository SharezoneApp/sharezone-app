// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sz_repo_cli/src/common/common.dart';

class DeployAppCommand extends CommandBase {
  DeployAppCommand(super.context);

  @override
  String get description => 'Deploy the Sharezone app.';

  @override
  String get name => 'app';
}
