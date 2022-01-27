// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final streamingCache = FlutterStreamingKeyValueStore(
        BlocProvider.of<SharezoneContext>(context).streamingSharedPreferences);
    final cache = ProfilePageHintCache(api.user.isAnonymous(), streamingCache);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        key: ValueKey('my-profile-button-E2E'),
        tooltip: 'Mein Profil',
        onPressed: () {
          cache.setProfilePageHintAsClicked();
          final navigation = BlocProvider.of<NavigationBloc>(context);
          navigation.navigateTo(NavigationItem.accountPage);
        },
        icon: StreamBuilder<String>(
          stream: api.user.userStream.map((user) => user.abbreviation),
          builder: (context, snapshot) {
            final abbreviation = snapshot.data ?? "";
            return Stack(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    abbreviation,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                _AnonymousUserNote(cache: cache),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AnonymousUserNote extends StatelessWidget {
  const _AnonymousUserNote({Key key, @required this.cache}) : super(key: key);

  final ProfilePageHintCache cache;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: cache.showProfilePageHint,
      builder: (context, snapshot) {
        final showProfilePageHint = snapshot.data ?? false;
        if (showProfilePageHint)
          return Positioned(
            top: 1,
            right: 1,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          );
        return Container();
      },
    );
  }
}
