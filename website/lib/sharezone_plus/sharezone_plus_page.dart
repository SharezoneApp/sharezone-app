import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_website/flavor.dart';
import 'package:sharezone_website/page.dart';
import 'package:sharezone_website/widgets/headline.dart';

final isSharezonePlusPageEnabledFlag =
    kDebugMode || Flavor.fromEnvironment() == Flavor.dev;

class SharezonePlusPage extends StatelessWidget {
  const SharezonePlusPage({super.key});

  static const tag = 'plus';

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      children: [
        const SharezonePlusPageHeader(),
        const SizedBox(height: 18),
        const WhyPlusSharezoneCard(),
        const SizedBox(height: 18),
        SharezonePlusAdvantages(typeOfUser: typeOfUser),
        const SizedBox(height: 18),
        const _CallToActionSection(),
        const SizedBox(height: 32),
        const SharezonePlusFaq(),
        const SizedBox(height: 18),
        const SharezonePlusSupportNote(),
      ],
    );
  }
}
