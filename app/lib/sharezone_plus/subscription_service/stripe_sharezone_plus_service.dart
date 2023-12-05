import 'package:cloud_functions/cloud_functions.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:dio/dio.dart';

// TODO: extra package? maybe later in a PR
class StripeSharezonePlusService {
  final FirebaseFunctions functions;
  final Dio dio;

  StripeSharezonePlusService({
    required this.functions,
    required this.dio,
  });

  Future<String> createCheckoutUrl({
    UserId? userId,
  }) async {
    const functionUrl = "TODO";
    final res = await dio.post<Map<String, dynamic>>(functionUrl, data: {
      'userId': userId,
    });

    // TODO: What's the best way to handle the errors?

    final String? url = (res.data ?? {})['url'];
    if (url == null) {
      throw Exception('Could not processed');
    }

    return url;
  }

  /// Returns an authenticated URL to the Stripe portal.
  ///
  /// This method requires an authenticated user. For unauthenticated users open
  /// the default Stripe portal URL.
  Future<String> getStripePortal({
    required UserId userId,
  }) async {
    // TODO: use 'createPortalLink' cloud function
  }
}
