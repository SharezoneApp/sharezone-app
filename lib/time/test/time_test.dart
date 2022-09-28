// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:time/time.dart';

void main() {
  final am8 = Time(hour: 8, minute: 0);
  final am8_20 = Time(hour: 8, minute: 20);
  final am9 = Time(hour: 9, minute: 0);
  final am9_20 = Time(hour: 9, minute: 20);
  final am9_59 = Time(hour: 9, minute: 59);

  group('isAfter & isBefore', () {
    test('isAfter', () {
      expect(am8.isAfter(am9), false);
      expect(am8.isAfter(am8_20), false);
      expect(am8.isAfter(am9_20), false);
      expect(am8.isAfter(am8), false);
      expect(am9.isAfter(am8), true);
      expect(am9.isAfter(am8_20), true);
      expect(am9.isAfter(am9_20), false);
      expect(am8.isAfter(am8_20), false);
      expect(am8_20.isAfter(am9), false);
      expect(am8_20.isAfter(am8), true);
      expect(am9.isAfter(am9_59), false);
      expect(am9_59.isAfter(am9), true);
    });

    test('isBefore', () {
      expect(am8.isBefore(am9), true);
      expect(am8.isBefore(am8), false);
      expect(am9.isBefore(am8), false);
      expect(am8.isBefore(am8_20), true);
      expect(am8.isBefore(am9_20), true);
      expect(am9.isBefore(am9_20), true);
      expect(am9.isBefore(am8_20), false);
      expect(am9.isBefore(am9_59), true);
      expect(am9_59.isBefore(am9), false);
    });
  });

  test('.hour', () {
    expect(Time(hour: 0).hour, 0);
    expect(Time(hour: 1).hour, 1);
    expect(Time(hour: 1, minute: 1).hour, 1);
    expect(Time(hour: 1, minute: 12).hour, 1);
  });

  test('.minute', () {
    expect(Time(hour: 0, minute: 0).minute, 0);
    expect(Time(hour: 0, minute: 1).minute, 1);
    expect(Time(hour: 0, minute: 10).minute, 10);
    expect(Time(hour: 1, minute: 10).minute, 10);
  });

  test('.totalMinutes', () {
    expect(Time(hour: 0, minute: 0).totalMinutes, 0);
    expect(Time(hour: 0, minute: 1).totalMinutes, 1);
    expect(Time(hour: 0, minute: 10).totalMinutes, 10);
    expect(Time(hour: 1, minute: 10).totalMinutes, 70);
    expect(Time(hour: 1, minute: 0).totalMinutes, 60);
    expect(Time(hour: 1).totalMinutes, 60);
  });

  test('==', () {
    expect(Time(hour: 1, minute: 1), Time(hour: 1, minute: 1));
    expect(Time(hour: 0), Time(hour: 0));
    expect(Time(hour: 0) == Time(hour: 1), false);
  });

  test('.differenceInMinutes()', () {
    expect(Time(hour: 1).differenceInMinutes(Time(hour: 2)), 60);
    expect(Time(hour: 2).differenceInMinutes(Time(hour: 1)), 60);
    expect(
      Time(hour: 0, minute: 30).differenceInMinutes(Time(hour: 0, minute: 40)),
      10,
    );
  });

  test('.time', () {
    expect(Time(hour: 2).time, '02:00');
    expect(Time(hour: 2, minute: 1).time, '02:01');
    expect(Time(hour: 2, minute: 10).time, '02:10');
    expect(Time(hour: 12, minute: 59).time, '12:59');
  });

  test('.toString()', () {
    expect('${Time(hour: 2)}', '02:00');
    expect('${Time(hour: 2, minute: 1)}', '02:01');
    expect('${Time(hour: 2, minute: 10)}', '02:10');
    expect('${Time(hour: 12, minute: 59)}', '12:59');
  });

  test('.compareTo', () {
    expect(Time(hour: 5).compareTo(Time(hour: 5)), 0);
    expect(Time(hour: 5).compareTo(Time(hour: 0)), 1);
    expect(Time(hour: 0).compareTo(Time(hour: 5)), -1);
  });

  test('.copyWithAddedMinutes()', () {
    expect(Time(hour: 0).copyWithAddedMinutes((60)), Time(hour: 1));
    expect(Time(hour: 0).copyWithAddedMinutes(23), Time(hour: 0, minute: 23));
    expect(Time(hour: 0).copyWithAddedMinutes(70), Time(hour: 1, minute: 10));
    expect(
      Time(hour: 23).copyWithAddedMinutes(120),
      Time(hour: 1),
      skip:
          'Not working because .fromTotalMinutes() needs to do modulo 24. Ticket: https://github.com/SharezoneApp/sharezone-app/issues/303',
    );
  });

  test('plus operator', () {
    expect(am8.add(const Duration(minutes: 45)), Time(hour: 8, minute: 45));
    expect(am8.add(const Duration(minutes: 60)), Time(hour: 9, minute: 0));
    expect(am8.add(const Duration(minutes: 70)), Time(hour: 9, minute: 10));
    expect(am8.add(const Duration(minutes: 120)), Time(hour: 10, minute: 0));
    expect(am8.add(const Duration(minutes: 130)), Time(hour: 10, minute: 10));
    expect(Time(hour: 23, minute: 59).add(const Duration(minutes: 2)),
        Time(hour: 0, minute: 1));
  });
}
