// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import 'scan_area.dart';

/// Defines if the height of the device is too small to use the portrait layout.
///
/// If the height of the device of allows to use the portrait layout, the
/// portrait layout should be used. In cases where this is not possible (e.g. a
/// smartphone is in landscape mode), the landscape layout should be used.
bool _shouldUseLandscapeLayout(BuildContext context) {
  return MediaQuery.of(context).size.height < 500;
}

/// A overlay widget that displays a scan selection, a button to toggle the
/// torch (if [hasTorch] is true) and optionally a description text.
class ScanOverlay extends StatelessWidget {
  const ScanOverlay({
    Key? key,
    required this.hasTorch,
    this.description,
    this.onTorchToggled,
  }) : super(key: key);

  /// A description that is displayed below the scan selection or on the left
  /// side of the scan area.
  final Widget? description;

  /// A callback that is called when the torch is toggled.
  final VoidCallback? onTorchToggled;

  /// Defines if the device has a torch.
  ///
  /// Some devices do not have a torch. In this case, the torch button should
  /// not be displayed.
  final bool hasTorch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const ScanArea(),
          if (hasTorch)
            _ToggleTorchButton(
              onTorchToggled: onTorchToggled,
            ),
          if (description != null)
            _Description(
              description: description!,
            )
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    Key? key,
    required this.description,
  }) : super(key: key);

  final Widget description;

  @override
  Widget build(BuildContext context) {
    final isLandscapeLayout = _shouldUseLandscapeLayout(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLandscapeLayout ? 0 : 400,
        left: 32,
        right: isLandscapeLayout ? 500 : 32,
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
        child: description,
      ),
    );
  }
}

class _ToggleTorchButton extends StatefulWidget {
  const _ToggleTorchButton({
    Key? key,
    required this.onTorchToggled,
  }) : super(key: key);

  final VoidCallback? onTorchToggled;

  @override
  State<_ToggleTorchButton> createState() => _ToggleTorchButtonState();
}

class _ToggleTorchButtonState extends State<_ToggleTorchButton> {
  bool isFlashlightOn = false;

  @override
  Widget build(BuildContext context) {
    final isLandscapeLayout = _shouldUseLandscapeLayout(context);
    return Padding(
      padding: EdgeInsets.only(
        top: isLandscapeLayout ? 0 : 500,
        left: isLandscapeLayout ? 450 : 0,
      ),
      child: AnimatedSwitcher(
        key: const Key('torch-button-widget-test'),
        duration: const Duration(milliseconds: 300),
        child: CircleAvatar(
          backgroundColor: isFlashlightOn ? Colors.white54 : Colors.white12,
          radius: 25,
          child: IconButton(
            key: ValueKey(isFlashlightOn),
            onPressed: () {
              setState(() {
                isFlashlightOn = !isFlashlightOn;
              });
              if (widget.onTorchToggled != null) {
                widget.onTorchToggled!();
              }
            },
            color: Colors.white,
            icon: const Icon(Icons.flashlight_on),
            tooltip: 'todo',
          ),
        ),
      ),
    );
  }
}
