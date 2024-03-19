import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/ical_links/dialog/ical_links_dialog.dart';
import 'package:sharezone/ical_links/list/ical_links_page_controller.dart';
import 'package:sharezone/ical_links/shared/ical_link_status.dart';
import 'package:sharezone/ical_links/list/ical_link_view.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ICalLinksPage extends StatelessWidget {
  const ICalLinksPage({super.key});

  static const tag = 'ical-links-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('iCal-Links')),
      body: const SingleChildScrollView(
        child: MaxWidthConstraintBox(
          child: SafeArea(
            child: Column(children: [
              _Header(),
              _Body(),
            ]),
          ),
        ),
      ),
      floatingActionButton: const _Fab(),
    );
  }
}

class _Fab extends StatelessWidget {
  const _Fab();

  @override
  Widget build(BuildContext context) {
    return ModalFloatingActionButton(
      icon: const Icon(Icons.add),
      tooltip: 'Neuer Link',
      label: 'Neuer Link',
      onPressed: () => Navigator.pushNamed(context, ICalLinksDialog.tag),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<IcalLinksPageController>();
    final state = controller.state;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (state) {
          ICalLinksPageStateLoading() => const _Loading(),
          ICalLinksPageStateError() => _Error(state),
          ICalLinksPageStateLoaded() => _Loaded(state),
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    final view = ICalLinkView(
      id: ICalLinkId('1'),
      name: 'Mein Stundenplan',
      sources: [],
      status: ICalLinkStatus.available,
      url: Uri.parse('https://ical.sharezone.net/...'),
      error: null,
    );
    return _LinkTile(
      view: view,
      isLoading: true,
    );
  }
}

class _Error extends StatelessWidget {
  const _Error(this.state);

  final ICalLinksPageStateError state;

  @override
  Widget build(BuildContext context) {
    return ErrorCard(
      message: Text(state.message),
      onContactSupportPressed: () =>
          Navigator.pushNamed(context, SupportPage.tag),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded(this.state);

  final ICalLinksPageStateLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.views.isEmpty) {
      return const _Empty();
    }

    return Column(
      children: [
        for (final view in state.views) _LinkTile(view: view),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Text(
          'Du hast noch keine iCal-Links erstellt.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

enum _LinkAction {
  delete,
  copy,
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withOpacity(0.1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionCard(
                header: const Text('Was ist ein iCal Link?'),
                body: const Text(
                  'Mit einem iCal-Link kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim "Zum Kalender hinzufügen" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.\n\niCal-Links ist nur für dich sichtbar und können nicht von anderen Personen eingesehen werden.',
                ),
                backgroundColor: color,
              ),
              const SizedBox(height: 16),
              ExpansionCard(
                header: const Text(
                    'Wie füge ich einen iCal-Link zu meinem Kalender hinzu?'),
                body: const Text(
                  '1. Kopiere den iCal-Link\n2. Öffne deinen Kalender (z.B. Google Kalender, Apple Kalender)\n3. Füge einen neuen Kalender hinzu\n4. Wähle "Über URL hinzufügen" oder "Über das Internet hinzufügen"\n5. Füge den iCal-Link ein\n6. Fertig! Dein Stundenplan und deine Termine werden nun in deinem Kalender angezeigt.',
                ),
                backgroundColor: color,
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.view,
    this.isLoading = false,
  });

  final ICalLinkView view;
  final bool isLoading;

  Future<void> copyUrlToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: '${view.url}'));
  }

  void showCopyConformationSnackBar(BuildContext context) {
    showSnackSec(context: context, text: 'Link in Zwischenablage kopiert.');
  }

  void deleteLink(BuildContext context) {
    context.read<IcalLinksPageController>().deleteLink(view.id);
  }

  void showDeletedLinkSnackBar(BuildContext context) {
    showSnackSec(context: context, text: 'Link gelöscht.');
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: GrayShimmer(
        enabled: isLoading,
        child: ListTile(
          title: Text(view.name),
          subtitle: _Subtitle(view: view),
          onTap: view.hasUrl
              ? () async {
                  await copyUrlToClipboard(context);
                  if (context.mounted) showCopyConformationSnackBar(context);
                }
              : null,

          /// More menu button with edit, delete, copy button
          trailing: PopupMenuButton<_LinkAction>(
            onSelected: (action) {
              switch (action) {
                case _LinkAction.delete:
                  deleteLink(context);
                  showDeletedLinkSnackBar(context);
                  break;
                case _LinkAction.copy:
                  copyUrlToClipboard(context);
                  showCopyConformationSnackBar(context);
                  break;
              }
            },
            itemBuilder: (context) {
              const cursor = SystemMouseCursors.click;
              return [
                PopupMenuItem(
                  value: _LinkAction.copy,
                  enabled: view.hasUrl,
                  child: ListTile(
                    mouseCursor: view.hasUrl ? cursor : null,
                    leading: const Icon(Icons.content_copy),
                    title: const Text('Link kopieren'),
                  ),
                ),
                const PopupMenuItem(
                  value: _LinkAction.delete,
                  child: ListTile(
                    mouseCursor: cursor,
                    leading: Icon(Icons.delete),
                    title: Text('Löschen'),
                  ),
                ),
              ];
            },
          ),
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.view});

  final ICalLinkView view;

  String getSubtitle() {
    if (view.hasError) {
      return 'Fehler: ${view.error}';
    }

    if (view.hasUrl) {
      return '${view.url}';
    }

    return switch (view.status) {
      ICalLinkStatus.available => 'Link wird geladen...',
      ICalLinkStatus.building => 'Wird erstellt...',
      ICalLinkStatus.locked => 'Gesperrt',
    };
  }

  bool isShimmerEnabled() {
    if (view.hasError) {
      return false;
    }

    if (view.status == ICalLinkStatus.building) {
      return true;
    }

    final isUrlLoading =
        view.status == ICalLinkStatus.available && !view.hasUrl;
    return isUrlLoading;
  }

  @override
  Widget build(BuildContext context) {
    final text = getSubtitle();
    final hasError = view.hasError;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Align(
        key: ValueKey(text),
        alignment: Alignment.centerLeft,
        child: GrayShimmer(
          enabled: isShimmerEnabled(),
          child: Text(
            text,
            overflow: hasError ? null : TextOverflow.ellipsis,
            maxLines: hasError ? null : 1,
            style: TextStyle(
              color: hasError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
