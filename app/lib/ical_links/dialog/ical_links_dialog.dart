import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/ical_links/dialog/ical_links_dialog_controller.dart';
import 'package:sharezone/ical_links/dialog/ical_links_dialog_controller_factory.dart';
import 'package:sharezone/ical_links/shared/ical_link_source.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ICalLinksDialog extends StatelessWidget {
  const ICalLinksDialog({
    super.key,
  });

  static const tag = 'ical-links-dialog';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final factory = context.read<ICalLinksDialogControllerFactory>();
        return factory.create();
      },
      child: Scaffold(
        body: Column(
          children: [
            _AppBar(
              onCloseTap: () => Navigator.pop(context),
              titleField: _TitleField(focusNode: FocusNode()),
            ),
            const SingleChildScrollView(
              child: SafeArea(
                child: MaxWidthConstraintBox(
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      _Sources(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            _PrivateNote(),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.onCloseTap,
    required this.titleField,
  });

  final VoidCallback onCloseTap;
  final Widget titleField;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).isDarkTheme
          ? Theme.of(context).appBarTheme.backgroundColor
          : Theme.of(context).primaryColor,
      elevation: 1,
      child: SafeArea(
        top: true,
        bottom: false,
        child: MaxWidthConstraintBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 6, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: onCloseTap,
                      tooltip: "Schließen",
                    ),
                    const _SaveButton(),
                  ],
                ),
              ),
              titleField,
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.focusNode,
  });

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final error = context.select<ICalLinksDialogController, ICalDialogError?>(
        (controller) => controller.state.error);
    return MaxWidthConstraintBox(
      child: _TitleFieldBase(
        prefilledTitle: null,
        focusNode: focusNode,
        onChanged: context.read<ICalLinksDialogController>().setName,
        errorText: switch (error) {
          ICalDialogNameMissingError() => 'Bitte gib einen Namen ein',
          _ => null,
        },
      ),
    );
  }
}

class _TitleFieldBase extends StatelessWidget {
  const _TitleFieldBase({
    required this.prefilledTitle,
    required this.onChanged,
    this.errorText,
    this.focusNode,
  });

  final String? prefilledTitle;
  final String? errorText;
  final FocusNode? focusNode;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 3,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20)
              .add(const EdgeInsets.only(top: 8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PrefilledTextField(
                prefilledText: prefilledTitle,
                focusNode: focusNode,
                cursorColor: Colors.white,
                maxLines: null,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  hintText: "Name eingeben (z.B. Meine Prüfungen)",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  fillColor: Colors.transparent,
                ),
                onChanged: onChanged,
                textCapitalization: TextCapitalization.sentences,
              ),
              Text(
                errorText ?? "",
                style: TextStyle(color: Colors.red[700], fontSize: 12),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _Sources extends StatelessWidget {
  const _Sources();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ICalLinksDialogController>().state;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'Welche Quellen sollen in den Export aufgenommen werden?',
              style: TextStyle(
                fontSize: 16,
                color: switch (state.error) {
                  ICalDialogSourcesMissingError() =>
                    Theme.of(context).colorScheme.error,
                  _ => null,
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final source in ICalLinkSource.values)
            CheckboxListTile(
              value: state.sources.contains(source),
              title: Text(source.getUiName()),
              secondary: source.getIcon(),
              onChanged: (value) {
                if (value == true) {
                  context.read<ICalLinksDialogController>().addSource(source);
                } else {
                  context
                      .read<ICalLinksDialogController>()
                      .removeSource(source);
                }
              },
            ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  void showErrorSnackBar(BuildContext context) {
    final error = context.read<ICalLinksDialogController>().state.error;
    showSnackSec(
      context: context,
      text: switch (error) {
        ICalDialogNameMissingError() => 'Bitte gib einen Namen ein.',
        ICalDialogSourcesMissingError() =>
          'Bitte wähle mindestens eine Quelle aus.',
        _ => 'Es ist ein Fehler aufgetreten.',
      },
    );
  }

  void showSuccessSnackBar(BuildContext context) {
    showSnackSec(
      context: context,
      text: 'Der Export wurde erfolgreich erstellt.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SaveButton(
          onPressed: () {
            final controller = context.read<ICalLinksDialogController>();
            if (controller.validate()) {
              controller.create();
              showSuccessSnackBar(context);
              Navigator.pop(context);
            } else {
              showErrorSnackBar(context);
            }
          },
        ),
      ),
    );
  }
}

class _PrivateNote extends StatelessWidget {
  const _PrivateNote();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          "iCal Exporte sind privat und nur für dich sichtbar.",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
