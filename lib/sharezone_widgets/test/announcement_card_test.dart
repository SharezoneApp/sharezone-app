// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone_widgets/announcement_card.dart';
import 'package:sharezone_widgets/widgets.dart';

void main() {
  group('AnnouncementCard', () {
    Future<void> _pumpAnnouncementCard(
        {@required WidgetTester tester, @required Widget card}) async {
      assert(tester != null && card != null);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: card),
        ),
      );
    }

    testWidgets('shows given title', (tester) async {
      const title = 'title';
      await _pumpAnnouncementCard(
          tester: tester, card: const AnnouncementCard(title: title));

      expect(find.text('» $title'), findsOneWidget);
    });

    testWidgets('shows given actions', (tester) async {
      final action =
          TextButton(onPressed: () {}, child: const Text('FlatButton'));

      await _pumpAnnouncementCard(
          tester: tester, card: AnnouncementCard(actions: [action]));

      expect(find.byWidget(action), findsOneWidget);
    });

    testWidgets('shows given content', (tester) async {
      const content = Text('content');

      await _pumpAnnouncementCard(
          tester: tester, card: const AnnouncementCard(content: content));

      expect(find.byWidget(content), findsOneWidget);
    });

    testWidgets('shows a card with the given color', (tester) async {
      const color = Colors.brown;

      await _pumpAnnouncementCard(
          tester: tester, card: const AnnouncementCard(color: color));

      final card = tester.firstWidget<CustomCard>(find.byType(CustomCard));
      expect(card.color, color);
    });

    testWidgets('shows a card with the border radius', (tester) async {
      final borderRadius = BorderRadius.circular(1.5);

      await _pumpAnnouncementCard(
          tester: tester, card: AnnouncementCard(borderRadius: borderRadius));

      final card = tester.firstWidget<CustomCard>(find.byType(CustomCard));
      expect(card.borderRadius, borderRadius);
    });

    testWidgets('execute onTap if it is given', (tester) async {
      final log = <String>[];

      await _pumpAnnouncementCard(
        tester: tester,
        card: AnnouncementCard(
          onTap: () => log.add('tap'),
        ),
      );

      await tester.tap(find.byType(AnnouncementCard));

      await tester.pump(const Duration(seconds: 1));

      expect(log, equals(<String>['tap']));
    });
  });
}
