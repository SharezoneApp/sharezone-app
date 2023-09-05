class SharezonePlusPageView {
  final bool hasPlus;

  /// The price of the Sharezone Plus subscription including the currency
  /// symbol.
  final String price;

  const SharezonePlusPageView({
    required this.hasPlus,
    required this.price,
  });

  const SharezonePlusPageView.empty()
      : hasPlus = false,
        price = '';

  SharezonePlusPageView copyWith({
    bool? hasPlus,
    String? price,
  }) {
    return SharezonePlusPageView(
      hasPlus: hasPlus ?? this.hasPlus,
      price: price ?? this.price,
    );
  }
}
