import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../../core/services/api_service.dart';
import 'feedback_repository.dart';

class FeedbackRepositoryImpl extends FeedbackRepository {
  Future<Either<String, void>> submitFeedback({
    required String title,
    required String message,
  }) async {
    return ApiService.instance!.invokeEdgeFunction<void>(
      functionName: 'submit-feedback',
      body: {'title': title, 'message': message},
      fallbackErrorMessage: "Failed to Send Feedback",
      onSuccess: (data) => "Successfully Sent Feedback",
    );
  }
}
