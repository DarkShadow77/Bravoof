import 'package:in_app_review/in_app_review.dart';

Future<void> requestAppRating() async {
  final inAppReview = InAppReview.instance;

  if (await inAppReview.isAvailable()) {
    await inAppReview.requestReview();

    // Optional fallback
    Future.delayed(const Duration(seconds: 1), () {
      inAppReview.openStoreListing();
    });
  } else {
    await inAppReview.openStoreListing();
  }
}
