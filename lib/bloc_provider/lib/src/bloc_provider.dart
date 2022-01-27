// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// Generic Interface for all BLoCs
import 'package:bloc_base/bloc_base.dart';
import 'package:flutter/material.dart';

// Generic BLoC provider
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  const BlocProvider({
    Key key,
    this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    // ignore: invalid_assignment
    final provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    assert(provider != null,
        """A BlocProvider ancestor with Type $type should be given in the widget tree.
If this is not true this propably means that BlocProvider.of<$T>(context)
was called while no BlocProvider with Type of $T was created in an 
ancestor widget.""");
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;

  BlocProvider<T> copyWith(Widget child) {
    return BlocProvider<T>(
      key: key,
      bloc: bloc,
      child: child,
    );
  }
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
