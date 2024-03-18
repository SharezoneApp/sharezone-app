import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/ical_export/dialog/ical_export_dialog_page.dart';
import 'package:sharezone/ical_export/list/ical_export_list_controller.dart';
import 'package:sharezone/ical_export/shared/ical_export_status.dart';
import 'package:sharezone/ical_export/list/ical_export_view.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ICalExportPage extends StatelessWidget {
  const ICalExportPage({super.key});

  static const tag = 'ical-export-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export (iCal)')),
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
    final controller = context.watch<IcalExportListController>();
    final state = controller.state;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (state) {
          IcalExportListLoading() => const _Loading(),
          IcalExportListError() => _Error(state),
          IcalExportListLoaded() => _Loaded(state),
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    final view = ICalExportView(
      id: ICalExportId('1'),
      name: 'Mein Stundenplan',
      sources: [],
      status: ICalExportStatus.available,
      url: Uri.parse('https://ical.sharezone.net/...'),
      error: null,
    );
    return _ExportTile(
      export: view,
      isLoading: true,
    );
  }
}

class _Error extends StatelessWidget {
  const _Error(this.state);

  final IcalExportListError state;

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

  final IcalExportListLoaded state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final export in state.views) _ExportTile(export: export),
      ],
    );
  }
}

enum _ExportAction {
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
                  'Mit einem iCal Export kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim "Zum Kalender hinzufügen" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.\n\nEin iCal Export ist nur für dich sichtbar und kann nicht von anderen Personen eingesehen werden.',
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
    this.isLoading = false,
  });

  final ICalExportView export;
  final bool isLoading;

  Future<void> copyUrlToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: '${export.url}'));
  }

  void showCopyConformationSnackBar(BuildContext context) {
    showSnackSec(context: context, text: 'Link in Zwischenablage kopiert.');
  }

  void deleteExport(BuildContext context) {
    context.read<IcalExportListController>().deleteExport(export.id);
  }

  void showDeletedExportSnackBar(BuildContext context) {
    showSnackSec(context: context, text: 'Export gelöscht.');
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: GrayShimmer(
        enabled: isLoading,
        child: ListTile(
          title: Text(export.name),
          subtitle: _Subtitle(export: export),
          onTap: export.hasUrl
              ? () async {
                  await copyUrlToClipboard(context);
                  if (context.mounted) showCopyConformationSnackBar(context);
                }
              : null,

          /// More menu button with edit, delete, copy button
          trailing: PopupMenuButton<_ExportAction>(
            onSelected: (action) {
              switch (action) {
                case _ExportAction.delete:
                  deleteExport(context);
                  showDeletedExportSnackBar(context);
                  break;
                case _ExportAction.copy:
                  copyUrlToClipboard(context);
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
        ),
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
