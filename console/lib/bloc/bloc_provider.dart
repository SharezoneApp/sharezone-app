// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import 'bloc_base.dart';

// Generic BLoC provider
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  const BlocProvider({Key? key, this.child, required this.bloc})
    : super(key: key);

  final T bloc;
  final Widget? child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    // ignore: invalid_assignment
    final provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    assert(
      provider != null,
      """A BlocProvider ancestor with Type $type should be given in the widget tree.
If this is not true this propably means that BlocProvider.of<$T>(context)
was called while no BlocProvider with Type of $T was created in an 
ancestor widget.""",
    );
    return provider!.bloc;
  }

  static Type _typeOf<T>() => T;

  BlocProvider<T> copyWith(Widget child) {
    return BlocProvider<T>(key: key, bloc: bloc, child: child);
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
    return widget.child!;
  }
}

class MultiBlocProvider extends StatelessWidget {
  /// The [BlocProvider] list which is converted into
  /// a tree of [BlocProvider] widgets.
  ///
  /// The tree of [BlocProvider] widgets is created in order meaning
  /// the first [BlocProvider] will be the top-most [BlocProvider] and
  /// the last [BlocProvider] will be a direct ancestor of the [child] [Widget].
  ///
  /// Each provider's `child` will be discarded, so giving `child` to each
  /// provider makes no sense.
  final List<BlocProvider> blocProviders;

  /// The [Widget] and its descendants which will have access to
  /// every `BloC` provided by [blocProviders].
  ///
  /// This [Widget] will be a direct descendent of
  /// the last [BlocProvider] in [blocProviders].
  final WidgetBuilder child;

  const MultiBlocProvider({
    Key? key,
    required this.blocProviders,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tree = child(context);
    for (final blocProvider in blocProviders.reversed) {
      tree = blocProvider.copyWith(tree);
    }
    return tree;
  }
}
