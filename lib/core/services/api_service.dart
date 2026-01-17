import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/api_model.dart';

class ApiService {
  static ApiService? _apiService;

  ApiService._();

  static ApiService? get instance {
    _apiService ??= ApiService._();
    return _apiService;
  }

  Dio dio = Dio();

  final supabase = Supabase.instance.client;

  Future<Either<String, T>> invokeEdgeFunction<T>({
    required String functionName,
    required Map<String, dynamic> body,
    required T Function(dynamic data) onSuccess,
    String? fallbackErrorMessage,
  }) async {
    try {
      final res = await supabase.functions.invoke(functionName, body: body);

      final ApiResponse apiResponse = ApiResponse();

      Logger().i("$functionName Response ${res.data}");
      Logger().d("🟢 Response runtimeType: ${res.data.runtimeType}");

      late final Map<String, dynamic> data;

      if (res.data is String) {
        data = jsonDecode(res.data as String) as Map<String, dynamic>;
      } else if (res.data is Map<String, dynamic>) {
        data = res.data;
      } else {
        return Left("Unexpected response format: ${res.data.runtimeType}");
      }

      if (res.status == 200 || res.status == 201) {
        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage = data['message'] ?? 'Request completed';
        apiResponse.responseBody = data['data'] ?? 'No Body';
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage = data['message'] ?? 'Error encountered';
        apiResponse.responseBody = data['data'] ?? 'No Body';
      }

      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");

      if (apiResponse.responseSuccessful != true) {
        return Left(
          apiResponse.responseMessage ??
              fallbackErrorMessage ??
              'Request failed',
        );
      }

      // Convert raw JSON to your type T
      return Right(onSuccess(data));
    } catch (e, s) {
      Logger().e(
        '🔥 Edge Function "$functionName" crashed',
        error: e,
        stackTrace: s,
      );

      return Left(
        _extractFunctionError(
          e,
          fallbackErrorMessage ?? 'Something went wrong',
        ),
      );
    }
  }

  String _extractFunctionError(Object e, String fallback) {
    if (e is FunctionException) {
      final details = e.details;

      if (details is Map<String, dynamic>) {
        return details['message'] ?? fallback;
      }

      if (details is String) {
        try {
          return jsonDecode(details)['message'] ?? fallback;
        } catch (_) {}
      }
    }

    return fallback;
  }

  Future<ApiResponse<T>> postRequestHandler<T>(
    String url,
    dynamic body, {
    T Function(dynamic)? transform,
    Options? options,
    String? accessToken,
    String? apiKey,
    bool interchange = false,
    CancelToken? cancelToken,
  }) async {
    transform ??= (dynamic r) => r.body as T;
    final ApiResponse<T> apiResponse = ApiResponse<T>();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'auth=$accessToken',
        'x-api-key': "$apiKey",
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.post(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        apiResponse.responseSuccessful = data['success'] ?? true;
        if (interchange) {
          apiResponse.responseMessage = 'Request completed';
          apiResponse.responseBody = transform(data['message']);
        } else {
          apiResponse.responseMessage = data['message'] ?? 'Request completed';
          apiResponse.responseBody = transform(data['data']);
        }
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage = data['message'] ?? 'Error encountered';
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse> postRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
    String? apiKey,
    CancelToken? cancelToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'auth=$accessToken',
        'x-api-key': "$apiKey",
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.post(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;
      final dynamic reqData = res.requestOptions.data;

      log("Responsesss body ${res.requestOptions.data}");

      if (reqData is Map) {
        log("Request Body is a Map with ${reqData.length} fields");

        reqData.forEach((key, value) {
          log("Field: $key | Value: $value | Type: ${value.runtimeType}");
        });
      } else {
        log("Request Body is NOT a Map. Type: ${reqData.runtimeType}");
      }

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage = data['message'] ?? 'Request completed';
        apiResponse.responseBody = data['data'] ?? 'No Body';
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage = data['message'] ?? 'Error encountered';
        apiResponse.responseBody = data['data'] ?? 'No Body';
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse<T>> getRequestHandler<T>(
    String url, {
    T Function(dynamic)? transform,
    Options? options,
    String? accessToken,
    String? apiKey,
    CancelToken? cancelToken,
  }) async {
    transform ??= (dynamic r) => r as T;
    final ApiResponse<T> apiResponse = ApiResponse<T>();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'auth=$accessToken',
        'x-api-key': "$apiKey",
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.get(
        "${dotenv.env["BASE_URL"]}$url",
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response $data");
      Logger().i("Response Status Code: ${res.statusCode}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage = data['message'] ?? 'Request completed';
        apiResponse.responseBody = transform(data['data']);
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage = data['message'] ?? 'Error encountered';
      }

      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse> patchRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
    String? apiKey,
    CancelToken? cancelToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'auth=$accessToken',
        'x-api-key': "$apiKey",
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.patch(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage = data['message'] ?? 'Request completed';
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage = (data['message'] ?? 'Error encountered');
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse> putRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
    String? apiKey,
    CancelToken? cancelToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'auth=$accessToken',
        'x-api-key': "$apiKey",
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.put(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage = data['message'] ?? 'Request completed';
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage = (data['message'] ?? 'Error encountered');
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse> deleteRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
    String? apiKey,
    CancelToken? cancelToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'auth=$accessToken',
        'x-api-key': "$apiKey",
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.delete(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      final dynamic data = res.data;

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        apiResponse.responseSuccessful = data['success'] ?? true;
        apiResponse.responseMessage = data['message'] ?? 'Request completed';
      } else {
        apiResponse.responseSuccessful = data['success'] ?? false;
        apiResponse.responseMessage = (data['message'] ?? 'Error encountered');
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;

      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // ✅ Handle normal JSON errors
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        // ✅ Handle HTML or text responses (like 502 Bad Gateway)
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable (502 Bad Gateway)';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger().i(
        "Socket Response Successful: ${apiResponse.responseSuccessful}",
      );
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }
}
