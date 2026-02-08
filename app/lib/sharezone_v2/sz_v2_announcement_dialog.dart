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
import 'package:sharezone_localizations/sharezone_localizations.dart';
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
      builder:
          (context) => _StudentDialog(
            BlocProvider.of<SharezoneContext>(
              context,
            ).api.user.data!.typeOfUser.isStudent,
          ),
    ),
  );
}

const _skipKey = 'v2-dialog-skipped-on';

class SharezoneV2AnnoucementDialogGuard extends StatelessWidget {
  const SharezoneV2AnnoucementDialogGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final szContext = BlocProvider.of<SharezoneContext>(context);

    bool skip = false;
    try {
      final dialogSkippedNum = szContext.sharedPreferences.getInt(_skipKey);
      DateTime? dialogSkipped =
          dialogSkippedNum != null
              ? DateTime.fromMillisecondsSinceEpoch(dialogSkippedNum)
              : null;
      skip =
          dialogSkipped != null &&
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
      },
    );
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
          title: Text(context.l10n.sharezoneV2DialogTitle),
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
                  },
                ),
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
                        'Back',
                        style: TextStyle(
                          color:
                              context.isDarkThemeEnabled ? null : primaryColor,
                        ),
                      ),
                      onPressed: () {
                        controller.previousPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        !isLastPage || _allCheckboxesChecked
                            ? () async {
                              if (controller.page == lastPage) {
                                final ctx = BlocProvider.of<SharezoneContext>(
                                  context,
                                );
                                // We navigate beforehand, so that the context
                                // is not already unmounted when we try to
                                // navigate.
                                BlocProvider.of<NavigationBloc>(
                                  context,
                                ).navigateTo(NavigationItem.sharezonePlus);
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
                                      title: context.l10n.commonErrorTitle,
                                      content: Text(
                                        context.l10n
                                            .sharezoneV2DialogSubmitError(
                                              e.toString(),
                                            ),
                                      ),
                                    );
                                  }
                                }
                              } else {
                                controller.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                );
                              }
                            }
                            : null,
                    child: Text(
                      isLastPage
                          ? context.l10n.activationCodeResultDoneAction
                          : context.l10n.commonActionsContinue,
                      style: TextStyle(
                        color: context.isDarkThemeEnabled ? null : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
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
          SharezonePlusAdvantages(isHomeworkReminderFeatureVisible: true),
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
            if (isStudent) const _JustText(markdownText: '## More changes'),
            if (!isStudent) ...[
              const _JustText(markdownText: '## Important changes'),
              const SizedBox(height: 10),
              const _JustText(
                markdownText: '''
Hello from the Sharezone team :) We have a few important updates we would like to share.  
''',
              ),
            ],
            const SizedBox(height: 10),
            _Card(
              header: Text(
                context.l10n.sharezoneV2DialogChangedLegalFormHeader,
              ),
              body: const MarkdownBody(
                data:
                    'Sharezone is no longer operated under "Sander, Jonas; Reichardt, Nils; Weuthen, Felix Sharezone GbR", but under "Sharezone UG (limited liability)".',
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              header: Text(
                context.l10n.sharezoneV2DialogPrivacyPolicyRevisionHeader,
              ),
              body: MarkdownBody(
                data:
                    'We have revised the [privacy policy](privacy-policy) and documented in detail how your data is processed and protected.${isStudent ? ' For Sharezone Plus, we also had to integrate additional external services (for example payment handling and sending emails).' : ''}',
                onTapLink: (text, href, title) {
                  Navigator.of(context).pushNamed(PrivacyPolicyPage.tag);
                },
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              header: Text(context.l10n.sharezoneV2DialogTermsHeader),
              body: MarkdownBody(
                data:
                    'We have new [terms of service](terms-of-service) that must be accepted for future use of Sharezone.',
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
  const _Card({required this.header, required this.body});

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: header,
      body: body,
      backgroundColor:
          context.isDarkThemeEnabled
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : primaryColor.withValues(alpha: .3),
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
      child: MarkdownBody(data: markdownText, onTapLink: onLinkTap),
    );
  }
}

class _FinalPage extends StatefulWidget {
  const _FinalPage({
    required this.onCheckboxesChanged,
    required this.isStudent,
  });

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
**That is all!**
    
To continue, we still need your consent to the points listed below.
    
If you do not want to give consent, you can contact support [here](other-options).
${widget.isStudent ? '\n\nThanks for supporting us this far.' : ''}
        
  Your Sharezone team 💙''',
              onLinkTap: (text, href, title) {
                if (href == 'other-options') {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamed(SupportPage.tag);
                }
              },
            ),
            const SizedBox(height: 30),
            _Checkbox(
              text: context.l10n.sharezoneV2DialogAnbAcceptanceCheckbox,
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
                  'I acknowledge that "Sharezone UG (limited liability)" operates Sharezone.',
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
                  'Your personal data is processed according to our updated '
                  '[privacy policy](https://sharezone.net/privacy-policy).',
              onLinkTap: (text, href, title) {
                Navigator.of(context).pushNamed(PrivacyPolicyPage.tag);
              },
            ),
            const SizedBox(height: 10),
            if (clock.now().isBefore(DateTime(2024, 05, 15)))
              TextButton(
                onPressed: () {
                  BlocProvider.of<SharezoneContext>(context).sharedPreferences
                      .setInt(_skipKey, clock.now().millisecondsSinceEpoch);
                  Navigator.of(context).popAndPushNamed(DashboardPage.tag);
                },
                child: Text(context.l10n.commonActionsSkip),
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
Great to have you here! :)

Until now, we have run Sharezone for free with a lot of effort because we first wanted to build a great school app.  

We are very happy that it is so well received and that you use it so actively 💙🫶  

Now the time has come for Sharezone to finance itself so it can keep running long-term 🏁🏃  

How exactly? Click "Continue" and we will show you.

''';

const _markdownText2 = '''
## Sharezone Plus

Sharezone Plus gives you access to optional premium features.

For example, you can manage your grades or get more file storage.  

You can still use the app for free without Sharezone Plus, with a few small limitations.  

Using a payment link, Sharezone Plus can also be purchased online by, for example, your parents.
''';
