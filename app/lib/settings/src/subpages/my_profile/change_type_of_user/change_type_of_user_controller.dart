import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_analytics.dart';
import 'package:user/user.dart';

class ChangeTypeOfUserController extends ChangeNotifier {
  /// The user ID of the user whose type of user should be changed.
  final UserId userId;
  final ChangeTypeOfUserAnalytics analytics;
  StreamSubscription<TypeOfUser?>? _typeOfUserSubscription;

  late ChangeTypeOfUserState state;

  /// The initial type of user of the user before the change.
  TypeOfUser? initialTypeOfUser;

  /// The currently selected type of user.
  TypeOfUser? selectedTypeOfUser;

  ChangeTypeOfUserController({
    required this.userId,
    required this.analytics,
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
      state = const NoTypeOfUserSelectedException();
      notifyListeners();
      return;
    }

    if (typeOfUser == initialTypeOfUser) {
      state = const TypeUserOfUserHasNotChangedException();
      notifyListeners();
      return;
    }

    try {
      // Call backend...
      await Future.delayed(const Duration(seconds: 1));

      analytics.logChangedOrder(
        from: initialTypeOfUser,
        to: typeOfUser,
      );
      initialTypeOfUser = typeOfUser;
      state = const ChangedTypeOfUserSuccessfully();
    } catch (e) {
      state = ChangeTypeOfUserUnknownException(e);
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

sealed class ChangeTypeOfUserFailed extends ChangeTypeOfUserState {
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
