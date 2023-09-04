// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'about_section.dart';
import 'social_media_button.dart';

part 'member_card.dart';

/// [TeamImagePath] speichert die Pfade die zu den Teambildern
/// der einzelnen Team-Mitglieder.
class TeamImagePath {
  static const nils = 'assets/team/nils.png';
  static const jonas = 'assets/team/jonas.png';
}

class TeamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutSection(
      title: 'Über uns',
      child: Column(
        children: <Widget>[
          const SizedBox(height: 2),
          _NilsCard(),
          _JonasCard(),
        ],
      ),
    );
  }
}

class _NilsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MemberCard(
      name: 'Nils Reichardt',
      avatarPath: TeamImagePath.nils,
      email: "nils@sharezone.net",
      socialMediaLinks: _SocialMediaLinks(
        instagram: "https://instagram.com/nils.reichardt",
        linkedIn: "https://www.linkedin.com/in/nilsreichardt/",
        twitter: "https://twitter.com/nilsreichardt",
      ),
    );
  }
}

class _JonasCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MemberCard(
      name: "Jonas Sander",
      avatarPath: TeamImagePath.jonas,
      email: "jonas@sharezone.net",
    );
  }
}
