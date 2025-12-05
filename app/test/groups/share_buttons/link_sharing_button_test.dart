// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/src/widgets/group_share.dart';
import 'package:platform_check/platform_check.dart';

void main() {
  group(
    'LinkSharingButton',
    () {
      GroupInfo createGroupInfoWith({String? joinLink, String? sharecode}) {
        assert(
          joinLink != null || sharecode != null,
          'group info needs a joinLink or a sharecode',
        );

        return GroupInfo(
          id: 'id',
          name: 'name',
          design: Design.standard(),
          abbreviation: 'n',
          sharecode: sharecode,
          joinLink: joinLink,
          groupType: GroupType.course,
        );
      }

      Future<void> pumpLinkSharingButton({
        required WidgetTester tester,
        required GroupInfo groupInfo,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Row(children: [LinkSharingButton(groupInfo: groupInfo)]),
            ),
          ),
        );
      }

      const joinLink = 'https://sharez.one/123456789';
      const sharecode = '123456';

      const wordLink = 'Link';
      const wordSharecode = 'Sharecode';
      const wordVerschicken = 'verschicken';
      const wordKopieren = 'kopieren';

      testWidgets(
        'should has the text "Link verschicken" if the group has a join link and platform supports share options',
        (tester) async {
          final groupInfo = createGroupInfoWith(joinLink: joinLink);
          await pumpLinkSharingButton(tester: tester, groupInfo: groupInfo);

          // Title
          expect(find.text(wordLink), findsOneWidget);
          expect(find.text(wordSharecode), findsNothing);

          // Subtitle
          expect(find.text(wordVerschicken), findsOneWidget);
          expect(find.text(wordKopieren), findsNothing);
        },
        variant: PlatformCheckVariant.mobile(),
      );

      testWidgets(
        'should has the text "Sharecode verschicken" if the group has not a join link and platform supports share options',
        (tester) async {
          final groupInfo = createGroupInfoWith(sharecode: sharecode);
          await pumpLinkSharingButton(tester: tester, groupInfo: groupInfo);

          // Title
          expect(find.text(wordSharecode), findsOneWidget);
          expect(find.text(wordLink), findsNothing);

          // Subtitle
          expect(find.text(wordVerschicken), findsOneWidget);
          expect(find.text(wordKopieren), findsNothing);
        },
        variant: PlatformCheckVariant.mobile(),
      );

      testWidgets(
        'should has the text "Link kopieren" if the group has a join link and platform not supports share options',
        (tester) async {
          final groupInfo = createGroupInfoWith(joinLink: joinLink);
          await pumpLinkSharingButton(tester: tester, groupInfo: groupInfo);

          // Title
          expect(find.text(wordLink), findsOneWidget);
          expect(find.text(wordSharecode), findsNothing);

          // Subtitle
          expect(find.text(wordKopieren), findsOneWidget);
          expect(find.text(wordVerschicken), findsNothing);
        },
        variant: PlatformCheckVariant.desktop(),
      );

      testWidgets(
        'should has the text "Sharecode kopieren" if the group has not a join link and platform not supports share options',
        (tester) async {
          final groupInfo = createGroupInfoWith(sharecode: sharecode);
          await pumpLinkSharingButton(tester: tester, groupInfo: groupInfo);

          // Title
          expect(find.text(wordSharecode), findsOneWidget);
          expect(find.text(wordLink), findsNothing);

          // Subtitle
          expect(find.text(wordKopieren), findsOneWidget);
          expect(find.text(wordVerschicken), findsNothing);
        },
        variant: PlatformCheckVariant.desktop(),
      );
    },
    skip:
        "We generate the share links locally now as a \"temporary\" solution. See: https://github.com/SharezoneApp/sharezone-app/pull/1914",
  );
}
