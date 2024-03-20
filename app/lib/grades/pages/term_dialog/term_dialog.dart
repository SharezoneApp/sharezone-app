import 'package:flutter/material.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'term_dialog_controller.dart';

class TermDialog extends StatelessWidget {
  const TermDialog({super.key, required this.gradesService});

  final GradesService gradesService;

  static const tag = 'term-dialog';

  @override
  Widget build(BuildContext context) {
    final controller = TermDialogController(gradesService);
    return MaxWidthConstraintBox(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrefilledTextField(
                  key: const ValueKey('term-name-field'),
                  decoration:
                      const InputDecoration(labelText: 'Name des Halbjahres'),
                  prefilledText: controller.termName,
                  onChanged: (value) {
                    controller.setTermName(value);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  key: const ValueKey('save-button'),
                  onPressed: () async {
                    await controller.createTerm();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Halbjahr erstellen'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  key: const ValueKey('cancel-button'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Abbrechen'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
