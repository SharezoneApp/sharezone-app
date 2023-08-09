// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_common/helper_functions.dart';

enum GroupType { course, schoolclass }

GroupType groupTypeFromString(String data) =>
    enumFromString(GroupType.values, data, orElse: GroupType.course);
String groupTypeToString(GroupType groupType) => enumToString(groupType);
