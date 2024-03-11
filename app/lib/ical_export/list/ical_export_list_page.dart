import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharezone/ical_export/create/ical_export_create_page.dart';
import 'package:sharezone/ical_export/shared/ical_export_status.dart';
import 'package:sharezone/ical_export/list/ical_export_view.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ICalExportPage extends StatelessWidget {
  const ICalExportPage({super.key});

  static const tag = 'ical-export-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export (iCal)')),
      body: const _Body(),
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
      tooltip: 'Neuer Export',
      label: 'Neuer Export',
      onPressed: () => Navigator.pushNamed(context, ICalExportCreatePage.tag),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    const views = <ICalExportView>[
      ICalExportView(
        id: '1',
        name: 'Stundenplan',
        sources: [],
        status: ICalExportStatus.available,
        url: null,
        error: "asdf",
      ),
    ];
    return ListView.builder(
      itemCount: views.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _Header();
        }

        final export = views[index - 1];
        return _ExportTile(export: export);
      },
    );
  }
}

enum _ExportAction {
  edit,
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
                header: const Text('Was ist ein iCal Export?'),
                body: const Text(
                  'Mit einem iCal Export kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim "Zum Kalender hinzufügen" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.',
                ),
                backgroundColor: color,
              ),
              const SizedBox(height: 16),
              ExpansionCard(
                header: const Text(
                    'Wie füge ich einen iCal Export zu meinem Kalender hinzu?'),
                body: const Text(
                  'Wenn du auf einen Termin klickst, kannst du ihn direkt zu deinem Kalender hinzufügen. Das ist praktisch, wenn du nur einen einzelnen Termin in deinem Kalender haben möchtest. Mit einem iCal Export kannst du deinen gesamten Stundenplan oder alle Termine in deinem Kalender einbinden und musst diese nicht manuell ändern, wenn sich etwas ändert.',
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

class _ExportTile extends StatelessWidget {
  const _ExportTile({
    required this.export,
  });

  final ICalExportView export;

  Future<void> _copyUrlToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: '${export.url}'));
  }

  void showCopyConformationSnackBar(BuildContext context) {
    showSnackSec(context: context, text: 'Link in Zwischenablage kopiert');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(export.name),
      subtitle: _Subtitle(export: export),
      onTap: export.hasUrl
          ? () async {
              await _copyUrlToClipboard(context);
              if (context.mounted) showCopyConformationSnackBar(context);
            }
          : null,

      /// More menu button with edit, delete, copy button
      trailing: PopupMenuButton<_ExportAction>(
        onSelected: (action) {
          switch (action) {
            case _ExportAction.edit:
              break;
            case _ExportAction.delete:
              break;
            case _ExportAction.copy:
              _copyUrlToClipboard(context);
              showCopyConformationSnackBar(context);
              break;
          }
        },
        itemBuilder: (context) {
          const cursor = SystemMouseCursors.click;
          return [
            PopupMenuItem(
              value: _ExportAction.copy,
              enabled: export.hasUrl,
              child: ListTile(
                mouseCursor: export.hasUrl ? cursor : null,
                leading: const Icon(Icons.content_copy),
                title: const Text('Link kopieren'),
              ),
            ),
            const PopupMenuItem(
              value: _ExportAction.edit,
              child: ListTile(
                mouseCursor: cursor,
                leading: Icon(Icons.edit),
                title: Text('Bearbeiten'),
              ),
            ),
            const PopupMenuItem(
              value: _ExportAction.delete,
              child: ListTile(
                mouseCursor: cursor,
                leading: Icon(Icons.delete),
                title: Text('Löschen'),
              ),
            ),
          ];
        },
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.export});

  final ICalExportView export;

  String getSubtitle() {
    if (export.hasError) {
      return 'Fehler: ${export.error}';
    }

    if (export.hasUrl) {
      return '${export.url}';
    }

    return switch (export.status) {
      ICalExportStatus.available => 'Link wird geladen...',
      ICalExportStatus.building => 'Wird erstellt...',
      ICalExportStatus.locked => 'Gesperrt',
    };
  }

  bool isShimmerEnabled() {
    if (export.hasError) {
      return false;
    }

    if (export.status == ICalExportStatus.building) {
      return true;
    }

    final isUrlLoading =
        export.status == ICalExportStatus.available && !export.hasUrl;
    return isUrlLoading;
  }

  @override
  Widget build(BuildContext context) {
    final text = getSubtitle();
    final hasError = export.hasError;
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
              color: hasError ? Theme.of(context).colorScheme.error : null,
            ),
          ),
        ),
      ),
    );
  }
}
