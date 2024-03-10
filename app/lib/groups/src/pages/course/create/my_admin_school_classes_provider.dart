// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/util/api/connections_gateway.dart';

class MyAdminSchoolClassesProvider extends ChangeNotifier {
  final ConnectionsGateway connectionsGateway;

  StreamSubscription<ConnectionsData?>? _connectionsDataSubscription;
  List<(SchoolClassId, SchoolClassName)> schoolClasses = [];

  MyAdminSchoolClassesProvider({
    required this.connectionsGateway,
  });

  void init() {
    final initialData = connectionsGateway.current();
    _setAdminSchoolClasses(initialData?.schoolClass);

    _connectionsDataSubscription =
        connectionsGateway.streamConnectionsData().listen((data) {
      _setAdminSchoolClasses(data?.schoolClass);
    });
  }

  void _setAdminSchoolClasses(Map<String, SchoolClass>? schoolClassesMap) {
    if (schoolClassesMap == null) {
      return;
    }

    schoolClasses.clear();
    for (var schoolClass in schoolClassesMap.values) {
      if (schoolClass.myRole.hasPermission(GroupPermission.administration)) {
        schoolClasses.add((SchoolClassId(schoolClass.id), schoolClass.name));
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _connectionsDataSubscription?.cancel();
    super.dispose();
  }
}
