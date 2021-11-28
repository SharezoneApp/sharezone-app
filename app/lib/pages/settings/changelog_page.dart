import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/pages/settings/changelog/change_view.dart';
import 'package:sharezone/pages/settings/changelog/changelog_bloc.dart';
import 'package:sharezone/pages/settings/changelog/changelog_gateway.dart';
import 'package:sharezone/pages/settings/changelog/changelog_page_view.dart';
import 'package:sharezone/pages/settings/changelog/list_with_bottom_threshold.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone/util/platform_information_manager/get_platform_information_retreiver.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/announcement_card.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';

class ChangelogPage extends StatelessWidget {
  static const String tag = "changelog-page";

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return BlocProvider<ChangelogBloc>(
      bloc: ChangelogBloc(ChangelogGateway(firestore: api.references.firestore),
          getPlatformInformationRetreiver()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text("Was ist neu?"), centerTitle: true),
          body: const _ChangeList(),
        );
      }),
    );
  }
}

class _ChangeList extends StatelessWidget {
  const _ChangeList();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChangelogBloc>(context);
    return StreamBuilder<ChangelogPageView>(
      initialData: const ChangelogPageView.placeholder(),
      stream: bloc.changes,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data.hasChanges)
          return const Center(child: AccentColorCircularProgressIndicator());

        final changeData = snapshot.data;
        final children = _convertViewsToVersionSectionsWithNoDeviderAtTheBottom(
            changeData.changes);

        return ListWithBottomThreshold(
          padding: const EdgeInsets.all(12),
          children: [
            if (!changeData.userHasNewestVersion)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: UpdatePromptCard(),
              ),
            ...children,
          ],
          loadingIndicator: changeData.allChangesLoaded
              ? Container()
              : const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Center(child: AccentColorCircularProgressIndicator()),
                ),
          thresholdHeight: 50,
          onThresholdExceeded: () => bloc.loadNext(),
        );
      },
    );
  }

  List<Widget> _convertViewsToVersionSectionsWithNoDeviderAtTheBottom(
      List<ChangeView> changes) {
    final versionSections = <Widget>[];
    final lastChange = changes.last;
    for (final change in changes) {
      versionSections.add(_VersionSection(
        change: change,
        showBottomDivider: change != lastChange,
        key: Key(change.version),
      ));
    }
    return versionSections;
  }
}

class _VersionSection extends StatelessWidget {
  const _VersionSection(
      {Key key, @required this.change, this.showBottomDivider = true})
      : super(key: key);

  final bool showBottomDivider;
  final ChangeView change;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: change.isNewerThanCurrentVersion ? 0.3 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(change.version, style: Theme.of(context).textTheme.headline5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              _ChangeParagraph(
                  list: change.newFeatures, title: "Neue Funktionen:"),
              _ChangeParagraph(
                  list: change.improvements, title: "Verbesserungen:"),
              _ChangeParagraph(list: change.fixes, title: "Fehlerbehebungen:"),
            ],
          ),
          if (showBottomDivider) const Divider(),
        ],
      ),
    );
  }
}

class _ChangeParagraph extends StatelessWidget {
  const _ChangeParagraph({Key key, this.list, this.title}) : super(key: key);

  final String title;
  final List<String> list;

  @override
  Widget build(BuildContext context) {
    if (list == null || list.isEmpty) return Container();
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list
                .map(
                  (text) => Padding(
                    padding: const EdgeInsets.only(bottom: 2.5),
                    child: Text(
                      text,
                      style: const TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          height: 16 / 15),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class UpdatePromptCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnouncementCard(
      key: ValueKey('UpdatePromptCard'),
      onTap: () => launchURL(getStoreLink()),
      title: "Neues Update verfügbar!",
      padding: const EdgeInsets.all(0),
      titleColor: Colors.white,
      color: const Color(0xFFF44336),
      content: Text(
        "Wir haben bemerkt, dass du eine veraltete Version der App installiert hast. Lade dir deswegen unbedingt jetzt die Version im ${ThemePlatform.isCupertino ? "AppStore" : "PlayStore"} herunter! 👍",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  String getStoreLink() {
    // Öffnet direkt den Mac AppStore (funktioniert nur auf macOS-Geräten)
    if (PlatformCheck.isMacOS) return 'https://sharezone.net/macos-direct';

    // Es sollte für iOS & Android NICHT https://sharezone.net/ios oder
    // https://sharezone.net/android verwendet werden, weil der Nutzer direkt
    // wieder in die App geleitet wird, wenn diese installiert ist. Der Nutzer
    // wird nur in den Store geleitet, wenn dieser die App nicht installiert hat.
    //
    // Der "onelink.to" leitet immer in den Store - egal, ob die App installiert
    // ist oder nicht.
    return "http://onelink.to/eqkmz5";
  }
}
