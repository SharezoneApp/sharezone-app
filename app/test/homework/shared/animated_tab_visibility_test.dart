// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/homework/shared/animated_tab_visibility.dart';

class TrackingTabController extends TabController {
  TrackingTabController({required super.length, required super.vsync});

  int listenerCount = 0;

  @override
  void addListener(VoidCallback listener) {
    listenerCount++;
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    listenerCount--;
    super.removeListener(listener);
  }
}

void main() {
  group('AnimatedTabVisibility', () {
    testWidgets('should not leak listeners on rebuild', (tester) async {
      final controller = TrackingTabController(
        length: 2,
        vsync: const TestVSync(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: AnimatedTabVisibility(
              tabController: controller,
              visibleInTabIndicies: const [0],
              child: const SizedBox(),
            ),
          ),
        ),
      );

      final initialListeners = controller.listenerCount;
      // We expect at least one listener from AnimatedTabVisibility
      expect(initialListeners, greaterThanOrEqualTo(1));

      // Trigger a rebuild
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: AnimatedTabVisibility(
              tabController: controller,
              visibleInTabIndicies: const [0],
              child: const SizedBox(),
            ),
          ),
        ),
      );

      final newListeners = controller.listenerCount;

      // If there is a leak, newListeners will be greater than initialListeners
      // Because build() adds a listener every time, but none are removed.
      expect(
        newListeners,
        initialListeners,
        reason: 'Listener count increased after rebuild, indicating a leak',
      );

      controller.dispose();
    });

    testWidgets('should update visibility when tab changes', (tester) async {
      final controller = TabController(length: 2, vsync: const TestVSync());

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: AnimatedTabVisibility(
              tabController: controller,
              visibleInTabIndicies: const [0],
              child: const Text('Content'),
            ),
          ),
        ),
      );

      // Initially visible (index 0)
      expect(find.text('Content'), findsOneWidget);
      // We need to check opacity/visibility. AnimatedVisibility uses AnimatedOpacity.
      // If visible, opacity should be 1.

      // Switch tab to 1
      controller.animateTo(1);
      await tester.pumpAndSettle();

      // Now should be hidden. AnimatedVisibility might keep it in tree but with opacity 0 or Visibility gone.
      // Current implementation: AnimatedOpacity -> Visibility.
      // If hidden, Visibility visible=false.
      // Visibility usually replaces child with SizedBox.shrink or maintains state.
      // Default maintainState is false. So 'Content' should be gone or offstage.

      // But verify that it hides.
      // Since it uses AnimatedOpacity, we can check for that or check if child is not found (if Visibility removes it).

      // Wait, if visibility is false, Visibility removes the child from the tree unless maintainState is true.
      // AnimatedTabVisibility defaults maintainState to false.
      // However, AnimatedVisibility has a fade out duration.
      // After pumpAndSettle, animation is done.

      // Let's check if 'Content' is present.
      // If Visibility hides it, it should be gone.
      expect(find.text('Content'), findsNothing);

      controller.dispose();
    });
  });
}
