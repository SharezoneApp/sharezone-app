// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../preference/preference.dart';

/// A function that builds a widget whenever a [Preference] has a new value.
typedef PreferenceWidgetBuilder<T> = Function(BuildContext context, T value);

/// PreferenceBuilder is exactly like a [StreamBuilder] but without the need to
/// provide `initialData`. It also solves the initial flicker problem that happens
/// when a [StreamBuilder] transitions from its `initialData` to the values in
/// it `stream`.
///
/// If the preference has a persisted non-null value, the initial build will be
/// done with that value. Otherwise the initial build will be done with the
/// `defaultValue` of the [preference].
///
/// If a [preference] emits a value identical to the last emitted value, [builder]
/// will not be called as it would be unnecessary to do so.
class PreferenceBuilder<T> extends StatefulWidget {
  PreferenceBuilder({
    @required this.preference,
    @required this.builder,
  })  : assert(preference != null, 'Preference must not be null.'),
        assert(builder != null, 'PreferenceWidgetBuilder must not be null.');

  /// The preference on which you want to react and rebuild your widgets based on.
  final Preference<T> preference;

  /// The function that builds a widget when a [preference] has new data.
  final PreferenceWidgetBuilder<T> builder;

  @override
  _PreferenceBuilderState<T> createState() => _PreferenceBuilderState<T>();
}

class _PreferenceBuilderState<T> extends State<PreferenceBuilder<T>> {
  T _initialData;
  Stream<T> _preference;

  @override
  void initState() {
    super.initState();
    _initialData = widget.preference.getValue();
    _preference =
        widget.preference.transform(_EmitOnlyChangedValues(_initialData));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: _initialData,
      stream: _preference,
      builder: (context, snapshot) => widget.builder(context, snapshot.data),
    );
  }
}

/// Makes sure that [PreferenceBuilder] does not run its builder function if the
/// new value is identical to the last one.
class _EmitOnlyChangedValues<T> extends StreamTransformerBase<T, T> {
  _EmitOnlyChangedValues(this.startValue);
  final T startValue;

  @override
  Stream<T> bind(Stream<T> stream) {
    return StreamTransformer<T, T>((input, cancelOnError) {
      T lastValue = startValue;

      StreamController<T> controller;
      StreamSubscription<T> subscription;

      controller = StreamController<T>(
        sync: true,
        onListen: () {
          subscription = input.listen(
            (value) {
              if (value != lastValue) {
                controller.add(value);
                lastValue = value;
              }
            },
            onError: controller.addError,
            onDone: controller.close,
            cancelOnError: cancelOnError,
          );
        },
        onPause: ([resumeSignal]) => subscription.pause(resumeSignal),
        onResume: () => subscription.resume(),
        onCancel: () {
          lastValue = null;
          return subscription.cancel();
        },
      );

      return controller.stream.listen(null);
    }).bind(stream);
  }
}
