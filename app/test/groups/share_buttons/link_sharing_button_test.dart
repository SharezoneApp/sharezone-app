import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/src/widgets/group_share.dart';
import 'package:sharezone_utils/platform.dart';

void main() {
  group('LinkSharingButton', () {
    GroupInfo _createGroupInfoWith({String joinLink, String sharecode}) {
      assert(joinLink != null || sharecode != null,
          'group info needs a joinLink or a sharecode');

      return GroupInfo(
        id: 'id',
        name: 'name',
        design: Design.standard(),
        abbreviation: 'n',
        sharecode: sharecode,
        meetingID: 'meetingID',
        joinLink: joinLink,
        groupType: GroupType.course,
      );
    }

    Future<void> _pumpLinkSharingButton(
        {@required WidgetTester tester, @required GroupInfo groupInfo}) async {
      assert(groupInfo != null);
      assert(tester != null);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Row(
              children: [LinkSharingButton(groupInfo: groupInfo)],
            ),
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
        final groupInfo = _createGroupInfoWith(joinLink: joinLink);
        await _pumpLinkSharingButton(tester: tester, groupInfo: groupInfo);

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
        final groupInfo = _createGroupInfoWith(sharecode: sharecode);
        await _pumpLinkSharingButton(tester: tester, groupInfo: groupInfo);

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
        final groupInfo = _createGroupInfoWith(joinLink: joinLink);
        await _pumpLinkSharingButton(tester: tester, groupInfo: groupInfo);

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
        final groupInfo = _createGroupInfoWith(sharecode: sharecode);
        await _pumpLinkSharingButton(tester: tester, groupInfo: groupInfo);

        // Title
        expect(find.text(wordSharecode), findsOneWidget);
        expect(find.text(wordLink), findsNothing);

        // Subtitle
        expect(find.text(wordKopieren), findsOneWidget);
        expect(find.text(wordVerschicken), findsNothing);
      },
      variant: PlatformCheckVariant.desktop(),
    );
  });
}
