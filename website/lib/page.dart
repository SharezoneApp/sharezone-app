// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_website/sharezone_plus/sharezone_plus_page.dart';
import 'package:sharezone_website/support_page.dart';
import 'package:sharezone_website/utils.dart';
import 'package:sharezone_website/widgets/column_spacing.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart'
    hide SharezoneLogo, LogoColor;

import 'footer.dart';
import 'home/home_page.dart';
import 'widgets/sharezone_logo.dart';
import 'widgets/transparent_button.dart';

class PageTemplate extends StatelessWidget {
  const PageTemplate({
    super.key,
    this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget>? children;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        drawer:
            isPhone(context)
                ? Drawer(
                  child: ColumnSpacing(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: Text(context.l10n.websiteNavHome),
                        onTap: () => goWithLang(context, '/'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: Text(context.l10n.websiteNavPlus),
                        onTap: () => goWithLang(context, '/plus'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.question_answer),
                        title: Text(context.l10n.websiteNavDocs),
                        onTap: () => launchUrl("https://docs.sharezone.net"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: Text(context.l10n.websiteNavSupport),
                        onTap: () => goWithLang(context, '/$SupportPage.tag'),
                      ),
                    ],
                  ),
                )
                : null,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: false,
              backgroundColor: Colors.white,
              pinned: true,
              bottom: _AppBarTitle(),
            ),
            SliverToBoxAdapter(
              child: SafeArea(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            _kAppBarHeight -
                            5,
                      ),
                      child: Column(
                        crossAxisAlignment: crossAxisAlignment,
                        children: children!,
                      ),
                    ),
                    const Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _kAppBarHeight = 80.0;

class _AppBarTitle extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    // Disable selection to prevent showing a selection mouse pointer.
    return SelectionContainer.disabled(
      child: Align(
        alignment: Alignment.center,
        child: MaxWidthConstraintBox(
          maxWidth: maxWidthConstraint,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
              height: _kAppBarHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isPhone(context))
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    )
                  else
                    TransparentButton(
                      onTap: () => goWithLang(context, '/'),
                      child: const SharezoneLogo(
                        logoColor: LogoColor.blueShort,
                        height: 50,
                        width: 200,
                      ),
                    ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!isPhone(context)) ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: TransparentButton(
                              child: Text(context.l10n.websiteNavPlus),
                              onTap:
                                  () => goWithLang(
                                    context,
                                    '/${SharezonePlusPage.tag}',
                                  ),
                            ),
                          ),
                          TransparentButton(
                            child: Text(context.l10n.websiteNavSupport),
                            onTap:
                                () =>
                                    goWithLang(context, '/${SupportPage.tag}'),
                          ),
                          const SizedBox(width: 30),
                          TransparentButton.openLink(
                            link: "https://docs.sharezone.net",
                            child: Text(context.l10n.websiteNavDocs),
                          ),
                          const SizedBox(width: 30),
                        ],
                        _GoWebAppButton(),
                        const SizedBox(width: 8),
                        const _LanguageSelector(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 30);
}

class _GoWebAppButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final borderRaius = BorderRadius.circular(50);
    return SizedBox(
      height: 65,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () => launchUrl("https://web.sharezone.net"),
          borderRadius: borderRaius,
          child: Material(
            borderRadius: borderRaius,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  context.l10n.websiteNavWebApp,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    final currentLocale = _currentAppLocale(context);
    return PopupMenuButton<AppLocale>(
      tooltip: context.l10n.websiteLanguageSelectorTooltip,
      borderRadius: BorderRadius.circular(30),
      initialValue: currentLocale,
      onSelected: (locale) => _setLocale(context, locale),
      itemBuilder: (context) {
        return [
          for (final locale in _availableLocales())
            PopupMenuItem(
              value: locale,
              child: Text(
                '${locale.getTextEmoji()} ${locale.getTranslatedName(context)}',
              ),
            ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFDDDDDD)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 18),
            const SizedBox(width: 6),
            Text(
              _languageLabel(context, currentLocale),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
      ),
    );
  }
}

AppLocale _currentAppLocale(BuildContext context) {
  final uri = Uri.parse(GoRouter.of(context).state.uri.toString());
  final langParam = uri.queryParameters['lang'];
  if (langParam == null || langParam.isEmpty) {
    return AppLocale.system;
  }
  return AppLocale.fromLanguageTag(langParam);
}

List<AppLocale> _availableLocales() {
  return const [AppLocale.system, AppLocale.en, AppLocale.de];
}

String _languageLabel(BuildContext context, AppLocale locale) {
  if (locale.isSystem()) {
    final resolvedCode = Localizations.localeOf(context).languageCode;
    return resolvedCode.toUpperCase();
  }
  return locale.toLocale().languageCode.toUpperCase();
}

void _setLocale(BuildContext context, AppLocale locale) {
  final currentUri = Uri.parse(GoRouter.of(context).state.uri.toString());
  final updatedQuery = Map<String, String>.from(currentUri.queryParameters);
  if (locale.isSystem()) {
    updatedQuery.remove('lang');
  } else {
    updatedQuery['lang'] = locale.name;
  }
  final updatedUri = currentUri.replace(queryParameters: updatedQuery);
  context.go(updatedUri.toString());
}
