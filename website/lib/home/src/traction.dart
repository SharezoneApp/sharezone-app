// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:number_slide_animation/number_slide_animation.dart';
import 'package:sharezone_website/widgets/column_spacing.dart';
import 'package:sharezone_website/widgets/transparent_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../home_page.dart';

class Traction extends StatelessWidget {
  const Traction({super.key});

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
          // Disable selection to prevent showing a selection mouse pointer.
          child: SelectionContainer.disabled(
            child: MaxWidthConstraintBox(
              maxWidth: 700,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                child: isPhone(context)
                    ? ColumnSpacing(
                        spacing: 24,
                        children: [
                          _UserCounter(),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _AppStoreRating(),
                              SizedBox(width: 48),
                              _PlayStoreRating(),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const _AppStoreRating(),
                          _UserCounter(),
                          const _PlayStoreRating(),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayStoreRating extends StatelessWidget {
  const _PlayStoreRating();

  @override
  Widget build(BuildContext context) {
    return const _StoreReview(
      rating: 4.8,
      storeName: "PlayStore",
      storeLink: "https://sharezone.net/android",
    );
  }
}

class _AppStoreRating extends StatelessWidget {
  const _AppStoreRating();

  @override
  Widget build(BuildContext context) {
    return const _StoreReview(
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
  static const fallbackUserCounter = "430000";

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
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
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
    } catch (e, s) {
      log('$e', stackTrace: s);
      return fallbackUserCounter;
    }
  }
}

class _StoreReview extends StatelessWidget {
  const _StoreReview({
    this.storeName,
    this.rating,
    this.storeLink,
  });

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
            style: const TextStyle(
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
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                )
            ],
          ),
          const SizedBox(height: 4),
          Text(
            storeName!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
