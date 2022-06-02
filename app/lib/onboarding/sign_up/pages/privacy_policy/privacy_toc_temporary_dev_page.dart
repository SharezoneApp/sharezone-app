import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/new_privacy_policy_page.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/table_of_contents_controller.dart';

class PrivacyPolicyTocTempDevPage extends StatefulWidget {
  const PrivacyPolicyTocTempDevPage({Key key}) : super(key: key);

  @override
  State<PrivacyPolicyTocTempDevPage> createState() =>
      _PrivacyPolicyTocTempDevPageState();
}

class _PrivacyPolicyTocTempDevPageState
    extends State<PrivacyPolicyTocTempDevPage> {
  ValueNotifier<List<TocDocumentSectionView>> _sections;
  Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _sections = ValueNotifier<List<TocDocumentSectionView>>([]);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _sections.value =
          timer.tick.isEven ? notReadingSubsection : readingSubsection;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ChangeNotifierProvider<TableOfContentsController>(
        create: (context) => _MockTableOfContentsController(_sections),
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

final notReadingSubsection = [
  TocDocumentSectionView(
    id: DocumentSectionId('foo'),
    sectionHeadingText: 'Inhaltsverzeichnis',
    subsections: [],
    shouldHighlight: true,
  ),
  TocDocumentSectionView(
    id: DocumentSectionId('bar'),
    sectionHeadingText: 'Deine Rechte',
    shouldHighlight: false,
    subsections: [
      TocDocumentSectionView(
        id: DocumentSectionId('a-recht-auf-auskunft'),
        sectionHeadingText: 'a. Recht auf Auskunft',
        subsections: [],
        shouldHighlight: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('b-recht-auf-berichtigung'),
        sectionHeadingText: 'b. Recht auf Berichtigung',
        subsections: [],
        shouldHighlight: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('c-recht-auf-lschung'),
        sectionHeadingText: 'c. Recht auf Löschung',
        subsections: [],
        shouldHighlight: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('d-recht-auf-einschrnkung-der-verarbeitung'),
        sectionHeadingText: 'd. Recht auf Einschränkung der Verarbeitung',
        subsections: [],
        shouldHighlight: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('e-recht-auf-widerspruch'),
        sectionHeadingText: 'e. Recht auf Widerspruch',
        subsections: [],
        shouldHighlight: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('f-recht-auf-widerruf'),
        sectionHeadingText: 'f. Recht auf Widerruf',
        subsections: [],
        shouldHighlight: false,
      ),
    ],
  ),
  TocDocumentSectionView(
    id: DocumentSectionId('baz'),
    sectionHeadingText: 'Kontakt',
    subsections: [],
    shouldHighlight: false,
  ),
];

final readingSubsection = [
  TocDocumentSectionView(
    id: DocumentSectionId('foo'),
    sectionHeadingText: 'Inhaltsverzeichnis',
    subsections: [],
    shouldHighlight: false,
  ),
  TocDocumentSectionView(
    id: DocumentSectionId('bar'),
    sectionHeadingText: 'Deine Rechte',
    shouldHighlight: true,
    subsections: [
      TocDocumentSectionView(
        id: DocumentSectionId('a-recht-auf-auskunft'),
        sectionHeadingText: 'a. Recht auf Auskunft',
        subsections: [],
        shouldHighlight: true,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('b-recht-auf-berichtigung'),
        sectionHeadingText: 'b. Recht auf Berichtigung',
        subsections: [],
        shouldHighlight: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('c-recht-auf-lschung'),
        sectionHeadingText: 'c. Recht auf Löschung',
        subsections: [],
        shouldHighlight: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('d-recht-auf-einschrnkung-der-verarbeitung'),
        sectionHeadingText: 'd. Recht auf Einschränkung der Verarbeitung',
        subsections: [],
        shouldHighlight: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('e-recht-auf-widerspruch'),
        sectionHeadingText: 'e. Recht auf Widerspruch',
        subsections: [],
        shouldHighlight: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('f-recht-auf-widerruf'),
        sectionHeadingText: 'f. Recht auf Widerruf',
        subsections: [],
        shouldHighlight: false,
      ),
    ],
  ),
  TocDocumentSectionView(
    id: DocumentSectionId('baz'),
    sectionHeadingText: 'Kontakt',
    subsections: [],
    shouldHighlight: false,
  ),
];
