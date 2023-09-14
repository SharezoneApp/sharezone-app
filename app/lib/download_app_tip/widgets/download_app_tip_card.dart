// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../bloc/download_app_tip_bloc.dart';
import '../models/download_app_tip.dart';

/// Download-Tips werden nur in der Web-App angezeigt. Diese sollen
/// den Nutzer auffordern, die jeweilige App herunterzuladen, weil diese
/// i. d. R. deutlich stabiler und performanter sind.
///
/// Die Tips werden nur angezeigt, wenn es für die jeweilige Plattform
/// auch eine App verfügbar ist.
void showTipCardIfIsAvailable(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    Overlay.of(context)
        .insert(OverlayEntry(builder: (context) => const _TipCard()));
  });
}

class _TipCard extends StatelessWidget {
  const _TipCard();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DownloadAppTipBloc>(context);
    return StreamBuilder<DownloadAppTip?>(
      stream: bloc.getDownloadTipIfShouldShowTip(),
      builder: (context, snapshot) {
        final tip = snapshot.data;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: tip != null
              ? OverlayCard(
                  title: Text(tip.title.toUpperCase()),
                  content: Text(tip.description),
                  onClose: () => bloc.closeTip(tip),
                  actionText: tip.actionText.toUpperCase(),
                  onAction: () {
                    bloc.markTipAsOpened(tip);
                    launchURL(tip.actionLink);
                  },
                )
              // Ein Container-Widget kann nicht verwendet werden, weil ansonsten
              // die OverlayCard beim animierten Wechsel (durch den AnimatedSwitcher)
              // für einen sehr kurzen Augenblick in der Mitte des Screens ist und
              // dies sehr komisch aussieht.
              : const Text(""),
        );
      },
    );
  }
}
