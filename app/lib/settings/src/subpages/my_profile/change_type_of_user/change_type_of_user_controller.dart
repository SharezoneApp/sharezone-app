// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_analytics.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_service.dart';
import 'package:user/user.dart';

class ChangeTypeOfUserController extends ChangeNotifier {
  final UserId userId;
  final ChangeTypeOfUserAnalytics analytics;
  final ChangeTypeOfUserService service;
  StreamSubscription<TypeOfUser?>? _typeOfUserSubscription;

  late ChangeTypeOfUserState state;

  /// The initial type of user of the user before the change.
  TypeOfUser? initialTypeOfUser;

  /// The currently selected type of user.
  TypeOfUser? selectedTypeOfUser;

  ChangeTypeOfUserController({
    required this.userId,
    required this.analytics,
    required this.service,
    required Stream<TypeOfUser?> typeOfUserStream,
  }) {
    state = const ChangeTypeOfUserInitial();
    _listenToTypeOfUserStream(typeOfUserStream);
  }

  void _listenToTypeOfUserStream(Stream<TypeOfUser?> typeOfUserStream) {
    _typeOfUserSubscription = typeOfUserStream.listen((typeOfUser) {
      initialTypeOfUser = typeOfUser;
      notifyListeners();
    });
  }

  Future<void> changeTypeOfUser() async {
    final typeOfUser = selectedTypeOfUser;
    if (typeOfUser == null) {
      throw const NoTypeOfUserSelectedException();
    }

    if (typeOfUser == initialTypeOfUser) {
      throw const TypeUserOfUserHasNotChangedException();
    }

    try {
      state = const ChangeTypeOfUserLoading();
      notifyListeners();

      await service.changeTypeOfUser(typeOfUser);

      analytics.logChangedOrder(from: initialTypeOfUser, to: typeOfUser);
      initialTypeOfUser = typeOfUser;
    } on FirebaseFunctionsException catch (e) {
      _parseException(e);
    } catch (e) {
      throw ChangeTypeOfUserUnknownException(e);
    } finally {
      state = const ChangeTypeOfUserInitial();
      notifyListeners();
    }
  }

  void _parseException(FirebaseFunctionsException e) {
    final unknownErrorMessage = '[${e.plugin}/${e.code}] ${e.message}';
    if (e.code != 'failed-precondition') {
      throw ChangeTypeOfUserUnknownException(unknownErrorMessage);
    }

    try {
      final json = jsonDecode(e.message!);
      if (json['errorId'] == 'typeofuser-change-limit-reached') {
        final blockedUntil = DateTime.parse(json['blockedUntil']);
        throw ChangedTypeOfUserTooOftenException(blockedUntil: blockedUntil);
      } else {
        throw ChangeTypeOfUserUnknownException(unknownErrorMessage);
      }
    } catch (e) {
      if (e is ChangedTypeOfUserTooOftenException) rethrow;
      throw ChangeTypeOfUserUnknownException(unknownErrorMessage);
    }
  }

  void setSelectedTypeOfUser(TypeOfUser typeOfUser) {
    selectedTypeOfUser = typeOfUser;
    notifyListeners();
  }

  @override
  void dispose() {
    _typeOfUserSubscription?.cancel();
    super.dispose();
  }
}

sealed class ChangeTypeOfUserState {
  const ChangeTypeOfUserState();
}

class ChangeTypeOfUserInitial extends ChangeTypeOfUserState {
  const ChangeTypeOfUserInitial();
}

class ChangeTypeOfUserLoading extends ChangeTypeOfUserState {
  const ChangeTypeOfUserLoading();
}

sealed class ChangeTypeOfUserFailed {
  const ChangeTypeOfUserFailed();
}

class NoTypeOfUserSelectedException extends ChangeTypeOfUserFailed {
  const NoTypeOfUserSelectedException();
}

class TypeUserOfUserHasNotChangedException extends ChangeTypeOfUserFailed {
  const TypeUserOfUserHasNotChangedException();
}

class ChangedTypeOfUserTooOftenException extends ChangeTypeOfUserFailed {
  final DateTime blockedUntil;

  const ChangedTypeOfUserTooOftenException({required this.blockedUntil});
}

class ChangeTypeOfUserUnknownException extends ChangeTypeOfUserFailed {
  final Object? error;

  const ChangeTypeOfUserUnknownException(this.error);
}
