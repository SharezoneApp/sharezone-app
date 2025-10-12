// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dialog_wrapper.dart';
import 'snackbars.dart';

const _trustedDomainsStoreKey =
    'sharezone_widgets.markdown.trusted_link_domains';

/// Launches [href] in an external application while preventing deceptive
/// markdown links from opening without a warning dialog.
///
/// When the visible markdown text ([text]) differs from [href], a confirmation
/// dialog is shown. Users can optionally trust the link's domain to skip the
/// dialog for future taps.
Future<void> launchSafeLink({
  required String text,
  required String href,
  required BuildContext context,
  required KeyValueStore keyValueStore,
}) async {
  final sanitizedHref = href.trim();
  final sanitizedText = text.trim();

  if (sanitizedHref.isEmpty) {
    showSnackSec(
      context: context,
      text: 'Der Link konnte nicht geöffnet werden!',
    );
    return;
  }

  final uri = Uri.tryParse(sanitizedHref);
  if (uri == null || (!uri.hasScheme && !uri.hasAuthority)) {
    showSnackSec(
      context: context,
      text: 'Der Link konnte nicht geöffnet werden!',
    );
    return;
  }

  final domain = uri.host.isNotEmpty ? uri.host.toLowerCase() : null;
  final textMatchesHref = sanitizedText == sanitizedHref;
  final isTrustedDomain =
      domain != null &&
      _isDomainTrusted(keyValueStore: keyValueStore, domain: domain);

  _LinkDialogResult? dialogResult;

  if (!textMatchesHref && !isTrustedDomain) {
    dialogResult = await _showLinkConfirmationDialog(
      context: context,
      displayText: sanitizedText,
      href: sanitizedHref,
      domain: domain,
    );

    if (dialogResult == null || !dialogResult.open) {
      return;
    }
  }

  if ((dialogResult?.trustDomain ?? false) && domain != null) {
    await _storeTrustedDomain(keyValueStore: keyValueStore, domain: domain);
  }

  final bool didLaunch = await _launchExternally(uri);

  if (!didLaunch && context.mounted) {
    showSnackSec(
      context: context,
      text: 'Der Link konnte nicht geöffnet werden!',
    );
  }
}

Future<_LinkDialogResult?> _showLinkConfirmationDialog({
  required BuildContext context,
  required String displayText,
  required String href,
  required String? domain,
}) {
  return showDialog<_LinkDialogResult>(
    context: context,
    builder: (dialogContext) {
      bool trustDomain = false;

      return DialogWrapper(
        child: StatefulBuilder(
          builder: (builderContext, setState) {
            final ThemeData theme = Theme.of(builderContext);

            return AlertDialog(
              title: const Text('Link überprüfen'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Der Link-Text stimmt nicht mit der tatsächlichen Adresse überein.',
                  ),
                  const SizedBox(height: 12),
                  _LinkPreview(
                    label: 'Angezeigter Text',
                    value: displayText.isEmpty ? '-' : displayText,
                  ),
                  const SizedBox(height: 8),
                  _LinkPreview(label: 'Tatsächliche Adresse', value: href),
                  if (domain != null && domain.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: trustDomain,
                      onChanged:
                          (value) =>
                              setState(() => trustDomain = value ?? false),
                      title: Text('Domain $domain vertrauen'),
                      subtitle: const Text(
                        'Beim nächsten Mal nicht mehr nachfragen.',
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.of(builderContext).pop(
                        const _LinkDialogResult(
                          open: false,
                          trustDomain: false,
                        ),
                      ),
                  child: Text('Abbrechen', style: theme.textTheme.labelLarge),
                ),
                FilledButton(
                  onPressed:
                      () => Navigator.of(builderContext).pop(
                        _LinkDialogResult(open: true, trustDomain: trustDomain),
                      ),
                  child: const Text('Link öffnen'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

bool _isDomainTrusted({
  required KeyValueStore keyValueStore,
  required String domain,
}) {
  final List<String>? stored = keyValueStore.tryGetStringList(
    _trustedDomainsStoreKey,
  );

  if (stored == null || stored.isEmpty) {
    return false;
  }

  return stored.any((value) => value.toLowerCase() == domain.toLowerCase());
}

Future<void> _storeTrustedDomain({
  required KeyValueStore keyValueStore,
  required String domain,
}) async {
  final List<String> current = List<String>.from(
    keyValueStore.tryGetStringList(_trustedDomainsStoreKey) ?? [],
  );

  final String normalized = domain.toLowerCase();
  if (current.any((value) => value.toLowerCase() == normalized)) {
    return;
  }

  current.add(normalized);
  current.sort();

  await keyValueStore.setStringList(_trustedDomainsStoreKey, current);
}

Future<bool> _launchExternally(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}

class _LinkDialogResult {
  const _LinkDialogResult({required this.open, required this.trustDomain});

  final bool open;
  final bool trustDomain;
}

class _LinkPreview extends StatelessWidget {
  const _LinkPreview({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color background = theme.colorScheme.primary.withValues(alpha: 0.1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
