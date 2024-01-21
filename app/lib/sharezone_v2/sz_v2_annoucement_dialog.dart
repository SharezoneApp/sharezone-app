// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<void> openSzV2AnnoucementDialog(BuildContext context) async {
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => const _Dialog()));
}

class _Dialog extends StatefulWidget {
  const _Dialog();

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  bool _allCheckboxesChecked = false;
  late final PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
                  const _JustText(markdownText: _markdownText1),
                  const _JustText(markdownText: _markdownText2),
                  const _JustText(markdownText: _markdownText3),
                  _FinalPage(onCheckboxesChanged: (allChecked) {
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
                const lastPage = 3;
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
                          child: const Text('Zurück'),
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
                                  // ignore: unused_local_variable
                                  final uid = ctx.api.uID;

                                  try {
                                    // await FirebaseFirestore.instance
                                    //     .collection('users')
                                    //     .doc(uid)
                                    //     .update({
                                    //   'legal': {
                                    //     'v2.0-terms-accepted': {
                                    //       'deviceTime': clock.now(),
                                    //       'serverTime':
                                    //           FieldValue.serverTimestamp(),
                                    //     },
                                    //   },
                                    // });
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                    // ignore: use_build_context_synchronously
                                    BlocProvider.of<NavigationBloc>(context)
                                        .navigateTo(
                                            NavigationItem.sharezonePlus);
                                  } on Exception catch (e) {
                                    // ignore: use_build_context_synchronously
                                    await showLeftRightAdaptiveDialog(
                                        context: context,
                                        title: 'Fehler',
                                        content: Text(
                                            'Es ist ein Fehler aufgetreten: $e. Falls dieser bestehen bleibt, dann schreibe uns unter support@sharezone.net'));
                                  }
                                } else {
                                  controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.easeInOut);
                                }
                              }
                            : null,
                        child: Text(isLastPage ? 'Fertig' : 'Weiter'),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}

class _JustText extends StatelessWidget {
  const _JustText({required this.markdownText});

  final String markdownText;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: MarkdownBody(data: markdownText),
    );
  }
}

class _FinalPage extends StatefulWidget {
  const _FinalPage({required this.onCheckboxesChanged});

  final void Function(bool allCheckboxesChecked) onCheckboxesChanged;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _JustText(markdownText: _markdownText4),
        const SizedBox(
          height: 30,
        ),
        _Checkbox(
          text: 'Ich habe die ANB gelesen und akzeptiere diese.',
          value: _box1Checked,
          onChanged: (newVal) {
            setState(() {
              _box1Checked = newVal;
            });
            _onCheckboxChanged();
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
        const SizedBox(
          height: 30,
        ),
        const _JustText(
          markdownText: 'Deine personenbezogenen Daten werden gemäß unserer '
              '[Datenschutzerklärung](https://sharezone.net/datenschutz) verarbeitet.',
        )
      ],
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({
    required this.text,
    required this.value,
    required this.onChanged,
  });

  final String text;
  final bool value;
  final void Function(bool) onChanged;

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
        title: MarkdownBody(data: text),
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
**Sharezone Plus**  
Sharezone Plus ist ein Abbonement, mit welchem du “Plus-Features” freischalten kannst.  

Zum Beispiel hast du dadurch mehr Speicherplatz in der Dateiablage oder kannst unkomprimiert Bilder hochladen.  

Du kannst auch ohne Sharezone Plus weiterhin Sharezone kostenlos nutzen, allerdings mit ein paar kleinen Einschränkungen.  

Das Abo kann ganz einfach online von z.B. deinen Eltern per Bezahl-Link bezahlt werden.
''';

const _markdownText3 = '''
Außerdem gibt es folgende Änderungen:

**Version 2.0**  
Wir haben das Design für dich überarbeitet, eine neue Navigation eingeführt und ein paar kleine Verbesserungen eingebaut.
Lass uns doch Feedback da, wie es dir gefällt.

**Geänderte Rechtsform**  
Sharezone läuft nun nicht mehr unter der "Sander, Jonas; Reichardt, Nils; Weuthen, Felix „Sharezone“ GbR", sondern unter der “Sharezone UG (haftungsbeschränkt)”.  

**Überarbeitung der Datenschutzerklärung**  
Wir haben die Datenschutzerklärung einmal ganz neu überarbeitet und detailliert beschrieben, wie deine Daten verarbeitet und geschützt werden.   
Für Sharezone Plus mussten wir außerdem neue externe Dienste einbinden (z.B. für die Zahlungsabwicklung).

**Allgemeine Nutzungsbedingungen**  
Wir haben neue allgemeinen Nutzungsbedingungen (“ANB”), die für die zukünftige Nutzung von Sharezone akzeptiert werden müssen. 

Diese regeln z.B., dass keine gewaltverherrlichenden Inhalte hochgeladen werden dürfen. Wir hoffen, dass das auch vorher klar war 😅
''';
const _markdownText4 = '''
**Das war's!**

Damit du weitermachen kannst, brauchen wir noch deine Zustimmung zu den unten aufgeführten Punkten.

Falls du keine Einstimmung geben willst, dann kannst du hier dein Konto löschen oder den Support kontaktieren.

Wir danken dir, uns bis hierhin begleitet zu haben. 

Euer Sharezone-Team 💙

''';
