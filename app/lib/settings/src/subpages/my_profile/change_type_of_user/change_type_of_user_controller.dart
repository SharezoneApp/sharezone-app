// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_analytics.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_repository.dart';
import 'package:user/user.dart';

class ChangeTypeOfUserController extends ChangeNotifier {
  final UserId userId;
  final ChangeTypeOfUserAnalytics analytics;
  final ChangeTypeOfUserRepository repository;
  StreamSubscription<TypeOfUser?>? _typeOfUserSubscription;

  late ChangeTypeOfUserState state;

  /// The initial type of user of the user before the change.
  TypeOfUser? initialTypeOfUser;

  /// The currently selected type of user.
  TypeOfUser? selectedTypeOfUser;

  ChangeTypeOfUserController({
    required this.userId,
    required this.analytics,
    required this.repository,
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
      await repository.changeTypeOfUser(typeOfUser);

      analytics.logChangedOrder(
        from: initialTypeOfUser,
        to: typeOfUser,
      );
      initialTypeOfUser = typeOfUser;
      state = const ChangedTypeOfUserSuccessfully();
    } on FirebaseFunctionsException catch (e) {
      throw ChangeTypeOfUserUnknownException(
          '[${e.plugin}/${e.code}] ${e.message}');
    } catch (e) {
      throw ChangeTypeOfUserUnknownException(e);
    } finally {
      notifyListeners();
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

class ChangedTypeOfUserSuccessfully extends ChangeTypeOfUserState {
  const ChangedTypeOfUserSuccessfully();
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

class ChangeTypeOfUserUnknownException extends ChangeTypeOfUserFailed {
  const ChangeTypeOfUserUnknownException(this.error);

  final Object? error;
}
