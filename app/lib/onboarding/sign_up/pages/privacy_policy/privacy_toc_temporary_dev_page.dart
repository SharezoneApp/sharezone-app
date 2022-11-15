// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/account/theme/theme_settings.dart';

import 'src/privacy_policy_src.dart' hide TableOfContents;
import 'src/widgets/privacy_policy_widgets.dart';

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
    _sections.value = notReadingSubsection;
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      // _sections.value = false ? notReadingSubsection : readingSubsection;
      _sections.value =
          timer.tick.isEven ? notReadingSubsection : readingSubsection;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<TableOfContentsController>(
            create: (context) => _MockTableOfContentsController(_sections),
          ),
          ChangeNotifierProvider<PrivacyPolicyThemeSettings>(
            create: (context) {
              final themeSettings =
                  Provider.of<ThemeSettings>(context, listen: false);
              return PrivacyPolicyThemeSettings(
                analytics: AnalyticsProvider.ofOrNullObject(context),
                themeSettings: Provider.of(context, listen: false),
                initialTextScalingFactor: themeSettings.textScalingFactor,
                initialVisualDensity: themeSettings.visualDensitySetting,
                initialThemeBrightness: themeSettings.themeBrightness,
              );
            },
          ),
        ],
        child: ChangeNotifierProvider<TableOfContentsController>(
          create: (context) => _MockTableOfContentsController(_sections),
          child: TableOfContentsDesktop(),
        ),
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

  @override
  void toggleDocumentSectionExpansion(DocumentSectionId documentSectionId) {}

  @override
  void changeExpansionBehavior(ExpansionBehavior expansionBehavior) {
    throw UnimplementedError();
  }
}

final notReadingSubsection = [
  TocDocumentSectionView(
    id: DocumentSectionId('foo'),
    sectionHeadingText: 'Inhaltsverzeichnis',
    subsections: [],
    shouldHighlight: true,
    isExpanded: false,
  ),
  TocDocumentSectionView(
    id: DocumentSectionId('bar'),
    sectionHeadingText: 'Deine Rechte',
    shouldHighlight: false,
    isExpanded: false,
    subsections: [
      TocDocumentSectionView(
        id: DocumentSectionId('a-recht-auf-auskunft'),
        sectionHeadingText: 'a. Recht auf Auskunft',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('b-recht-auf-berichtigung'),
        sectionHeadingText: 'b. Recht auf Berichtigung',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('c-recht-auf-lschung'),
        sectionHeadingText: 'c. Recht auf Löschung',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('d-recht-auf-einschrnkung-der-verarbeitung'),
        sectionHeadingText: 'd. Recht auf Einschränkung der Verarbeitung',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('e-recht-auf-widerspruch'),
        sectionHeadingText: 'e. Recht auf Widerspruch',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('f-recht-auf-widerruf'),
        sectionHeadingText: 'f. Recht auf Widerruf',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
    ],
  ),
  TocDocumentSectionView(
    id: DocumentSectionId('baz'),
    sectionHeadingText: 'Kontakt',
    subsections: [],
    shouldHighlight: false,
    isExpanded: false,
  ),
];

final readingSubsection = [
  TocDocumentSectionView(
    id: DocumentSectionId('foo'),
    sectionHeadingText: 'Inhaltsverzeichnis',
    subsections: [],
    shouldHighlight: false,
    isExpanded: false,
  ),
  TocDocumentSectionView(
    id: DocumentSectionId('bar'),
    sectionHeadingText: 'Deine Rechte',
    shouldHighlight: true,
    isExpanded: true,
    subsections: [
      TocDocumentSectionView(
        id: DocumentSectionId('a-recht-auf-auskunft'),
        sectionHeadingText: 'a. Recht auf Auskunft',
        subsections: [],
        shouldHighlight: true,
        isExpanded: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('b-recht-auf-berichtigung'),
        sectionHeadingText: 'b. Recht auf Berichtigung',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('c-recht-auf-lschung'),
        sectionHeadingText: 'c. Recht auf Löschung',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('d-recht-auf-einschrnkung-der-verarbeitung'),
        sectionHeadingText: 'd. Recht auf Einschränkung der Verarbeitung',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('e-recht-auf-widerspruch'),
        sectionHeadingText: 'e. Recht auf Widerspruch',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
      TocDocumentSectionView(
        id: DocumentSectionId('f-recht-auf-widerruf'),
        sectionHeadingText: 'f. Recht auf Widerruf',
        subsections: [],
        shouldHighlight: false,
        isExpanded: false,
      ),
    ],
  ),
  TocDocumentSectionView(
    id: DocumentSectionId('baz'),
    sectionHeadingText: 'Kontakt',
    subsections: [],
    shouldHighlight: false,
    isExpanded: false,
  ),
];
