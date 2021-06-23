import 'package:authentification_base/authentification_gateways.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/account/account_page_bloc.dart';
import 'package:sharezone/util/api/user_api.dart';

class AccountPageBlocFactory extends BlocBase {
  final UserGateway _userGateway;

  AccountPageBlocFactory(this._userGateway);

  AccountPageBloc create(GlobalKey<ScaffoldState> scaffoldKey) {
    return AccountPageBloc(
      globalKey: scaffoldKey,
      linkProviderGateway: LinkProviderGateway(_userGateway),
      userGateway: _userGateway,
    );
  }

  @override
  void dispose() {}
}
