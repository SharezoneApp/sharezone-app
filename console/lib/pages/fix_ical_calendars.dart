import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class FixICalCalendars extends StatefulWidget {
  const FixICalCalendars({super.key});

  @override
  State<FixICalCalendars> createState() => _FixICalCalendarsState();
}

class _FixICalCalendarsState extends State<FixICalCalendars> {
  int? amountOfFixedCalendars;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fix iCal Calendars"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              child: Text(
                'A cloud function that can be used to check if some iCal calendars are not in sync with the database. If they are not in sync, they will be fixed.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            _Button(
              (int amount) {
                setState(() {
                  amountOfFixedCalendars = amount;
                });
              },
            ),
            if (amountOfFixedCalendars != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("Fixed $amountOfFixedCalendars calendars"),
              ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatefulWidget {
  const _Button(this.amountOfFixedCalendars);

  final ValueChanged<int> amountOfFixedCalendars;

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });

              try {
                final cfs =
                    FirebaseFunctions.instanceFor(region: 'europe-west1');
                final function = cfs.httpsCallable('fixICalCalendars');

                final result = await function.call<Map<String, dynamic>>();
                widget.amountOfFixedCalendars(
                    result.data['amountOfFixedCalendars']);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                  ),
                );
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            },
      child: Text(
        isLoading ? "Loading..." : "Fix",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
