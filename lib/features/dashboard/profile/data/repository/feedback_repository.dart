import 'package:dartz/dartz.dart';

abstract class FeedbackRepository {
  Future<Either<String, void>> submitFeedback({
    required String title,
    required String message,
  });
}
