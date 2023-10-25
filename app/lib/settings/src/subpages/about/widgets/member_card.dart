// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../../../../../../settings/src/subpages/about/widgets/team.dart';

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.name,
    required this.avatarPath,
    this.email,
    this.socialMediaLinks,
  });

  final String name, avatarPath;
  final String? email;
  final _SocialMediaLinks? socialMediaLinks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (isNotEmptyOrNull(socialMediaLinks?.instagram))
                    SocialButton.instagram(socialMediaLinks!.instagram!),
                  if (isNotEmptyOrNull(socialMediaLinks?.twitter))
                    SocialButton.twitter(socialMediaLinks!.twitter!),
                  if (isNotEmptyOrNull(socialMediaLinks?.linkedIn))
                    SocialButton.linkedIn(socialMediaLinks!.linkedIn!),
                  if (isNotEmptyOrNull(email)) SocialButton.email(email!),
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
  final String? instagram, twitter, linkedIn;

  const _SocialMediaLinks({
    this.instagram,
    this.twitter,
    this.linkedIn,
  });
}
