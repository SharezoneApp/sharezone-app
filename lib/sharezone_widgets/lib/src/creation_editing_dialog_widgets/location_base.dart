import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class LocationBase extends StatelessWidget {
  const LocationBase({
    super.key,
    this.onChanged,
    this.prefilledText,
    this.textFieldKey,
  });

  final void Function(String)? onChanged;
  final String? prefilledText;
  final Key? textFieldKey;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.location_pin),
              title: PrefilledTextField(
                key: textFieldKey,
                prefilledText: prefilledText,
                maxLines: null,
                scrollPadding: const EdgeInsets.all(16.0),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: "Ort/Raum",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                ),
                onChanged: onChanged,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
