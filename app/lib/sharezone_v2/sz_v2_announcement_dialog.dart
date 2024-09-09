// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/dashboard/dashboard_page.dart';
import 'package:sharezone/legal/privacy_policy/privacy_policy_page.dart';
import 'package:sharezone/legal/terms_of_service/terms_of_service_page.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/main/sharezone.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

Future<void> openSzV2AnnoucementDialog(BuildContext context) async {
  await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => _StudentDialog(
                BlocProvider.of<SharezoneContext>(context)
                    .api
                    .user
                    .data!
                    .typeOfUser
                    .isStudent,
              )));
}

const _skipKey = 'v2-dialog-skipped-on';

class SharezoneV2AnnoucementDialogGuard extends StatelessWidget {
  const SharezoneV2AnnoucementDialogGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final szContext = BlocProvider.of<SharezoneContext>(context);

    bool skip = false;
    try {
      final dialogSkippedNum = szContext.sharedPreferences.getInt(_skipKey);
      DateTime? dialogSkipped = dialogSkippedNum != null
          ? DateTime.fromMillisecondsSinceEpoch(dialogSkippedNum)
          : null;
      skip = dialogSkipped != null &&
          dialogSkipped.isAfter(clock.now().subtract(const Duration(days: 3)));
    } catch (e) {
      log('Error reading dialog skipped time: $e');
    }

    return StreamBuilder(
        stream: szContext.api.user.userStream,
        builder: (context, snapshot) {
          if (isIntegrationTest) {
            return child;
          }
          if (snapshot.hasData) {
            final user = snapshot.data;
            if (user != null &&
                user.legalData['v2_0-legal-accepted'] == null &&
                !skip) {
              return _StudentDialog(user.typeOfUser.isStudent);
            }
          }
          return child;
        });
  }
}

class _StudentDialog extends StatefulWidget {
  const _StudentDialog(this.isStudent);

  final bool isStudent;

  @override
  State<_StudentDialog> createState() => _StudentDialogState();
}

class _StudentDialogState extends State<_StudentDialog> {
  bool _allCheckboxesChecked = false;
  late final PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final szContext = BlocProvider.of<SharezoneContext>(context);
    return PopScope<Object?>(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Sharezone v2.0'),
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: MaxWidthConstraintBox(
            maxWidth: 800,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PageView(
                controller: controller,
                children: <Widget>[
                  if (widget.isStudent) ...[
                    const _JustText(markdownText: _markdownText1),
                    const _SharezonePlus(),
                  ],
                  _OtherChanges(widget.isStudent),
                  _FinalPage(
                      isStudent: widget.isStudent,
                      onCheckboxesChanged: (allChecked) {
                        setState(() {
                          _allCheckboxesChecked = allChecked;
                        });
                      }),
                ],
              ),
            ),
          ),
          bottomNavigationBar: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                final lastPage = widget.isStudent ? 3 : 1;
                final bool isLastPage = controller.page == lastPage;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: (controller.page ?? 0) > 0,
                        child: TextButton(
                          child: Text(
                            'Zurück',
                            style: TextStyle(
                              color: context.isDarkThemeEnabled
                                  ? null
                                  : primaryColor,
                            ),
                          ),
                          onPressed: () {
                            controller.previousPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut);
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: !isLastPage || _allCheckboxesChecked
                            ? () async {
                                if (controller.page == lastPage) {
                                  final ctx = BlocProvider.of<SharezoneContext>(
                                      context);
                                  // We navigate beforehand, so that the context
                                  // is not already unmounted when we try to
                                  // navigate.
                                  BlocProvider.of<NavigationBloc>(context)
                                      .navigateTo(NavigationItem.sharezonePlus);
                                  // ignore: unused_local_variable
                                  final uid = ctx.api.uID;

                                  try {
                                    szContext.api.references.firestore
                                        .collection('User')
                                        .doc(uid)
                                        .update({
                                      'legal': {
                                        'v2_0-legal-accepted': {
                                          "source": "v2.0-legal-dialog",
                                          'deviceTime': clock.now(),
                                          'serverTime':
                                              FieldValue.serverTimestamp(),
                                        },
                                      },
                                    });
                                  } on Exception catch (e) {
                                    if (context.mounted) {
                                      await showLeftRightAdaptiveDialog(
                                          context: context,
                                          title: 'Fehler',
                                          content: Text(
                                              'Es ist ein Fehler aufgetreten: $e. Falls dieser bestehen bleibt, dann schreibe uns unter support@sharezone.net'));
                                    }
                                  }
                                } else {
                                  controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.easeInOut);
                                }
                              }
                            : null,
                        child: Text(
                          isLastPage ? 'Fertig' : 'Weiter',
                          style: TextStyle(
                              color: context.isDarkThemeEnabled
                                  ? null
                                  : Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}

class _SharezonePlus extends StatelessWidget {
  const _SharezonePlus();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 190),
          _JustText(markdownText: _markdownText2),
          SizedBox(height: 30),
          SharezonePlusAdvantages(
            isHomeworkReminderFeatureVisible: true,
          )
        ],
      ),
    );
  }
}

class _OtherChanges extends StatelessWidget {
  const _OtherChanges(this.isStudent);

  final bool isStudent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isStudent)
              const _JustText(markdownText: '## Weitere Änderungen'),
            if (!isStudent) ...[
              const _JustText(markdownText: '## Wichtige Änderungen'),
              const SizedBox(height: 10),
              const _JustText(
                markdownText: '''
Hallo, hier ist das Sharezone Team :) Wir haben ein paar wichtige Änderungen, die wir dir gerne mitteilen möchten.  
''',
              ),
            ],
            const SizedBox(height: 10),
            const _Card(
              header: Text('Geänderte Rechtsform'),
              body: MarkdownBody(
                  data:
                      'Sharezone läuft nun nicht mehr unter der "Sander, Jonas; Reichardt, Nils; Weuthen, Felix „Sharezone“ GbR", sondern unter der “Sharezone UG (haftungsbeschränkt)”.'),
            ),
            const SizedBox(height: 12),
            _Card(
              header: const Text('Überarbeitung der Datenschutzerklärung'),
              body: MarkdownBody(
                data:
                    'Wir haben die [Datenschutzerklärung](privacy-policy) einmal ganz neu überarbeitet und detailliert beschrieben, wie deine Daten verarbeitet und geschützt werden.${isStudent ? ' Für Sharezone Plus mussten wir außerdem neue externe Dienste einbinden (z.B. für die Zahlungsabwicklung oder verschicken von Emails).' : ''}',
                onTapLink: (text, href, title) {
                  Navigator.of(context).pushNamed(PrivacyPolicyPage.tag);
                },
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              header: const Text('Allgemeine Nutzungsbedingungen (ANB)'),
              body: MarkdownBody(
                data:
                    'Wir haben neue [allgemeine Nutzungsbedingungen (“ANB”)](terms-of-service), die für die zukünftige Nutzung von Sharezone akzeptiert werden müssen.',
                onTapLink: (text, href, title) {
                  Navigator.of(context).pushNamed(TermsOfServicePage.tag);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.header,
    required this.body,
  });

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: header,
      body: body,
      backgroundColor: context.isDarkThemeEnabled
          ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
          : primaryColor.withOpacity(.3),
    );
  }
}

class _JustText extends StatelessWidget {
  const _JustText({required this.markdownText, this.onLinkTap});

  final String markdownText;
  final MarkdownTapLinkCallback? onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: MarkdownBody(
        data: markdownText,
        onTapLink: onLinkTap,
      ),
    );
  }
}

class _FinalPage extends StatefulWidget {
  const _FinalPage(
      {required this.onCheckboxesChanged, required this.isStudent});

  final void Function(bool allCheckboxesChecked) onCheckboxesChanged;
  final bool isStudent;

  @override
  State<_FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<_FinalPage>
    with AutomaticKeepAliveClientMixin<_FinalPage> {
  bool _box1Checked = false;
  bool _box2Checked = false;

  // So that checkbox state is kept when going back from the last page
  @override
  bool get wantKeepAlive => true;

  void _onCheckboxChanged() {
    widget.onCheckboxesChanged(_box1Checked && _box2Checked);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _JustText(
              markdownText: '''
**Das war's!**
    
Damit du weitermachen kannst, brauchen wir noch deine Zustimmung zu den unten aufgeführten Punkten.
    
Falls du keine Einstimmung geben willst, dann kannst du [hier](other-options) den Support kontaktieren.
${widget.isStudent ? '\n\nWir danken dir, uns bis hierhin begleitet zu haben.' : ''}
        
  Euer Sharezone-Team 💙''',
              onLinkTap: (text, href, title) {
                if (href == 'other-options') {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamed(SupportPage.tag);
                }
              },
            ),
            const SizedBox(height: 30),
            _Checkbox(
              text: 'Ich habe [die ANB](anb) gelesen und akzeptiere diese.',
              value: _box1Checked,
              onChanged: (newVal) {
                setState(() {
                  _box1Checked = newVal;
                });
                _onCheckboxChanged();
              },
              onLinkTap: (text, href, title) {
                if (href == 'anb') {
                  Navigator.of(context).pushNamed(TermsOfServicePage.tag);
                }
              },
            ),
            _Checkbox(
              text:
                  'Ich habe zur Kenntnis genommen, dass die "Sharezone UG (haftungsbeschränkt)" Sharezone betreibt.',
              value: _box2Checked,
              onChanged: (newVal) {
                setState(() {
                  _box2Checked = newVal;
                });
                _onCheckboxChanged();
              },
            ),
            const SizedBox(height: 30),
            _JustText(
              markdownText:
                  'Deine personenbezogenen Daten werden gemäß unserer aktualisierten '
                  '[Datenschutzerklärung](https://sharezone.net/datenschutz) verarbeitet.',
              onLinkTap: (text, href, title) {
                Navigator.of(context).pushNamed(PrivacyPolicyPage.tag);
              },
            ),
            const SizedBox(height: 10),
            if (clock.now().isBefore(DateTime(2024, 05, 15)))
              TextButton(
                onPressed: () {
                  BlocProvider.of<SharezoneContext>(context)
                      .sharedPreferences
                      .setInt(_skipKey, clock.now().millisecondsSinceEpoch);
                  Navigator.of(context).popAndPushNamed(DashboardPage.tag);
                },
                child: const Text('Überspringen'),
              ),
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({
    required this.text,
    required this.value,
    required this.onChanged,
    this.onLinkTap,
  });

  final String text;
  final bool value;
  final void Function(bool) onChanged;
  final MarkdownTapLinkCallback? onLinkTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () => onChanged(!value),
        leading: Checkbox(
          value: value,
          onChanged: (newVal) => onChanged(newVal!),
        ),
        title: MarkdownBody(data: text, onTapLink: onLinkTap),
      ),
    );
  }
}

const _markdownText1 = '''
Hey du, schön dich hier zu haben! :)

Wir haben Sharezone bis jetzt mit Herz, Blut und Tränen kostenlos für euch betrieben, weil wir vor allem anderen erstmal eine geile Schulapp machen wollten.  

Wir freuen uns sehr, dass es so gut bei euch ankommt und ihr es so fleißig nutzt 💙🫶  

Jetzt ist der Zeitpunkt gekommen, dass Sharezone sich selbst finanziert und es dadurch langfristig weiterlaufen kann 🏁🏃  

Wie genau, das verraten wir dir, wenn du auf "Weiter" klickst ;)

''';

const _markdownText2 = '''
## Sharezone Plus

Sharezone Plus bietet dir die Möglichkeit “Plus-Features” zu erwerben.

Damit kannst du zum Beispiel deine Noten verwalten oder hast mehr Speicherplatz in der Dateiablage.  

Du kannst die App auch ohne Sharezone Plus weiterhin kostenlos nutzen, mit ein paar kleinen Einschränkungen.  

Per Bezahl-Link kannst du Sharezone Plus auch ganz einfach online von z.B. deinen Eltern kaufen lassen.
''';
