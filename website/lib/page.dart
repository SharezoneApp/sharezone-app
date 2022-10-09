import 'package:flutter/material.dart';
import 'package:sharezone_website/support_page.dart';
import 'package:sharezone_website/utils.dart';
import 'package:sharezone_website/widgets/column_spacing.dart';

import 'footer.dart';
import "package:build_context/build_context.dart";
import 'home/home_page.dart';
import 'widgets/max_width_constraint_box.dart';
import 'widgets/sharezone_logo.dart';
import 'widgets/transparent_button.dart';

class PageTemplate extends StatelessWidget {
  const PageTemplate({
    super.key,
    this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget>? children;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        drawer: isPhone(context)
            ? Drawer(
                child: ColumnSpacing(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text("Hauptseite"),
                      onTap: () =>
                          Navigator.popAndPushNamed(context, HomePage.tag),
                    ),
                    ListTile(
                      leading: const Icon(Icons.question_answer),
                      title: const Text("FAQ"),
                      onTap: () => launchURL("https://sharezone.net/faq"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text("Support"),
                      onTap: () =>
                          Navigator.pushNamed(context, SupportPage.tag),
                    ),
                  ],
                ),
              )
            : null,
        body: Scrollbar(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: false,
                backgroundColor: Colors.white,
                pinned: true,
                bottom: _AppBarTitle(),
              ),
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      ...children!,
                      const Footer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    // Disable selection to prevent showing a selection mouse pointer.
    return SelectionContainer.disabled(
      child: Align(
        alignment: Alignment.center,
        child: MaxWidthConstraintBox(
          maxWidth: maxWidthConstraint,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isPhone(context))
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => context.openDrawer(),
                    )
                  else
                    TransparentButton(
                      onTap: () =>
                          Navigator.popAndPushNamed(context, HomePage.tag),
                      child: const SharezoneLogo(
                        logoColor: LogoColor.blueShort,
                        height: 50,
                        width: 200,
                      ),
                    ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!isPhone(context)) ...[
                          TransparentButton(
                            child: const Text("Support"),
                            onTap: () =>
                                Navigator.pushNamed(context, SupportPage.tag),
                          ),
                          const SizedBox(width: 30),
                          TransparentButton.openLink(
                            link: "https://sharezone.net/faq",
                            child: const Text("FAQ"),
                          ),
                          const SizedBox(width: 30),
                        ],
                        _GoWebAppButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 30);
}

class _GoWebAppButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final borderRaius = BorderRadius.circular(50);
    return SizedBox(
      height: 65,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () => launchURL("https://web.sharezone.net"),
          borderRadius: borderRaius,
          child: Material(
            borderRadius: borderRaius,
            color: context.primaryColor,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Web-App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
