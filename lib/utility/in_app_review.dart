import 'package:in_app_review/in_app_review.dart';

Future<void> requestAppRating() async {
  final inAppReview = InAppReview.instance;

  try {
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    } else {
      await inAppReview.openStoreListing(appStoreId: '6756618013');
    }
  } catch (e) {
    await inAppReview.openStoreListing(appStoreId: '6756618013');
  }
}
