// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/pages/settings/changelog/list_with_bottom_threshold.dart';

void main() {
  group('ListWithBottomThreshold', () {
    group("given no children", () {
      testWidgets("shows LoadingWidget", (WidgetTester tester) async {
        Widget loadingWidget = const CircularProgressIndicator();
        final list = Directionality(
          textDirection: TextDirection.ltr,
          child: ListWithBottomThreshold(loadingIndicator: loadingWidget),
        );
        await tester.pumpWidget(list);
        expect(find.byWidget(loadingWidget), findsOneWidget);
      });

      testWidgets('fires onThresholdExceeded when no children are passed',
          (WidgetTester tester) async {
        bool fired = false;
        final list = Directionality(
          textDirection: TextDirection.ltr,
          child: ListWithBottomThreshold(
            onThresholdExceeded: () {
              fired = true;
            },
          ),
        );
        await tester.pumpWidget(list);
        expect(fired, true);
      });
    });
    testWidgets("The default loadingIndicator is a CircularLoadingIndicator",
        (tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: ListWithBottomThreshold(),
      ));
      expect(
          find.byWidgetPredicate(
              (widget) => widget is CircularProgressIndicator),
          findsOneWidget);
    });
    group('scrolling tests:', () {
      const childHeight = 100.0;
      const nrOfChildren = 20;
      final container = Container(
        height: childHeight,
        color: Colors.red,
      );
      final children = List.filled(
        nrOfChildren,
        container,
      );

      const completeListHeight = childHeight * nrOfChildren;

      const viewSize = Size(800, 600);
      const listThreshold = 200.0;

      double getDistanceFromBottomOfViewToBottomOfList(WidgetTester tester) {
        final viewHeight = viewSize.height;
        final distanceFromBottomOfViewToBottomOfList =
            completeListHeight - viewHeight;

        return distanceFromBottomOfViewToBottomOfList;
      }

      double getDistanceFromViewToThreshold(WidgetTester tester) {
        final distanceFromViewToThreshold =
            getDistanceFromBottomOfViewToBottomOfList(tester) - listThreshold;

        return distanceFromViewToThreshold;
      }

      const loadingWidgetHeight = 20.0;
      Widget loadingWidget = const SizedBox(height: loadingWidgetHeight);
      Widget? infiniteScrollingList;

      Future<void> scrollList(
          WidgetTester tester, double distanceFromViewToThreshold,
          [Widget? list]) async {
        await tester.drag(find.byWidget(list ?? infiniteScrollingList!),
            Offset(0, -distanceFromViewToThreshold));
        await tester.pumpAndSettle();
      }

      Future<void> scrollListPastThreshold(WidgetTester tester,
          [Widget? list]) async {
        await scrollList(
            tester, getDistanceFromViewToThreshold(tester) + 1000, list);
      }

      void testAndPumpList(String description,
          Future<void> Function(WidgetTester widgetTester) callback) {
        testWidgets(description, (WidgetTester tester) async {
          await tester.pumpWidget(infiniteScrollingList!);
          await callback(tester);
        });
      }

      bool? fired;
      setUp(() {
        fired = false;
        infiniteScrollingList = Directionality(
            textDirection: TextDirection.ltr,
            child: ListWithBottomThreshold(
              onThresholdExceeded: () => fired = true,
              thresholdHeight: listThreshold,
              loadingIndicator: loadingWidget,
              children: children,
            ));
      });

      testAndPumpList(
          "should not fire when being before and scrolling on threshold",
          (tester) async {
        await scrollList(tester, getDistanceFromViewToThreshold(tester));
        expect(fired, false);
      });

      testAndPumpList("should fire when scrolling over threshold",
          (tester) async {
        await scrollListPastThreshold(tester);

        expect(fired, true);
      });

      testWidgets(
          "should lazy load even if not enough children are in the list to be able to scroll",
          (tester) async {
        // Before this implementation the callback was only called if there were enough children to
        // be able to scroll, as else the ScrollController which was/is used internally
        // would not be fire its callback

        bool fired = false;

        final list = Directionality(
          textDirection: TextDirection.ltr,
          child: ListWithBottomThreshold(
            loadingIndicator: const SizedBox(
              height: 50,
            ),
            thresholdHeight: listThreshold,
            onThresholdExceeded: () => fired = true,
            children: List.filled(2, container),
          ),
        );

        await tester.pumpWidget(list);

        await scrollListPastThreshold(tester, list);

        expect(fired, true);
      });

      testAndPumpList("should fire only once", (tester) async {
        await scrollListPastThreshold(tester);

        fired = false;

        final distanceFromViewToThreshold =
            getDistanceFromViewToThreshold(tester);
        await scrollList(tester, -distanceFromViewToThreshold);
        await scrollList(tester, distanceFromViewToThreshold);
        await scrollList(tester, 200);

        expect(fired, false);
      });

      testAndPumpList("shows loadingIndicator at the end of the list",
          (tester) async {
        expect(find.byWidget(loadingWidget), findsNothing);

        await scrollList(
            tester,
            getDistanceFromBottomOfViewToBottomOfList(tester) +
                loadingWidgetHeight);

        expect(find.byWidget(loadingWidget), findsOneWidget);
      });

      testWidgets("Should not throw if no callback was passed", (tester) async {
        final list = Directionality(
          textDirection: TextDirection.ltr,
          child: ListWithBottomThreshold(
            loadingIndicator: Container(),
            children:
                children, // So pumpAndSettle does not wait for an animation to finish.
          ),
        );

        await tester.pumpWidget(list);

        await scrollListPastThreshold(tester, list);
      });

      testWidgets(
          'The size of the loading indicator does not effect the position of the threshold',
          (tester) async {
        bool fired = false;

        final list = Directionality(
          textDirection: TextDirection.ltr,
          child: ListWithBottomThreshold(
            loadingIndicator: const SizedBox(
              height: 5000,
            ),
            thresholdHeight: listThreshold,
            onThresholdExceeded: () => fired = true,
            children: List.filled(20, container),
          ),
        );

        await tester.pumpWidget(list);

        await scrollListPastThreshold(tester, list);

        expect(fired, true);
      });

      testWidgets(
          "should show the loading indicator if not enough children are in the list to fill the screen",
          (tester) async {
        final list = Directionality(
          textDirection: TextDirection.ltr,
          child: ListWithBottomThreshold(
            loadingIndicator: loadingWidget,
            thresholdHeight: listThreshold,
            children: List.filled(2, container),
          ),
        );

        await tester.pumpWidget(list);

        expect(find.byWidget(loadingWidget), findsOneWidget);
      });
    });
  });
}
