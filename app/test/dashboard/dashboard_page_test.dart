// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:convert';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:intl/intl.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:sharezone/dashboard/dashboard_page.dart';
import 'package:sharezone/models/extern_apis/holiday.dart';

class FakeHolidayBloc extends Fake implements HolidayBloc {
  StreamController<bool> hasStateSelectedController = StreamController();
  StreamController<List<Holiday>> holidaysController = StreamController();

  @override
  Stream<List<Holiday>> get holidays => holidaysController.stream;

  @override
  Stream<bool> get hasStateSelected => hasStateSelectedController.stream;

  @override
  void dispose() {
    holidaysController.close();
    hasStateSelectedController.close();
  }
}

void main() {
  group('DashboardPage', () {
    testGoldens('displays holiday card as excepted', (tester) async {
      final holidayBloc = FakeHolidayBloc();
      addTearDown(holidayBloc.dispose);

      final now = DateTime.now();
      final firstHolidays = Holiday.fromJson(jsonEncode({
        "start": "${DateFormat('yyyy-MM-dd').format(now)}",
        "end": "${now.year + 1}-02-01",
        "year": now.year,
        "stateCode": "HB",
        "name": "winterferien, aber mit einem sehr langen Namen",
        "slug": "winterferien 2022-2022-HB"
      }));

      final secondHolidays = Holiday.fromJson(jsonEncode({
        "start":
            "${DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 20)))}",
        "end": "${now.year + 1}-02-01",
        "year": now.year,
        "stateCode": "HB",
        "name": "osterferien",
        "slug": "osterferien 2022-2022-HB"
      }));

      holidayBloc.holidaysController.add([firstHolidays, secondHolidays]);
      holidayBloc.hasStateSelectedController.add(true);

      await tester.pumpWidget(
        BlocProvider<HolidayBloc>(
          bloc: holidayBloc,
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: HolidayCountdownSection(),
              ),
            ),
          ),
        ),
      );

      await multiScreenGolden(tester, 'holiday_card', devices: [Device.phone]);
    });
  });
}
