import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';

const List<String> localPictures = [
  "assets/wallpaper/blackboard/make-photo.png",
  "assets/wallpaper/blackboard/upload.png",
  "assets/wallpaper/blackboard/sport.png",
  "assets/wallpaper/blackboard/students.png",
  "assets/wallpaper/blackboard/meeting.png",
  "assets/wallpaper/blackboard/soccer.png",
  "assets/wallpaper/blackboard/track.png",
  "assets/wallpaper/blackboard/theater.png",
  "assets/wallpaper/blackboard/ice-hockey.png",
  "assets/wallpaper/blackboard/museum.png",
  "assets/wallpaper/blackboard/climbing.png",
];

class BlackboardDialogChoosePicture extends StatelessWidget {
  static const tag = "blackboard-dialog-choose-picture";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Titelbild auswählen")),
      body: _PictureGrid(),
    );
  }
}

class _PictureGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return GridView.count(
      crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.all(10),
      childAspectRatio: (orientation == Orientation.portrait) ? 1.15 : 1.3,
      children:
          localPictures.map((String path) => _PictureBox(path: path)).toList(),
    );
  }
}

class _PictureBox extends StatelessWidget {
  const _PictureBox({Key key, this.path}) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 3;
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return InkWell(
      onTap: () {
        if (path != "assets/wallpaper/blackboard/make-photo.png" &&
            path != "assets/wallpaper/blackboard/upload.png") {
          analytics
              .log(NamedAnalyticsEvent(name: "blackboard_upload_preset_photo"));
          Navigator.pop(context, path);
        } else {
          analytics
              .log(NamedAnalyticsEvent(name: "blackboard_upload_own_photo"));
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: const Text(
                  "Bisher können keine eigenen Bilder aufgenommen/hochgeladen werden 😔\n\nDiese Funktion wird sehr bald verfügbar sein!"),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          );
        }
      },
      child: Image.asset(
        path,
        height: size,
        width: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
