part of '../sign_up_page.dart';

class _PrivacyPolicy extends StatelessWidget {
  const _PrivacyPolicy({Key key}) : super(key: key);

  static const tag = 'onboarding-privacy-policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 300),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 20,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: <Widget>[
                    PlatformSvg.asset(
                      "assets/icons/paragraph.svg",
                      height: 120,
                    ),
                    const SizedBox(height: 10),
                    Text("Datenschutzerklärung",
                        style: TextStyle(fontSize: 26)),
                    const SizedBox(height: 24),
                    PrivacyPolicyContent()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: OnboardingNavigationBar(action: _AccepctButton()),
    );
  }
}

class _AccepctButton extends StatefulWidget {
  const _AccepctButton({Key key}) : super(key: key);

  @override
  __AccepctButtonState createState() => __AccepctButtonState();
}

class __AccepctButtonState extends State<_AccepctButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        onSurface: Theme.of(context).primaryColor,
      ),
      child: Stack(
        key: const ValueKey('SubmitButton'),
        children: [
          Text(
            "Akzeptieren".toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              color: isLoading ? Colors.transparent : Colors.white,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 275),
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.only(top: 2, left: 58),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Theme(
                        data: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white)),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
      onPressed: isLoading
          ? null
          : () async {
              final bloc = BlocProvider.of<RegistrationBloc>(context);
              try {
                setState(() => isLoading = true);
                await bloc.signUp();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              } catch (e, s) {
                setState(() => isLoading = false);
                showSnackSec(
                  text: handleErrorMessage(e.toString(), s),
                  context: context,
                );
              }
            },
    );
  }
}
