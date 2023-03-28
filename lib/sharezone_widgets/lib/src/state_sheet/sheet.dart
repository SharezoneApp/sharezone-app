// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/common_widgets.dart';
import '../../wrapper.dart';
import 'state_sheet_content.dart';

class StateSheet {
  final Stream<StateSheetContent> stateSheetContent;

  const StateSheet(this.stateSheetContent);

  Future<void> showSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return _DraggableStateSheetWidget(stateSheetContent: stateSheetContent);
      },
    );
  }

  Future<void> showSheetAutoPop(
    BuildContext context, {
    @required Future<bool> future,
    Duration delay,
  }) async {
    final sheetPop = showSheet(context);
    bool hasSheetPopped = false;
    sheetPop.then((_) => hasSheetPopped = true);
    future.then((result) async {
      if (result == true) {
        await Future.delayed(delay);
        if (!hasSheetPopped) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      }
    });
  }
}

class _DraggableStateSheetWidget extends StatelessWidget {
  final Stream<StateSheetContent> stateSheetContent;

  const _DraggableStateSheetWidget({Key key, this.stateSheetContent})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.3,
      initialChildSize: 0.5,
      maxChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return _DraggableStateSheetInner(
          scrollController: scrollController,
          stateSheetContent: stateSheetContent,
        );
      },
    );
  }
}

class _DraggableStateSheetInner extends StatelessWidget {
  final Stream<StateSheetContent> stateSheetContent;
  final ScrollController scrollController;

  const _DraggableStateSheetInner(
      {Key key, this.stateSheetContent, this.scrollController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Align(
        alignment: Alignment.topCenter,
        child: StreamBuilder<StateSheetContent>(
            stream: stateSheetContent,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              final content = snapshot.data;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 275),
                child: MaxWidthConstraintBox(
                  key: ValueKey(content),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: content.body,
                          ),
                        ),
                      ),
                      if (content.actions.isNotEmpty)
                        SafeArea(
                          child: ButtonBar(
                            children: <Widget>[
                              for (final action in content.actions)
                                ActionItemButton(item: action),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
