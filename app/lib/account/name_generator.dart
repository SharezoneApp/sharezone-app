import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

String buildAnonymousUserName() {
  final locale = AppLocale.getSystemLocale();
  final animalName = switch (locale.languageCode) {
    'de' =>
      _anonymousAnimalNamesDe[_random.nextInt(_anonymousAnimalNamesDe.length)],
    _ =>
      _anonymousAnimalNamesEn[_random.nextInt(_anonymousAnimalNamesEn.length)],
  };

  final l10n = _getLocalization(locale);
  return l10n.authAnonymousDisplayName(animalName);
}

SharezoneLocalizations _getLocalization(Locale locale) {
  try {
    return lookupSharezoneLocalizations(locale);
  } on FlutterError catch (_) {
    return lookupSharezoneLocalizations(const Locale('en'));
  }
}

final _random = math.Random();

const _anonymousAnimalNamesDe = <String>[
  'Loewe',
  'Tiger',
  'Vogel',
  'Pinguin',
  'Dalmatiner',
  'Gepard',
  'Lachs',
  'Elefant',
  'Affe',
  'Stier',
  'Gorilla',
  'Baer',
  'Eisbaer',
  'Papagei',
  'Braunbaer',
  'Wolf',
  'Schaeferhund',
  'Kampfhund',
  'Dobermann',
  'Panda',
  'Wal',
  'Hai',
  'Pottwal',
  'Blauwal',
  'Buckelwal',
  'Riesenhai',
  'Fisch',
  'Aal',
  'Seelachs',
  'Hecht',
  'Zander',
  'Karpfen',
  'Krapfen',
  'Barsch',
  'Biber',
  'Fuchs',
  'Alligator',
  'Leopard',
  'Hamster',
];

const _anonymousAnimalNamesEn = <String>[
  'Lion',
  'Tiger',
  'Bird',
  'Penguin',
  'Dalmatian',
  'Cheetah',
  'Salmon',
  'Elephant',
  'Monkey',
  'Bull',
  'Gorilla',
  'Bear',
  'Polar Bear',
  'Parrot',
  'Brown Bear',
  'Wolf',
  'German Shepherd',
  'Dog',
  'Doberman',
  'Panda',
  'Whale',
  'Shark',
  'Sperm Whale',
  'Blue Whale',
  'Humpback Whale',
  'Basking Shark',
  'Fish',
  'Eel',
  'Pollock',
  'Pike',
  'Zander',
  'Carp',
  'Perch',
  'Beaver',
  'Fox',
  'Alligator',
  'Leopard',
  'Hamster',
];
