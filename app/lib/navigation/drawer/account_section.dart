// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'drawer.dart';

class _AccountSection extends StatelessWidget {
  const _AccountSection({@required this.isDesktopModus});

  final bool isDesktopModus;

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return StreamBuilder<AppUser>(
      key: ValueKey('account-drawer-tile-E2E'),
      initialData: api.user.data,
      stream: api.user.userStream,
      builder: (context, snapshot) {
        final user = snapshot.data ?? AppUser.create(id: "Id");
        return Tooltip(
          message: 'Profile',
          child: InkWell(
            onTap: () {
              final drawerController =
                  BlocProvider.of<SharezoneDrawerController>(context);
              if (!drawerController.isDesktopModus) Navigator.pop(context);

              final navigationBloc = BlocProvider.of<NavigationBloc>(context);
              navigationBloc.navigateTo(NavigationItem.accountPage);

              _logAccountSectionClick(context);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 12, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (isDesktopModus) ...[
                    Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                _ProfileAvatar(
                                    abbrevation: user.abbreviation ?? ''),
                                const SizedBox(width: 16),
                                _NameAndEMailColumn(name: user.name ?? ''),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ] else ...[
                    _ProfileAvatar(abbrevation: user.abbreviation ?? ''),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _NameAndEMailColumn(name: user.name ?? ''),
                        const _ProfileArrow(),
                      ],
                    )
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _logAccountSectionClick(BuildContext context) {
    final _analytics = BlocProvider.of<NavigationAnalytics>(context);
    _analytics.logDrawerEvent(NavigationItem.accountPage);
  }
}

class _NameAndEMailColumn extends StatelessWidget {
  final String name;

  const _NameAndEMailColumn({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _Name(name: name),
        const _Email(),
      ],
    );
  }
}

class _Name extends StatelessWidget {
  const _Name({Key key, @required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(name,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400));
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<auth.AuthUser>(context);
    if (user == null) return Container();

    final email = user.email;
    // We also count "-" as empty because this is used by Firebase Auth when the
    // user signed in with Google or Apple but has no email address.
    final isEmailEmpty = user.email == null || email.isEmpty || email == "-";
    if (isEmailEmpty) return Container();
    return Text(
      email,
      style: TextStyle(color: Colors.grey, fontSize: 12),
    );
  }
}

class _ProfileArrow extends StatelessWidget {
  const _ProfileArrow();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(Icons.keyboard_arrow_right, color: Colors.grey[700]),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
      width: 35,
      height: 35,
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({Key key, @required this.abbrevation}) : super(key: key);

  final String abbrevation;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      child: Text(abbrevation, style: const TextStyle(fontSize: 18)),
      radius: 27.5,
    );
  }
}
