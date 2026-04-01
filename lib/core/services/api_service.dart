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
    Map<String, dynamic>? queryParams,
    required T Function(dynamic data) onSuccess,
    String? fallbackErrorMessage,
    bool requiresAuth = true,
  }) async {
    try {
      // IMPORTANT: Check if user is authenticated
      Session? session = supabase.auth.currentSession;

      // If session exists but token is expired or about to expire, refresh it
      if (session != null) {
        final expiresAt = session.expiresAt;
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final isExpired =
            expiresAt != null && expiresAt <= now + 60; // 60s buffer

        if (isExpired) {
          Logger().i('Token expired or expiring soon, refreshing...');
          final refreshed = await supabase.auth.refreshSession();
          session = refreshed.session;
        }
      }

      // Only enforce auth check for protected functions
      if (requiresAuth && session == null) {
        Logger().e('No active session when calling $functionName');
        return const Left('Authentication required. Please login again.');
      }

      // Use session token if available, otherwise use anon key
      final authToken = session?.accessToken ?? dotenv.env['ANON_KEY'] ?? '';

      Logger().i("Calling edge function: $functionName");
      Logger().d("Request body: $body");
      Logger().d("Session exists: $authToken");

      // The Supabase client automatically includes auth headers
      final res = await supabase.functions.invoke(
        functionName,
        body: body,
        queryParameters: queryParams,
        headers: {'Authorization': 'Bearer ${authToken}'},
      );

      final ApiResponse apiResponse = ApiResponse();

      Logger().i("$functionName Response ${res.data}");
      Logger().d("🟢 Response runtimeType: ${res.data.runtimeType}");
      Logger().d("🟢 Response status: ${res.status}");

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
    } on SocketException catch (e) {
      // No internet connection
      Logger().e('🌐 No internet connection for "$functionName"', error: e);
      return const Left(
        'No internet connection. Please check your network and try again.',
      );
    } on HttpException catch (e) {
      // Server unreachable
      Logger().e('🌐 HTTP error for "$functionName"', error: e);
      return const Left('Unable to reach the server. Please try again later.');
    } on AuthException catch (e) {
      Logger().e('🔥 Auth error in "$functionName"', error: e);
      return Left('Authentication error: ${e.message}');
    } on FunctionException catch (e) {
      // Check if it's actually a network issue disguised as a function exception
      final details = e.details;
      final message = details is Map ? details['message'] as String? : null;

      if (message?.toLowerCase().contains('network') == true) {
        Logger().e(
          '🌐 Network-related function exception in "$functionName"',
          error: e,
        );
        return const Left(
          'No internet connection. Please check your network and try again.',
        );
      }

      Logger().e('🔥 Function exception in "$functionName"', error: e);
      return Left(
        _extractFunctionError(e, fallbackErrorMessage ?? 'Request failed'),
      );
    } catch (e, s) {
      // Catch SocketException that might be wrapped
      if (e.toString().toLowerCase().contains('socketexception') ||
          e.toString().toLowerCase().contains('network is unreachable') ||
          e.toString().toLowerCase().contains('connection refused') ||
          e.toString().toLowerCase().contains('no route to host')) {
        Logger().e('🌐 Network error for "$functionName"', error: e);
        return const Left(
          'No internet connection. Please check your network and try again.',
        );
      }

      Logger().e(
        '🔥 Edge Function "$functionName" crashed',
        error: e,
        stackTrace: s,
      );
      return Left(fallbackErrorMessage ?? 'Something went wrong');
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
      Logger().e("Dio Response Full Message: ${e.response?.data}", error: e);
      apiResponse.responseSuccessful = false;

      // ─── Check for network/connectivity errors first ───────────
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 Network error: ${e.type}');
        return apiResponse;
      }

      // ─── Check inner error for SocketException ─────────────────
      if (e.error is SocketException) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 SocketException wrapped in DioException');
        return apiResponse;
      }

      // ─── Parse response body for error message ─────────────────
      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable. Please try again later.';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (e) {
      Logger().e('🌐 SocketException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'No internet connection. Please check your network and try again.';
    } on HttpException catch (e) {
      Logger().e('🌐 HttpException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'Unable to reach the server. Please try again later.';
    } catch (e, s) {
      Logger().e('🔥 Unexpected error in request', error: e, stackTrace: s);
      apiResponse.responseSuccessful = false;

      if (e.toString().toLowerCase().contains('socketexception') ||
          e.toString().toLowerCase().contains('network is unreachable') ||
          e.toString().toLowerCase().contains('connection refused') ||
          e.toString().toLowerCase().contains('no route to host')) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
      } else {
        apiResponse.responseMessage =
            'An unexpected error occurred. Please try again.';
      }
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

    customUrl = false,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    final fullUrl = customUrl ? url : "${dotenv.env["BASE_URL"]}$url";

    Logger().i("Request Path $fullUrl");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        if (accessToken != null && accessToken.isNotEmpty)
          'Authorization': 'Bearer $accessToken',
        if (accessToken != null && accessToken.isNotEmpty)
          'Cookie': 'auth=$accessToken',
        'x-api-key': "$apiKey",
        'apikey': "$apiKey",
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      Logger().i("Authorization: $accessToken");

      final res = await dio.post(
        fullUrl,
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
      Logger().e("Dio Response Full Message: ${e.response?.data}", error: e);
      apiResponse.responseSuccessful = false;

      // ─── Check for network/connectivity errors first ───────────
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 Network error: ${e.type}');
        return apiResponse;
      }

      // ─── Check inner error for SocketException ─────────────────
      if (e.error is SocketException) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 SocketException wrapped in DioException');
        return apiResponse;
      }

      // ─── Parse response body for error message ─────────────────
      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable. Please try again later.';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (e) {
      Logger().e('🌐 SocketException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'No internet connection. Please check your network and try again.';
    } on HttpException catch (e) {
      Logger().e('🌐 HttpException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'Unable to reach the server. Please try again later.';
    } catch (e, s) {
      Logger().e('🔥 Unexpected error in request', error: e, stackTrace: s);
      apiResponse.responseSuccessful = false;

      if (e.toString().toLowerCase().contains('socketexception') ||
          e.toString().toLowerCase().contains('network is unreachable') ||
          e.toString().toLowerCase().contains('connection refused') ||
          e.toString().toLowerCase().contains('no route to host')) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
      } else {
        apiResponse.responseMessage =
            'An unexpected error occurred. Please try again.';
      }
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
      Logger().e("Dio Response Full Message: ${e.response?.data}", error: e);
      apiResponse.responseSuccessful = false;

      // ─── Check for network/connectivity errors first ───────────
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 Network error: ${e.type}');
        return apiResponse;
      }

      // ─── Check inner error for SocketException ─────────────────
      if (e.error is SocketException) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 SocketException wrapped in DioException');
        return apiResponse;
      }

      // ─── Parse response body for error message ─────────────────
      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable. Please try again later.';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (e) {
      Logger().e('🌐 SocketException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'No internet connection. Please check your network and try again.';
    } on HttpException catch (e) {
      Logger().e('🌐 HttpException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'Unable to reach the server. Please try again later.';
    } catch (e, s) {
      Logger().e('🔥 Unexpected error in request', error: e, stackTrace: s);
      apiResponse.responseSuccessful = false;

      if (e.toString().toLowerCase().contains('socketexception') ||
          e.toString().toLowerCase().contains('network is unreachable') ||
          e.toString().toLowerCase().contains('connection refused') ||
          e.toString().toLowerCase().contains('no route to host')) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
      } else {
        apiResponse.responseMessage =
            'An unexpected error occurred. Please try again.';
      }
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
      Logger().e("Dio Response Full Message: ${e.response?.data}", error: e);
      apiResponse.responseSuccessful = false;

      // ─── Check for network/connectivity errors first ───────────
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 Network error: ${e.type}');
        return apiResponse;
      }

      // ─── Check inner error for SocketException ─────────────────
      if (e.error is SocketException) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 SocketException wrapped in DioException');
        return apiResponse;
      }

      // ─── Parse response body for error message ─────────────────
      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable. Please try again later.';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (e) {
      Logger().e('🌐 SocketException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'No internet connection. Please check your network and try again.';
    } on HttpException catch (e) {
      Logger().e('🌐 HttpException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'Unable to reach the server. Please try again later.';
    } catch (e, s) {
      Logger().e('🔥 Unexpected error in request', error: e, stackTrace: s);
      apiResponse.responseSuccessful = false;

      if (e.toString().toLowerCase().contains('socketexception') ||
          e.toString().toLowerCase().contains('network is unreachable') ||
          e.toString().toLowerCase().contains('connection refused') ||
          e.toString().toLowerCase().contains('no route to host')) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
      } else {
        apiResponse.responseMessage =
            'An unexpected error occurred. Please try again.';
      }
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
      Logger().e("Dio Response Full Message: ${e.response?.data}", error: e);
      apiResponse.responseSuccessful = false;

      // ─── Check for network/connectivity errors first ───────────
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 Network error: ${e.type}');
        return apiResponse;
      }

      // ─── Check inner error for SocketException ─────────────────
      if (e.error is SocketException) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 SocketException wrapped in DioException');
        return apiResponse;
      }

      // ─── Parse response body for error message ─────────────────
      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable. Please try again later.';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (e) {
      Logger().e('🌐 SocketException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'No internet connection. Please check your network and try again.';
    } on HttpException catch (e) {
      Logger().e('🌐 HttpException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'Unable to reach the server. Please try again later.';
    } catch (e, s) {
      Logger().e('🔥 Unexpected error in request', error: e, stackTrace: s);
      apiResponse.responseSuccessful = false;

      if (e.toString().toLowerCase().contains('socketexception') ||
          e.toString().toLowerCase().contains('network is unreachable') ||
          e.toString().toLowerCase().contains('connection refused') ||
          e.toString().toLowerCase().contains('no route to host')) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
      } else {
        apiResponse.responseMessage =
            'An unexpected error occurred. Please try again.';
      }
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
      Logger().e("Dio Response Full Message: ${e.response?.data}", error: e);
      apiResponse.responseSuccessful = false;

      // ─── Check for network/connectivity errors first ───────────
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 Network error: ${e.type}');
        return apiResponse;
      }

      // ─── Check inner error for SocketException ─────────────────
      if (e.error is SocketException) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
        Logger().e('🌐 SocketException wrapped in DioException');
        return apiResponse;
      }

      // ─── Parse response body for error message ─────────────────
      dynamic data = e.response?.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        final msg = data['message'];
        message = msg is String ? msg : message;
      } else if (data is String) {
        if (data.contains('502 Bad Gateway')) {
          message = 'Server temporarily unavailable. Please try again later.';
        } else if (data.contains('html')) {
          message = 'Unexpected server error. Please try again later.';
        } else {
          message = data;
        }
      }

      apiResponse.responseMessage = message;

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (e) {
      Logger().e('🌐 SocketException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'No internet connection. Please check your network and try again.';
    } on HttpException catch (e) {
      Logger().e('🌐 HttpException in request', error: e);
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          'Unable to reach the server. Please try again later.';
    } catch (e, s) {
      Logger().e('🔥 Unexpected error in request', error: e, stackTrace: s);
      apiResponse.responseSuccessful = false;

      if (e.toString().toLowerCase().contains('socketexception') ||
          e.toString().toLowerCase().contains('network is unreachable') ||
          e.toString().toLowerCase().contains('connection refused') ||
          e.toString().toLowerCase().contains('no route to host')) {
        apiResponse.responseMessage =
            'No internet connection. Please check your network and try again.';
      } else {
        apiResponse.responseMessage =
            'An unexpected error occurred. Please try again.';
      }
    }
    return apiResponse;
  }
}
