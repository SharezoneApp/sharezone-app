// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_common/helper_functions.dart';

// ProfileDisplayMode
enum ProfileDisplayMode { pic, avatar, none }
ProfileDisplayMode profileDisplayModeEnumFromString(String data) =>
    enumFromString(ProfileDisplayMode.values, data);
String profileDisplayModeEnumToString(ProfileDisplayMode displayMode) =>
    enumToString(displayMode);
