import 'package:in_app_review/in_app_review.dart';

Future<bool> requestAppRating() async {
  final InAppReview inAppReview = InAppReview.instance;

  // Check if the store review feature is available
  if (await inAppReview.isAvailable()) {
    await inAppReview.requestReview();
    return true; // user likely saw the prompt
  } else {
    return false; // store review not available
  }
}
