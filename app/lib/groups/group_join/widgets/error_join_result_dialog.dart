// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/groups/group_join/models/group_join_exception.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ErrorJoinResultDialog extends StatelessWidget {
  final ErrorJoinResult errorJoinResult;

  const ErrorJoinResultDialog({super.key, required this.errorJoinResult});
  @override
  Widget build(BuildContext context) {
    if (errorJoinResult.groupJoinException is NoInternetGroupJoinException) {
      return _NoInternet();
    }
    if (errorJoinResult.groupJoinException is AlreadyMemberGroupJoinException) {
      return _AlreadyMember();
    }
    if (errorJoinResult.groupJoinException
        is GroupNotPublicGroupJoinException) {
      return _NotPublic();
    }
    if (errorJoinResult.groupJoinException
        is SharecodeNotFoundGroupJoinException) {
      return _NotFound();
    }

    return _UnknownError();
  }
}

class _UnknownError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: context.l10n.groupJoinErrorUnknownTitle,
      iconData: Icons.error,
      iconColor: Colors.red,
      description: context.l10n.groupJoinErrorUnknownDescription,
    );
  }
}

class _NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: context.l10n.groupJoinErrorNoInternetTitle,
      iconData: Icons.error,
      iconColor: Colors.red,
      description: context.l10n.groupJoinErrorNoInternetDescription,
    );
  }
}

class _AlreadyMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: context.l10n.groupJoinErrorAlreadyMemberTitle,
      iconData: Icons.error,
      iconColor: Colors.red,
      description: context.l10n.groupJoinErrorAlreadyMemberDescription,
    );
  }
}

class _NotPublic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: context.l10n.groupJoinErrorNotPublicTitle,
      iconData: Icons.error,
      iconColor: Colors.red,
      description: context.l10n.groupJoinErrorNotPublicDescription,
    );
  }
}

class _NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: context.l10n.groupJoinErrorSharecodeNotFoundTitle,
      iconData: Icons.error,
      iconColor: Colors.red,
      description: context.l10n.groupJoinErrorSharecodeNotFoundDescription,
    );
  }
}
