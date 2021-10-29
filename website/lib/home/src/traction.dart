import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_website/widgets/column_spacing.dart';
import 'package:sharezone_website/widgets/max_width_constraint_box.dart';
import 'package:sharezone_website/widgets/transparent_button.dart';
import 'package:number_slide_animation/number_slide_animation.dart';

import '../home_page.dart';

class Traction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MaxWidthConstraintBox(
        maxWidth: 1000,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: MaxWidthConstraintBox(
            maxWidth: 700,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              child: isPhone(context)
                  ? ColumnSpacing(
                      spacing: 24,
                      children: [
                        _UserCounter(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _AppStoreRating(),
                            const SizedBox(width: 48),
                            _PlayStoreRating(),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _AppStoreRating(),
                        _UserCounter(),
                        _PlayStoreRating(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayStoreRating extends StatelessWidget {
  const _PlayStoreRating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StoreReview(
      rating: 4.2,
      storeName: "PlayStore",
      storeLink: "https://sharezone.net/android",
    );
  }
}

class _AppStoreRating extends StatelessWidget {
  const _AppStoreRating({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StoreReview(
      rating: 4.7,
      storeName: "AppStore",
      storeLink: "https://sharezone.net/ios",
    );
  }
}

class _UserCounter extends StatefulWidget {
  @override
  __UserCounterState createState() => __UserCounterState();
}

class __UserCounterState extends State<_UserCounter> {
  // Dies ist der Fallback-Wert, falls der Wert von der Cloud-Function noch
  // nicht vorhanden ist oder der Wert nicht geladen werden konnte.
  static const fallbackUserCounter = "191531";

  String? userCounter = fallbackUserCounter;

  @override
  void initState() {
    super.initState();
    getUserCounter().then((counter) => setState(() => userCounter = counter));
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'user counter',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            key: ValueKey(userCounter),
            child: NumberSlideAnimation(
              number: userCounter!,
              duration: const Duration(seconds: 4),
              curve: Curves.easeOut,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 3),
          SelectableText(
            "registrierte Nutzer",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> getUserCounter() async {
    try {
      const link =
          "https://europe-west1-sharezone-c2bd8.cloudfunctions.net/userCounter";
      final response = await Dio().get(link);
      return response.data;
    } catch (e) {
      print(e);
      return fallbackUserCounter;
    }
  }
}

class _StoreReview extends StatelessWidget {
  const _StoreReview({
    Key? key,
    this.storeName,
    this.rating,
    this.storeLink,
  }) : super(key: key);

  final String? storeName;
  final double? rating;
  final String? storeLink;

  @override
  Widget build(BuildContext context) {
    return TransparentButton.openLink(
      link: storeLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 5; i++)
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                )
            ],
          ),
          const SizedBox(height: 4),
          Text(
            storeName!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
