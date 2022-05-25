import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/new_privacy_policy_page.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/table_of_contents_controller.dart';

class PrivacyPolicyTocTempDevPage extends StatelessWidget {
  const PrivacyPolicyTocTempDevPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Provider<TableOfContentsController>(
        create: (context) => _MockTableOfContentsController(ValueNotifier(
          [
            TocDocumentSectionView(
              id: DocumentSectionId('id'),
              sectionHeadingText: 'Inhaltsverzeichnis',
              subsections: [],
              shouldHighlight: true,
            ),
          ],
        )),
        child: TableOfContents(),
      ),
    );
  }
}

class _MockTableOfContentsController extends ChangeNotifier
    implements TableOfContentsController {
  final ValueListenable<List<TocDocumentSectionView>> _documentSections;

  _MockTableOfContentsController(this._documentSections) {
    _documentSections.addListener(() {
      notifyListeners();
    });
  }

  @override
  List<TocDocumentSectionView> get documentSections => _documentSections.value;

  @override
  Future<void> scrollTo(DocumentSectionId documentSectionId) {
    return Future.value();
  }
}
