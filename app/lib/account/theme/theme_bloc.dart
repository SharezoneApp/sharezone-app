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
import 'package:sharezone/util/theme/brightness_cache.dart';

import 'theme_brightness.dart';

class ThemeBloc extends BlocBase {
  final BrightnessCache brightnessCache;
  final _themeBrightnessSubject = BehaviorSubject<ThemeBrightness>();
  Stream<ThemeBrightness> get themeBrightness => _themeBrightnessSubject;

  ThemeBloc({@required this.brightnessCache}) {
    brightnessCache.brightness.listen((brightness) {
      _themeBrightnessSubject.sink.add(brightness);
    });
  }

  void changeThemeBrightness(ThemeBrightness brightness) =>
      brightnessCache.setBrightness(brightness);

  @override
  void dispose() {
    _themeBrightnessSubject.close();
  }
}
