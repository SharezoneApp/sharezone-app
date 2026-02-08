// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
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
      appBar: AppBar(title: Text(context.l10n.icalLinksPageTitle)),
      body: const SingleChildScrollView(
        child: MaxWidthConstraintBox(
          child: SafeArea(child: Column(children: [_Header(), _Body()])),
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
      tooltip: context.l10n.icalLinksPageNewLink,
      label: context.l10n.icalLinksPageNewLink,
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
      id: const ICalLinkId('1'),
      name: 'Mein Stundenplan',
      sources: [],
      status: ICalLinkStatus.available,
      url: Uri.parse('https://ical.sharezone.net/...'),
      error: null,
    );
    return _LinkTile(view: view, isLoading: true);
  }
}

class _Error extends StatelessWidget {
  const _Error(this.state);

  final ICalLinksPageStateError state;

  @override
  Widget build(BuildContext context) {
    return ErrorCard(
      message: Text(state.message),
      onContactSupportPressed:
          () => Navigator.pushNamed(context, SupportPage.tag),
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
      children: [for (final view in state.views) _LinkTile(view: view)],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          context.l10n.icalLinksPageEmptyState,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

enum _LinkAction { delete, copy }

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionCard(
                header: Text(context.l10n.icalLinksPageWhatIsAnIcalLinkHeader),
                body: Text(
                  context.l10n.timetableSettingsIcalLinksPlusDialogContent,
                ),
                backgroundColor: color,
              ),
              const SizedBox(height: 16),
              ExpansionCard(
                header: Text(
                  context.l10n.icalLinksPageHowToAddIcalLinkToCalendarHeader,
                ),
                body: Text(
                  context.l10n.icalLinksPageHowToAddIcalLinkToCalendarBody,
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
  const _LinkTile({required this.view, this.isLoading = false});

  final ICalLinkView view;
  final bool isLoading;

  Future<void> copyUrlToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: view.url.toString()));
  }

  void showCopyConformationSnackBar(BuildContext context) {
    showSnackSec(context: context, text: context.l10n.icalLinksPageLinkCopied);
  }

  void deleteLink(BuildContext context) {
    context.read<IcalLinksPageController>().deleteLink(view.id);
  }

  void showDeletedLinkSnackBar(BuildContext context) {
    showSnackSec(context: context, text: context.l10n.icalLinksPageLinkDeleted);
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
          onTap:
              view.hasUrl
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
                    title: Text(context.l10n.icalLinksPageCopyLink),
                  ),
                ),
                PopupMenuItem(
                  value: _LinkAction.delete,
                  child: ListTile(
                    mouseCursor: cursor,
                    leading: const Icon(Icons.delete),
                    title: Text(context.l10n.commonActionsDelete),
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

  String getSubtitle(BuildContext context) {
    if (view.hasError) {
      return context.l10n.icalLinksPageErrorSubtitle(view.error ?? '');
    }

    if (view.hasUrl) {
      return '${view.url}';
    }

    return switch (view.status) {
      ICalLinkStatus.available => context.l10n.icalLinksPageLinkLoading,
      ICalLinkStatus.building => context.l10n.icalLinksPageBuilding,
      ICalLinkStatus.locked => context.l10n.icalLinksPageLocked,
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
    final text = getSubtitle(context);
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
              color:
                  hasError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
