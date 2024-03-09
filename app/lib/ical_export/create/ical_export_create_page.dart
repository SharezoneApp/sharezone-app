import 'package:flutter/material.dart';
import 'package:sharezone/ical_export/shared/ical_export_sources.dart';
import 'package:sharezone/widgets/material/save_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ICalExportCreatePage extends StatelessWidget {
  const ICalExportCreatePage({super.key});

  static const tag = 'ical-export-create-page';

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
    return SingleChildScrollView(
      child: SafeArea(
        child: MaxWidthConstraintBox(
          child: Column(
            children: const [
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
    return const ListTile(
      leading: Icon(Icons.short_text),
      title: TextField(
        decoration: InputDecoration(
          labelText: 'Name',
          hintText: 'z.B. Stundenplan',
        ),
      ),
    );
  }
}

class _Sources extends StatelessWidget {
  const _Sources({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'Welche Quellen sollen in den Export aufgenommen werden?',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          for (final source in ICalExportSource.values)
            CheckboxListTile(
              value: false,
              title: Text(source.getUiName()),
              secondary: source.getIcon(),
              onChanged: (_) {},
            )
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilledButton(
          child: const Text('Speichern'),
          onPressed: () {},
        ),
      ),
    );
  }
}
