// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/report/page/report_page_bloc.dart';
import 'package:sharezone/report/report_factory.dart';
import 'package:sharezone/report/report_gateway.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/report/report_localizations.dart';
import 'package:sharezone/report/report_reason.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<void> openReportPage(
  BuildContext context,
  ReportItemReference item,
) async {
  final result = await Navigator.push<bool>(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => ReportPage(item: item),
      settings: const RouteSettings(name: ReportPage.tag),
    ),
  );

  if (result == true && context.mounted) {
    showDataArrivalConfirmedSnackbar(context: context);
  }
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key, required this.item});

  static const tag = 'report-page';

  final ReportItemReference item;

  @override
  State createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late ReportPageBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ReportPageBloc(
      item: widget.item,
      reportGateway: BlocProvider.of<ReportGateway>(context),
      reportFactory: BlocProvider.of<ReportFactory>(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reportedItemTypeLabel = l10n.reportItemTypeLabel(
      bloc.reportedItemType,
    );
    return BlocProvider(
      bloc: bloc,
      child: PopScope<Object?>(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;

          final hasInputChanged = bloc.wasEdited();
          final navigator = Navigator.of(context);
          if (!hasInputChanged) {
            navigator.pop();
            return;
          }

          final shouldPop = await warnUserAboutLeavingForm(context);
          if (shouldPop && context.mounted) {
            navigator.pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.reportPageTitle(reportedItemTypeLabel)),
            centerTitle: true,
            actions: const [_SendButton()],
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _ReasonRadioGroup(),
                  const Divider(),
                  _DescriptionField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.reportDialogSendAction,
      icon: const Icon(Icons.send),
      onPressed: () => _submit(context),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final bloc = BlocProvider.of<ReportPageBloc>(context);
    if (bloc.isSubmitValid()) {
      final confirmedSendingReport = await _showSendReportConfirmationDialog(
        context,
      );
      if (!context.mounted) return;

      if (confirmedSendingReport == true) {
        try {
          bloc.send();
          Navigator.pop(context, true);
        } on Exception catch (e, s) {
          showSnackSec(
            context: context,
            seconds: 5,
            text: handleErrorMessage(
              l10n: context.l10n,
              error: e,
              stackTrace: s,
            ),
          );
        }
      }
    } else {
      _showMissingInformationSnackBar(context);
    }
  }

  void _showMissingInformationSnackBar(BuildContext context) => showSnackSec(
    context: context,
    text: context.l10n.reportMissingInformation,
    seconds: 5,
  );

  Future<bool?> _showSendReportConfirmationDialog(BuildContext context) async {
    return showLeftRightAdaptiveDialog<bool>(
      context: context,
      defaultValue: false,
      content: Text(context.l10n.reportDialogContent),
      right: AdaptiveDialogAction(
        isDefaultAction: true,
        title: context.l10n.reportDialogSendAction,
        popResult: true,
      ),
    );
  }
}

class _ReasonRadioGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ReportPageBloc>(context);
    return StreamBuilder<ReportReason>(
      stream: bloc.reason,
      builder: (context, snapshot) {
        final currentReason = snapshot.data;
        return RadioGroup<ReportReason>(
          groupValue: currentReason,
          onChanged: (value) {
            if (value == null) return;
            bloc.changeReason(value);
          },
          child: Column(
            children: <Widget>[
              for (final reason in ReportReason.values)
                _ReasonTile(reason: reason),
            ],
          ),
        );
      },
    );
  }
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({required this.reason});

  final ReportReason reason;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ReportReason>(
      value: reason,
      title: Text(context.l10n.reportReasonLabel(reason)),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ReportPageBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Text(
            context.l10n.reportDescriptionHelperText,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              labelText: context.l10n.reportDescriptionLabel,
              icon: const Icon(Icons.short_text),
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.newline,
            maxLines: null,
            onChanged: bloc.changeDescription,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}
