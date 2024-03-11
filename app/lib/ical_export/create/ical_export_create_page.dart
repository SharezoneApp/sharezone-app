import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/ical_export/create/ical_export_create_controller.dart';
import 'package:sharezone/ical_export/shared/ical_export_sources.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ICalExportCreatePage extends StatefulWidget {
  const ICalExportCreatePage({super.key});

  static const tag = 'ical-export-create-page';

  @override
  State<ICalExportCreatePage> createState() => _ICalExportCreatePageState();
}

class _ICalExportCreatePageState extends State<ICalExportCreatePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateICalExportController>().clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neuer Export'),
        actions: const [
          _SaveButton(),
        ],
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: SafeArea(
        child: MaxWidthConstraintBox(
          child: Column(
            children: [
              _NameField(),
              SizedBox(height: 16),
              _Sources(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({super.key});

  @override
  Widget build(BuildContext context) {
    final error =
        context.select<CreateICalExportController, CreateICalExportError?>(
            (controller) => controller.state.error);
    return ListTile(
      leading: const Icon(Icons.short_text),
      title: TextField(
        onChanged: context.read<CreateICalExportController>().setName,
        decoration: InputDecoration(
          labelText: 'Name',
          hintText: 'z.B. Stundenplan',
          errorText: switch (error) {
            CreateICalExportNameMissingError() => 'Bitte gib einen Namen ein',
            _ => null,
          },
        ),
      ),
    );
  }
}

class _Sources extends StatelessWidget {
  const _Sources();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CreateICalExportController>().state;
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
                  CreateICalExportSourcesMissingError() =>
                    Theme.of(context).colorScheme.error,
                  _ => null,
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final source in ICalExportSource.values)
            CheckboxListTile(
              value: state.sources.contains(source),
              title: Text(source.getUiName()),
              secondary: source.getIcon(),
              onChanged: (value) {
                if (value == true) {
                  context.read<CreateICalExportController>().addSource(source);
                } else {
                  context
                      .read<CreateICalExportController>()
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
    final error = context.read<CreateICalExportController>().state.error;
    showSnackSec(
      context: context,
      text: switch (error) {
        CreateICalExportNameMissingError() => 'Bitte gib einen Namen ein.',
        CreateICalExportSourcesMissingError() =>
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
        child: FilledButton(
          child: const Text('Speichern'),
          onPressed: () {
            final controller = context.read<CreateICalExportController>();
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
