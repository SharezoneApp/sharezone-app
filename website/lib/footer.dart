import 'package:flutter/material.dart';
import 'package:sharezone_website/legal/imprint_page.dart';
import 'package:sharezone_website/legal/privacy_policy.dart';
import 'package:sharezone_website/support_page.dart';
import 'package:sharezone_website/utils.dart';
import 'package:sharezone_website/widgets/svg.dart';

import 'home/home_page.dart';
import 'widgets/column_spacing.dart';
import 'widgets/row_spacing.dart';
import 'widgets/section.dart';
import 'widgets/section_action_button.dart';
import 'widgets/sharezone_logo.dart';

import "package:build_context/build_context.dart";

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey('footer'),
      child: Container(
        color: context.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Section(
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              child: getFooter(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFooter(BuildContext context) {
    if (isPhone(context)) {
      return _FooterPhone();
    }
    if (isTablet(context)) {
      return _FooterTablet();
    }
    return _FooterDesktop();
  }
}

class _FooterPhone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColumnSpacing(
      spacing: 24,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: _FooterSocialMedia()),
        const SizedBox(height: 16),
        _FooterCommunity(),
        _FooterHelp(),
        _FooterNavLinks(),
        _FooterLegal(),
      ],
    );
  }
}

class _FooterTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColumnSpacing(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _FooterSocialMedia(),
            const SizedBox(width: 48),
            Expanded(child: _FooterCommunity()),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: ColumnSpacing(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  _FooterHelp(),
                  _FooterNavLinks(),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: ColumnSpacing(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  _FooterDownlaod(),
                  _FooterLegal(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterDesktop extends StatelessWidget {
  const _FooterDesktop({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RowSpacing(
      spacing: 32,
      children: [
        Expanded(child: _FooterSocialMedia()),
        const SizedBox(width: 16),
        Expanded(child: _FooterCommunity()),
        const SizedBox(width: 32),
        Expanded(
          child: ColumnSpacing(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              _FooterHelp(),
              _FooterNavLinks(),
            ],
          ),
        ),
        Expanded(
          child: ColumnSpacing(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              _FooterDownlaod(),
              _FooterLegal(),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterCommunity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FooterSection(
      title: "Sharezone-Community",
      subtitle:
          "Werde jetzt ein Teil unserer Community und bringe deine eigenen Ideen bei Sharezone ein.",
      links: [
        _FooterAction("Discord", link: "https://sharezone.net/discord"),
        _FooterAction("Ticketsystem", link: "https://sharezone.net/tickets"),
      ],
    );
  }
}

class _FooterHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FooterSection(
      title: "Hilfe",
      links: [
        _FooterAction("Support", tag: SupportPage.tag),
        _FooterAction("Erklärvideos", link: "https://sharezone.net/youtube"),
      ],
    );
  }
}

class _FooterDownlaod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FooterSection(
      title: "Downloads",
      links: [
        _FooterAction("Android", link: "https://sharezone.net/android"),
        _FooterAction("iOS", link: "https://sharezone.net/ios"),
        _FooterAction("macOS", link: "https://sharezone.net/macos"),
      ],
    );
  }
}

class _FooterLegal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FooterSection(
      title: "Rechtliches",
      links: [
        _FooterAction("Impressum", tag: ImprintPage.tag),
        _FooterAction("Datenschutz", tag: PrivacyPolicyPage.tag),
      ],
    );
  }
}

class _FooterNavLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FooterSection(
      title: "Links",
      links: [
        _FooterAction("FAQ", link: "https://sharezone.net/faq"),
      ],
    );
  }
}

class _FooterAction {
  final String title;
  final String link;
  final String tag;

  _FooterAction(this.title, {this.link, this.tag});
}

class _FooterSection extends StatelessWidget {
  const _FooterSection({
    Key key,
    this.title,
    this.links,
    this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final List<_FooterAction> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterTitle(title),
        const SizedBox(height: 4),
        if (subtitle != null) ...[
          SelectableText(subtitle),
          const SizedBox(height: 8),
        ],
        ColumnSpacing(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            for (final l in links)
              SectionActionButton(
                text: l.title,
                onTap: () {
                  if (l.link == null) {
                    Navigator.pushNamed(context, l.tag);
                  } else {
                    launchURL(l.link);
                  }
                },
                color: Colors.white,
                fontSize: 16,
              ),
          ],
        )
      ],
    );
  }
}

class _FooterTitle extends StatelessWidget {
  const _FooterTitle(this.title, {Key key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _FooterSocialMedia extends StatelessWidget {
  const _FooterSocialMedia({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SharezoneLogo(
          logoColor: LogoColor.white,
          height: 50,
          width: 200,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _SocialMediaButton("Twitter"),
            _SocialMediaButton("Instagram"),
            _SocialMediaButton("Discord"),
          ],
        ),
      ],
    );
  }
}

class _SocialMediaButton extends StatelessWidget {
  const _SocialMediaButton(this.socialMediaPlatform, {Key key})
      : super(key: key);

  final String socialMediaPlatform;

  @override
  Widget build(BuildContext context) {
    final lowerCasePlatform = socialMediaPlatform.toLowerCase();
    return InkWell(
      onTap: () => launchURL("https://sharezone.net/$lowerCasePlatform"),
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: PlatformSvg.asset(
              "assets/icons/$lowerCasePlatform.svg",
              color: context.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
