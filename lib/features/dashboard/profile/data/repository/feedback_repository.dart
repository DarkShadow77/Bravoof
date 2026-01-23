import 'package:dartz/dartz.dart';

abstract class FeedbackRepository {
  Future<Either<String, void>> submitFeedback({
    required String userId,
    required String title,
    required String message,
  });
}
