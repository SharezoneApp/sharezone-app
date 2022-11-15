import 'package:flutter/material.dart';

import 'privacy_policy_widgets.dart';

class MainContentMobile extends StatelessWidget {
  final PrivacyPolicy privacyPolicy;

  const MainContentMobile({
    @required this.privacyPolicy,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datenschutzerklärung'),
        actions: [
          IconButton(
              onPressed: () {
                showDisplaySettingsDialog(context);
              },
              icon: Icon(Icons.display_settings)),
          IconButton(onPressed: () {}, icon: Icon(Icons.download)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: PrivacyPolicySubheading(),
            ),
            Divider(height: 0, thickness: .5),
            Flexible(
                child: PrivacyPolicyText(
              privacyPolicy: privacyPolicy,
            )),
            Divider(height: 0, thickness: .5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SafeArea(
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Inhaltsverzeichnis'),
                      Icon(Icons.expand_less),
                    ],
                  ),
                  onPressed: () {
                    showTableOfContentsBottomSheet(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
