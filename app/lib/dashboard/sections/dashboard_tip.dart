// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

class _DashboardTipSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final system = BlocProvider.of<DashboardTipSystem>(context);

    return StreamBuilder<DashboardTip?>(
      stream: system.dashboardTip,
      builder: (context, snapshot) {
        final dashboardTip = snapshot.data;

        if (dashboardTip == null) return Container();
        return _DashboardTipCard(dashboardTip);
      },
    );
  }
}

class _DashboardTipCard extends StatelessWidget {
  const _DashboardTipCard(this.dashboardTip);

  final DashboardTip dashboardTip;

  @override
  Widget build(BuildContext context) {
    final isRateOurAppTip = dashboardTip is RateOurAppTip;
    final title =
        isRateOurAppTip
            ? context.l10n.dashboardRateOurAppTitle
            : dashboardTip.title;
    final text =
        isRateOurAppTip
            ? context.l10n.dashboardRateOurAppText
            : dashboardTip.text;
    final actionTitle =
        isRateOurAppTip
            ? context.l10n.dashboardRateOurAppActionTitle
            : dashboardTip.action.title;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: AnnouncementCard(
          key: ValueKey(dashboardTip),
          padding: const EdgeInsets.all(0),
          color:
              Theme.of(context).isDarkTheme
                  ? Colors.deepOrange[700]!
                  : Colors.amberAccent,
          title: title,
          content: Text(text),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: darkBlueColor, // foreground
              ),
              child: Text(context.l10n.commonActionsCloseUppercase),
              onPressed: () => dashboardTip.markAsShown(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: darkBlueColor, // foreground
              ),
              child: Text(actionTitle.toUpperCase()),
              onPressed: () {
                dashboardTip.markAsShown();
                dashboardTip.action.onTap(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
