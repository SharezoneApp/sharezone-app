// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'team.dart';

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    @required this.name,
    @required this.avatarPath,
    @required this.description,
    this.email,
    this.socialMediaLinks,
  });

  final String name, avatarPath, description, email;
  final _SocialMediaLinks socialMediaLinks;

  @override
  Widget build(BuildContext context) {
    final socialMediaLinks = this.socialMediaLinks ??
        _SocialMediaLinks
            .notSet(); // Default value can't be setted in the construtor
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image(
                    width: 50,
                    height: 50,
                    image: AssetImage(avatarPath),
                  ),
                  const SizedBox(width: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          description,
                          style: TextStyle(
                              color: isDarkThemeEnabled(context)
                                  ? Colors.white30
                                  : Colors.black54),
                        ),
                      ]),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (isNotEmptyOrNull(socialMediaLinks.instagram))
                    SocialButton.instagram(socialMediaLinks.instagram),
                  if (isNotEmptyOrNull(socialMediaLinks.twitter))
                    SocialButton.twitter(socialMediaLinks.twitter),
                  if (isNotEmptyOrNull(socialMediaLinks.linkedIn))
                    SocialButton.linkedIn(socialMediaLinks.linkedIn),
                  if (isNotEmptyOrNull(email)) SocialButton.email(email),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialMediaLinks {
  final String instagram, twitter, linkedIn;

  const _SocialMediaLinks({
    this.instagram,
    this.twitter,
    this.linkedIn,
  });

  const _SocialMediaLinks.notSet()
      : instagram = '',
        twitter = '',
        linkedIn = '';
}
