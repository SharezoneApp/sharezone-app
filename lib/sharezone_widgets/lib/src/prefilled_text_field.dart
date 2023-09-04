// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class PrefilledTextField extends StatefulWidget {
  const PrefilledTextField({
    Key? key,
    required this.prefilledText,
    this.autofocus = false,
    this.onEditingComplete,
    this.onChanged,
    this.textInputAction,
    this.decoration,
    this.maxLength,
    this.focusNode,
    this.maxLines = 1,
    this.style,
    this.cursorColor,
    this.keyboardType,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.autofillHints,
    this.autoSelectAllCharactersOnFirstBuild = false,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  /// The text that will be already filled into the underlying [TextField] on
  /// the first build.
  final String? prefilledText;

  /// Will autoselect the [prefilledText] on the first build if true.
  /// This helps the user to quickly delete the default [prefilledText] and
  /// write their own.
  /// The default is false;
  ///
  /// If [prefilledText] is true [autoselect] should also propably be true.
  /// It is currently unknown behavior what happens if
  /// [autoSelectAllCharactersOnFirstBuild] is true and [autoselect] is false.
  final bool autoSelectAllCharactersOnFirstBuild;

  /// Whether this text field should focus itself if nothing else is already focused.
  ///
  /// If true, the keyboard will open as soon as this text field obtains focus. Otherwise, the keyboard is only shown after the user taps the text field.
  ///
  /// Defaults to false. Cannot be null.
  ///
  /// (Copied from [TextField.autofocus])
  final bool autofocus;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the [FocusManager] to request the focus:
  ///
  /// ```dart
  /// FocusManager.instance.primaryFocus?.unfocus();
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field.  The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  ///
  /// (Copied from [TextField.focusNode])
  final FocusNode? focusNode;

  /// Called when the user submits editable content (e.g., user presses the "done"
  /// button on the keyboard).
  ///
  /// The default implementation of [onEditingComplete] executes 2 different
  /// behaviors based on the situation:
  ///
  ///  - When a completion action is pressed, such as "done", "go", "send", or
  ///    "search", the user's content is submitted to the [controller] and then
  ///    focus is given up.
  ///
  ///  - When a non-completion action is pressed, such as "next" or "previous",
  ///    the user's content is submitted to the [controller], but focus is not
  ///    given up because developers may want to immediately move focus to
  ///    another input widget within [onSubmitted].
  ///
  /// Providing [onEditingComplete] prevents the aforementioned default behavior.
  /// (Copied from  [TextField.onEditingComplete])
  final VoidCallback? onEditingComplete;

  /// Called when the user initiates a change to the TextField's
  /// value: when they have inserted or deleted text.
  ///
  /// This callback doesn't run when the TextField's text is changed
  /// programmatically, via the TextField's [mockController]. Typically it
  /// isn't necessary to be notified of such changes, since they're
  /// initiated by the app itself.
  ///
  /// To be notified of all changes to the TextField's text, cursor,
  /// and selection, one can add a listener to its [mockController] with
  /// [TextEditingController.addListener].
  ///
  /// {@tool dartpad --template=stateful_widget_material}
  ///
  /// This example shows how onChanged could be used to check the TextField's
  /// current value each time the user inserts or deletes a character.
  ///
  /// ```dart
  /// TextEditingController _controller;
  ///
  /// void initState() {
  ///   super.initState();
  ///   _controller = TextEditingController();
  /// }
  ///
  /// void dispose() {
  ///   _controller.dispose();
  ///   super.dispose();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       mainAxisAlignment: MainAxisAlignment.center,
  ///       children: <Widget>[
  ///         const Text('What number comes next in the sequence?'),
  ///         const Text('1, 1, 2, 3, 5, 8...?'),
  ///         TextField(
  ///           controller: _controller,
  ///           onChanged: (String value) async {
  ///             if (value != '13') {
  ///               return;
  ///             }
  ///             await showDialog<void>(
  ///               context: context,
  ///               builder: (BuildContext context) {
  ///                 return AlertDialog(
  ///                   title: const Text('Thats correct!'),
  ///                   content: Text ('13 is the right answer.'),
  ///                   actions: <Widget>[
  ///                     TextButton(
  ///                       onPressed: () { Navigator.pop(context); },
  ///                       child: const Text('OK'),
  ///                     ),
  ///                   ],
  ///                 );
  ///               },
  ///             );
  ///           },
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted], [onSelectionChanged]:
  ///    which are more specialized input change notifications.
  ///
  /// (Copied from [TextField.onChanged])
  final ValueChanged<String>? onChanged;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  ///
  /// (Copied from [TextField.textInputAction])
  final TextInputAction? textInputAction;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  ///
  /// (Copied from [TextField.decoration])
  final InputDecoration? decoration;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// If set, a character counter will be displayed below the
  /// field showing how many characters have been entered. If set to a number
  /// greater than 0, it will also display the maximum number allowed. If set
  /// to [TextField.noMaxLength] then only the current character count is displayed.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforced] is set to false. The text field
  /// enforces the length with a [LengthLimitingTextInputFormatter], which is
  /// evaluated after the supplied [inputFormatters], if any.
  ///
  /// This value must be either null, [TextField.noMaxLength], or greater than 0.
  /// If null (the default) then there is no limit to the number of characters
  /// that can be entered. If set to [TextField.noMaxLength], then no limit will
  /// be enforced, but the number of characters entered will still be displayed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// If [maxLengthEnforced] is set to false, then more than [maxLength]
  /// characters may be entered, but the error counter and divider will
  /// switch to the [decoration.errorStyle] when the limit is exceeded.
  ///
  /// ## Limitations
  ///
  /// The text field does not currently count Unicode grapheme clusters (i.e.
  /// characters visible to the user), it counts Unicode scalar values, which
  /// leaves out a number of useful possible characters (like many emoji and
  /// composed characters), so this will be inaccurate in the presence of those
  /// characters. If you expect to encounter these kinds of characters, be
  /// generous in the maxLength used.
  ///
  /// For instance, the character "ö" can be represented as '\u{006F}\u{0308}',
  /// which is the letter "o" followed by a composed diaeresis "¨", or it can
  /// be represented as '\u{00F6}', which is the Unicode scalar value "LATIN
  /// SMALL LETTER O WITH DIAERESIS". In the first case, the text field will
  /// count two characters, and the second case will be counted as one
  /// character, even though the user can see no difference in the input.
  ///
  /// Similarly, some emoji are represented by multiple scalar values. The
  /// Unicode "THUMBS UP SIGN + MEDIUM SKIN TONE MODIFIER", "👍🏽", should be
  /// counted as a single character, but because it is a combination of two
  /// Unicode scalar values, '\u{1F44D}\u{1F3FD}', it is counted as two
  /// characters.
  ///
  /// See also:
  ///
  ///  * [LengthLimitingTextInputFormatter] for more information on how it
  ///    counts characters, and how it may differ from the intuitive meaning.
  ///
  /// (Copied from [TextField.maxLength])
  final int? maxLength;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  ///
  /// If this is 1 (the default), the text will not wrap, but will scroll
  /// horizontally instead.
  ///
  /// If this is null, there is no limit to the number of lines, and the text
  /// container will start with enough vertical space for one line and
  /// automatically grow to accommodate additional lines as they are entered.
  ///
  /// If this is not null, the value must be greater than zero, and it will lock
  /// the input to the given number of lines and take up enough horizontal space
  /// to accommodate that number of lines. Setting [minLines] as well allows the
  /// input to grow between the indicated range.
  ///
  /// The full set of behaviors possible with [minLines] and [maxLines] are as
  /// follows. These examples apply equally to `TextField`, `TextFormField`, and
  /// `EditableText`.
  ///
  /// Input that occupies a single line and scrolls horizontally as needed.
  /// ```dart
  /// TextField()
  /// ```
  ///
  /// Input whose height grows from one line up to as many lines as needed for
  /// the text that was entered. If a height limit is imposed by its parent, it
  /// will scroll vertically when its height reaches that limit.
  /// ```dart
  /// TextField(maxLines: null)
  /// ```
  ///
  /// The input's height is large enough for the given number of lines. If
  /// additional lines are entered the input scrolls vertically.
  /// ```dart
  /// TextField(maxLines: 2)
  /// ```
  ///
  /// Input whose height grows with content between a min and max. An infinite
  /// max is possible with `maxLines: null`.
  /// ```dart
  /// TextField(minLines: 2, maxLines: 4)
  /// ```
  ///
  /// (Copied from [TextField.maxLines])
  final int? maxLines;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  ///
  /// (Copied from [TextField.style])
  final TextStyle? style;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in
  /// the field.
  ///
  /// If this is null it will default to the ambient
  /// [TextSelectionThemeData.cursorColor]. If that is null, and the
  /// [ThemeData.platform] is [TargetPlatform.iOS] or [TargetPlatform.macOS]
  /// it will use [CupertinoThemeData.primaryColor]. Otherwise it will use
  /// the value of [ColorScheme.primary] of [ThemeData.colorScheme].
  final Color? cursorColor;

  /// The type of keyboard to use for editing the text.
  ///
  /// Defaults to [TextInputType.text] if [maxLines] is one and
  /// [TextInputType.multiline] otherwise.
  ///
  /// (Copied from [TextField.keyboardType])
  final TextInputType? keyboardType;

  /// Configures padding to edges surrounding a [Scrollable] when the Textfield scrolls into view.
  ///
  /// When this widget receives focus and is not completely visible (for example scrolled partially
  /// off the screen or overlapped by the keyboard)
  /// then it will attempt to make itself visible by scrolling a surrounding [Scrollable], if one is present.
  /// This value controls how far from the edges of a [Scrollable] the TextField will be positioned after the scroll.
  ///
  /// Defaults to EdgeInsets.all(20.0).
  ///
  /// (Copied from [TextField.scrollPadding])
  final EdgeInsets scrollPadding;

  /// A list of strings that helps the autofill service identify the type of this
  /// text input.
  ///
  /// When set to null or empty, the text input will not send any autofill related
  /// information to the platform. As a result, it will not participate in
  /// autofills triggered by a different [AutofillClient], even if they're in the
  /// same [AutofillScope]. Additionally, on Android and web, setting this to null
  /// or empty will disable autofill for this text field.
  ///
  /// The minimum platform SDK version that supports Autofill is API level 26
  /// for Android, and iOS 10.0 for iOS.
  ///
  /// ### iOS-specific Concerns:
  ///
  /// To provide the best user experience and ensure your app fully supports
  /// password autofill on iOS, follow these steps:
  ///
  /// * Set up your iOS app's
  ///   [associated domains](https://developer.apple.com/documentation/safariservices/supporting_associated_domains_in_your_app).
  /// * Some autofill hints only work with specific [keyboardType]s. For example,
  ///   [AutofillHints.name] requires [TextInputType.name] and [AutofillHints.email]
  ///   works only with [TextInputType.email]. Make sure the input field has a
  ///   compatible [keyboardType]. Empirically, [TextInputType.name] works well
  ///   with many autofill hints that are predefined on iOS.
  ///
  /// For the best results, hint strings need to be understood by the platform's
  /// autofill service. The common values of hint strings can be found in
  /// [AutofillHints], as well as their availability on different platforms.
  ///
  /// If an autofillable input field needs to use a custom hint that translates to
  /// different strings on different platforms, the easiest way to achieve that
  /// is to return different hint strings based on the value of
  /// [defaultTargetPlatform].
  ///
  /// Each hint in the list, if not ignored, will be translated to the platform's
  /// autofill hint type understood by its autofill services:
  ///
  /// * On iOS, only the first hint in the list is accounted for. The hint will
  ///   be translated to a
  ///   [UITextContentType](https://developer.apple.com/documentation/uikit/uitextcontenttype).
  ///
  /// * On Android, all hints in the list are translated to Android hint strings.
  ///
  /// * On web, only the first hint is accounted for and will be translated to
  ///   an "autocomplete" string.
  ///
  /// Providing an autofill hint that is predefined on the platform does not
  /// automatically grant the input field eligibility for autofill. Ultimately,
  /// it comes down to the autofill service currently in charge to determine
  /// whether an input field is suitable for autofill and what the autofill
  /// candidates are.
  ///
  /// See also:
  ///
  /// * [AutofillHints], a list of autofill hint strings that is predefined on at
  ///   least one platform.
  ///
  /// * [UITextContentType](https://developer.apple.com/documentation/uikit/uitextcontenttype),
  ///   the iOS equivalent.
  ///
  /// * Android [autofillHints](https://developer.android.com/reference/android/view/View#setAutofillHints(java.lang.String...)),
  ///   the Android equivalent.
  ///
  /// * The [autocomplete](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/autocomplete) attribute,
  ///   the web equivalent.
  ///
  /// (Copied from [TextField.autofillHints])
  final Iterable<String>? autofillHints;

  /// See [TextField.textCapitalization].
  final TextCapitalization textCapitalization;

  @override
  State createState() => _PrefilledTextFieldState();
}

class _PrefilledTextFieldState extends State<PrefilledTextField> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.prefilledText);
    if (widget.autoSelectAllCharactersOnFirstBuild) {
      controller!.selection =
          TextSelection(baseOffset: 0, extentOffset: controller!.text.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: widget.autofocus,
      onEditingComplete: widget.onEditingComplete,
      textInputAction: widget.textInputAction,
      decoration: widget.decoration,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      autofillHints: widget.autofillHints,
      focusNode: widget.focusNode,
      style: widget.style,
      keyboardType: widget.keyboardType,
      cursorColor: widget.cursorColor,
      scrollPadding: widget.scrollPadding,
      textCapitalization: widget.textCapitalization,
    );
  }
}
