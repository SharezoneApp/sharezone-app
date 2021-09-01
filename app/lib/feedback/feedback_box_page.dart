import 'package:flutter/material.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/feedback/src/bloc/feedback_bloc.dart';
import 'package:sharezone/feedback/src/widgets/thank_you_bottom_sheet.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone/feedback/src/cache/cooldown_exception.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';

const double _padding = 12.0;

class FeedbackPage extends StatelessWidget {
  static const tag = "feedback-box-page";

  const FeedbackPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => popToOverview(context),
      child: const SharezoneMainScaffold(
        appBarConfiguration: AppBarConfiguration(title: "Feedback-Box"),
        navigationItem: NavigationItem.feedbackBox,
        body: FeedbackPageBody(),
      ),
    );
  }
}

@visibleForTesting
class FeedbackPageBody extends StatelessWidget {
  const FeedbackPageBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: MaxWidthConstraintBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Description(),
              Divider(),
              if (!PlatformCheck.isWeb) _GenerelRating(),
              SizedBox(height: 12),
              _LikeField(),
              _DislikeField(),
              _MissingField(),
              _HeardFromField(),
              _AnonymousCheckbox(),
              FeedbackPageSubmitButton(key: const Key("submitButton")),
              SizedBox(height: _padding)
            ],
          ),
        ),
      ),
    );
  }
}

// class _FeedbackBoxWallpaper extends StatelessWidget {
//   const _FeedbackBoxWallpaper({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(maxHeight: 400),
//       child: Image.asset(
//         "assets/wallpaper/feedback-box.png",
//         width: MediaQuery.of(context).size.width,
//         fit: BoxFit.fitWidth,
//       ),
//     );
//   }
// }

class _AnonymousCheckbox extends StatelessWidget {
  const _AnonymousCheckbox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FeedbackBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.isAnonymous,
      builder: (context, isAnonymousSnapshot) {
        final isAnonymous = isAnonymousSnapshot?.data ?? false;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Divider(),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => bloc.changeIsAnonymous(!isAnonymous),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.security,
                        color: isDarkThemeEnabled(context)
                            ? Colors.grey
                            : Colors.grey[600]),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        "Ich möchte mein Feedback anonym abschicken",
                        style: TextStyle(
                            color: isDarkThemeEnabled(context)
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 16),
                      ),
                    ),
                    Checkbox(
                      value: isAnonymous,
                      onChanged: bloc.changeIsAnonymous,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: isAnonymous
                  ? Text(
                      "Bitte beachte, dass wenn du einen Fehler bei dir melden möchtest, wir dir nicht weiterhelfen können, wenn du das Feedback anoynm abschickst.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _FeedbackTextField(
                        labelText: "Kontaktdaten für Rückfragen",
                        icon: const Icon(Icons.question_answer),
                        onChanged: bloc.changeContactOptions,
                        stream: bloc.contactOptions,
                      ),
                    ),
            ),
            SizedBox(height: isAnonymous ? 8 : 16),
          ],
        );
      },
    );
  }
}

class _HeardFromField extends StatelessWidget {
  const _HeardFromField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FeedbackBloc>(context);
    return _FeedbackTextField(
      icon: const Icon(Icons.search),
      labelText: "Wie hast Du von Sharezone erfahren?",
      onChanged: bloc.changeHeardFrom,
      stream: bloc.heardFrom,
    );
  }
}

class _MissingField extends StatelessWidget {
  const _MissingField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FeedbackBloc>(context);
    return _FeedbackTextField(
      icon: const Icon(Icons.comment),
      labelText: "Was fehlt Dir noch?",
      onChanged: bloc.changeMissing,
      stream: bloc.missing,
    );
  }
}

class _DislikeField extends StatelessWidget {
  const _DislikeField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FeedbackBloc>(context);
    return _FeedbackTextField(
      icon: const Icon(Icons.thumb_down),
      labelText: "Was gefällt Dir nicht?",
      onChanged: bloc.changeDislike,
      stream: bloc.dislike,
    );
  }
}

class _GenerelRating extends StatelessWidget {
  const _GenerelRating({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FeedbackBloc>(context);
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 6),
          const Text(
            "Allgemeine Bewertung:",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          FutureBuilder<double>(
            future: bloc.raiting.first,
            builder: (context, snapshot) {
              final initalRaiting = snapshot.data ?? 0;
              return RatingBar(
                initialRating: initalRaiting,
                itemCount: 5,
                allowHalfRating: true,
                glow: false,
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: Colors.amber),
                  half: const Icon(Icons.star_half, color: Colors.amber),
                  empty: const Icon(Icons.star_outline, color: Colors.amber),
                ),
                onRatingUpdate: bloc.changeRating,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LikeField extends StatelessWidget {
  const _LikeField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FeedbackBloc>(context);
    return _FeedbackTextField(
      icon: const Icon(Icons.thumb_up),
      labelText: "Was gefällt Dir am besten?",
      onChanged: bloc.changeLike,
      stream: bloc.like,
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "Warum wir Dein Feedback brauchen:",
            style: TextStyle(fontSize: 16),
          ),
          Text(
              "Wir möchten die beste App zum Organisieren des Schulalltags entwickeln! Damit wir das schaffen, brauchen wir Dich! Fülle einfach das Formular aus und schick es ab."
              "\n\nAlle Fragen sind selbstverständlich freiwillig.",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class FeedbackPageSubmitButton extends StatefulWidget {
  const FeedbackPageSubmitButton({Key key}) : super(key: key);

  @override
  _FeedbackPageSubmitButtonState createState() =>
      _FeedbackPageSubmitButtonState();
}

class _FeedbackPageSubmitButtonState extends State<FeedbackPageSubmitButton> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FeedbackBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.send, color: Colors.white),
            SizedBox(width: 8),
            Text("ABSCHICKEN", style: TextStyle(color: Colors.white)),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.lightBlueAccent,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () async {
          try {
            await bloc.submit();
            showThankYouBottomSheet(context);
          } on CooldownException catch (e) {
            showSnackSec(
                context: context,
                text:
                    "Error! Dein Cooldown(${e.cooldown}) ist noch nicht abgelaufen.");
          } on EmptyFeedbackException {
            showSnackSec(
                context: context,
                text: "Du musst auch schon was reinschreiben 😉");
          } on Exception catch (e, s) {
            print("Exception when submitting Feedback: $e, $s");
            showSnackSec(
                context: context,
                text:
                    "Error! Versuche es nochmal oder schicke uns dein Feedback gerne auch per Email! :)");
          }
        },
      ),
    );
  }
}

class _FeedbackTextField extends StatelessWidget {
  const _FeedbackTextField({
    Key key,
    @required this.stream,
    this.labelText,
    this.onChanged,
    this.icon,
  }) : super(key: key);

  final String labelText;
  final ValueChanged<String> onChanged;
  final ValueStream<String> stream;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(_padding, 0, _padding, _padding),
          child: PrefilledTextField(
            prefilledText: stream.valueOrNull,
            decoration: InputDecoration(
              icon: icon,
              labelText: labelText,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.newline,
            maxLines: null,
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}
