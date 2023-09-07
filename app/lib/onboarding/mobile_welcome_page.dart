import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class MobileWelcomePage extends StatelessWidget {
  const MobileWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7EBED),
      body: Stack(
        children: const [
          _BackgroundImage(),
          _Bottom(),
        ],
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Text(
            'Willkommen bei Sharezone',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 20),
          Text(
            'Die Plattform für die gemeinsame Nutzung von Gegenständen.',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text('Jetzt loslegen'),
          ),
          const SizedBox(height: 20),
          CustomCard(child: Text(''))
        ],
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/welcome-page-background.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.9,
            ),
          ),
          Positioned.fill(
            child: Container(
              // Add white (bottom) to transparent (top) gradient that is placed at
              // the bottom of the screen. It should have a height of 30% of the
              // screen height.
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: [0.15, 0.5],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
