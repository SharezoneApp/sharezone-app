// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';

typedef SharezoneAnimatedStreamListItemBuilder<T> = Widget Function(
  T item,
  int index,
  BuildContext context,
  Animation<double> animation,
);

class SharezoneAnimatedStreamList<E> extends StatelessWidget {
  const SharezoneAnimatedStreamList({
    super.key,
    required this.listStream,
    required this.itemBuilder,
    required this.itemRemovedBuilder,
    required this.emptyListWidget,
    this.isListEmptyStream,
    this.height,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.initialList,
  });

  final Stream<List<E>> listStream;
  final List<E>? initialList;
  final Stream<bool>? isListEmptyStream;

  final Widget emptyListWidget;
  final double? height;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;

  final SharezoneAnimatedStreamListItemBuilder<E> itemBuilder;
  final SharezoneAnimatedStreamListItemBuilder<E> itemRemovedBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<E>>(
      initialData: initialList,
      future: listStream.first,
      builder: (context, future) {
        if (!future.hasData) return emptyListWidget;
        return StreamBuilder<bool>(
          stream: isListEmptyStream,
          builder: (context, snapshot) {
            final streamListEmpty = snapshot.data ?? true;
            if (streamListEmpty) return emptyListWidget;
            return SizedBox(
              height: height,
              child: AnimatedStreamList<E>(
                initialList: future.data,
                padding: padding,
                streamList: listStream,
                scrollDirection: scrollDirection,
                itemBuilder: itemBuilder,
                itemRemovedBuilder: itemRemovedBuilder,
              ),
            );
          },
        );
      },
    );
  }
}
