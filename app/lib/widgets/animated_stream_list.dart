// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:flutter/material.dart';

typedef SharezoneAnimatedStreamListItemBuilder<T> =
    Widget Function(
      T item,
      int index,
      BuildContext context,
      Animation<double> animation,
    );

class SharezoneAnimatedStreamList<E> extends StatefulWidget {
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
  State<SharezoneAnimatedStreamList<E>> createState() =>
      _SharezoneAnimatedStreamListState<E>();
}

class _SharezoneAnimatedStreamListState<E>
    extends State<SharezoneAnimatedStreamList<E>> {
  late Future<List<E>> _initialListFuture;

  @override
  void initState() {
    super.initState();
    _initialListFuture = widget.listStream.first;
  }

  @override
  void didUpdateWidget(SharezoneAnimatedStreamList<E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listStream != oldWidget.listStream) {
      _initialListFuture = widget.listStream.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<E>>(
      initialData: widget.initialList,
      future: _initialListFuture,
      builder: (context, future) {
        if (!future.hasData) return widget.emptyListWidget;
        return StreamBuilder<bool>(
          stream: widget.isListEmptyStream,
          builder: (context, snapshot) {
            final streamListEmpty = snapshot.data ?? true;
            if (streamListEmpty) return widget.emptyListWidget;
            return SizedBox(
              height: widget.height,
              child: AnimatedStreamList<E>(
                initialList: future.data,
                padding: widget.padding,
                streamList: widget.listStream,
                scrollDirection: widget.scrollDirection,
                itemBuilder: widget.itemBuilder,
                itemRemovedBuilder: widget.itemRemovedBuilder,
              ),
            );
          },
        );
      },
    );
  }
}
