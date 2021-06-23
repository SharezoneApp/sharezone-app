import 'package:flutter/material.dart';
import 'package:sharezone_widgets/svg.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:url_launcher_extended/url_launcher_extended.dart';

class MemberCard extends StatelessWidget {
  const MemberCard(
      {@required this.name,
      @required this.avatarPath,
      @required this.description,
      @required this.email,
      this.instagramURL,
      this.gitHubURL,
      this.twitterURL,
      this.linkedInURL});

  // Name & Avatar
  final String name;
  final String avatarPath;
  final String description;
  final String email;

  // Social Networks
  final String instagramURL;
  final String gitHubURL;
  final String twitterURL;
  final String linkedInURL;

  // @formatter:off
  List<Widget> makeSocialButtons() {
    List<Widget> list = <Widget>[];

    if (instagramURL != null)
      list.add(SocialButton(
          svgPath: 'assets/icons/instagram.svg', webURL: instagramURL));
    if (gitHubURL != null)
      list.add(SocialButton(
        svgPath: 'assets/icons/github.svg',
        webURL: gitHubURL,
      ));
    if (twitterURL != null)
      list.add(SocialButton(
        svgPath: 'assets/icons/twitter.svg',
        webURL: twitterURL,
      ));
    if (linkedInURL != null)
      list.add(SocialButton(
        svgPath: 'assets/icons/linkedin.svg',
        webURL: linkedInURL,
      ));

    list.add(SocialButton(svgPath: 'assets/icons/email.svg', email: email));

    return list;
  }
  // @formatter:on

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image(width: 50, height: 50, image: AssetImage(avatarPath)),
                const SizedBox(width: 10),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name, style: TextStyle(fontSize: 20)),
                      Text(description,
                          style: TextStyle(color: Colors.black54)),
                    ]),
              ],
            ),
            const SizedBox(height: 8),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: makeSocialButtons())
          ],
        ),
      )),
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({
    @required this.svgPath,
    this.webURL,
    this.email,
  });

  final String svgPath;
  final String webURL;
  final String email;

  static const _svgSize = 28.0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (webURL != null && email == null)
          launchURL(webURL);
        else if (email != null && webURL == null)
          UrlLauncherExtended().tryLaunchMailOrThrow(email);
        else {
          debugPrint(
              "ERROR: Irgendetwas beim Übergeben von der E-Mail und/oder der URL ist schief gelaufen...");
        }
      },
      icon: SizedBox(
        width: _svgSize,
        height: _svgSize,
        child: PlatformSvg.asset(svgPath),
      ),
//      SvgImage.asset(
//        svgPath,
//        new Size(svgSize, svgSize),
//        errorWidgetBuilder: svgErrorBuilder,
//        loadingPlaceholderBuilder: (BuildContext context) =>
//            LoadingBlockSVG(svgSize),
//      ),
      iconSize: _svgSize,
    );
  }
}
