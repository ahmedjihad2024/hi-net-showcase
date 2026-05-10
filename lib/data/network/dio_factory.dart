import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hi_net/app/app.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:hi_net/app/constants.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/flavor.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/data/request/request.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/domain/usecase/refresh_auth_token_usecase.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/services/app_preferences.dart';
import '../../app/services/firebase_messeging_services.dart';
import '../../app/services/flutter_background_services.dart';

const String APPLICATION_JSON = 'application/json';
const String CONTENT_TYPE = 'content-type';
const String ACCEPT = 'accept';
const String AUTHORIZATION = 'authorization';
const String DEFAULT_LANGUAGE = 'Accept-Language';
const String SECRET_KEY = "Accept-Secret-Key";

enum RequestMethod { GET, POST, PUT, DELETE, PATCH }

class DioFactory {
  late Dio _dio;
  AppPreferences _appPreferences;
  bool isForNotification;

  static Completer<void>? _refreshCompleter;

  Dio get dio => _dio;

  DioFactory(this._appPreferences, {this.isForNotification = false}) {
    _dio = Dio();

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: 'Bearer ${_appPreferences.token}',
      DEFAULT_LANGUAGE: 'en',
    };

    _dio.options = BaseOptions(
      baseUrl: FlavorConfig.instance.baseUrl,
      headers: headers,
      followRedirects: false,
      receiveDataWhenStatusError: true,
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _appPreferences.reload();
          if (_appPreferences.token != null) {
            options.headers['Authorization'] =
                'Bearer ${_appPreferences.token}';
          }
          if (SCAFFOLD_MESSENGER_KEY.currentState != null) {
            options.headers[DEFAULT_LANGUAGE] =
                EasyLocalization.of(
                  SCAFFOLD_MESSENGER_KEY.currentState!.context,
                )?.currentLocale?.languageCode ??
                Platform.localeName.split("_")[0].toLowerCase();
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 &&
              e.response?.data?['response']?['errorType'] ==
                  'UnauthorizedException' &&
              _appPreferences.refreshToken != null) {
            if (e.requestOptions.path == "/auth/refresh") {
              if (isForNotification) return handler.reject(e);
              final userId = (await _appPreferences.getUserData())?.id ?? "";
              FirebaseMessegingServices.instance
                  .unsubscribeFromTopicsTryUntilSuccess(
                    topics: [
                      FlavorConfig.instance.flavor.isProd
                      ? userId
                      : "${userId}_dev",
                    ],
                  );
              await _appPreferences.deleteUserData();
              await _appPreferences.clearAllTokens();
              MyBackgroundService.instance.stop();
              NAVIGATOR_KEY.currentState!.pushNamedAndRemoveUntil(
                RoutesManager.signIn.route,
                (route) => false,
              );
              debugPrint("❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️");
              return;
            }

            // If another request is already refreshing, wait for it
            if (_refreshCompleter != null) {
              await _refreshCompleter!.future;
              await _appPreferences.reload();
              e.requestOptions.headers['Authorization'] =
                  "Bearer ${_appPreferences.token}";
              if (e.requestOptions.headers['Content-Type']?.startsWith(
                'multipart/form-data',
              ) == true) {
                e.requestOptions.data = (e.requestOptions.data as FormData)
                    .clone();
              }
              return handler.resolve(await _dio.fetch(e.requestOptions));
            }

            _refreshCompleter = Completer<void>();
            try {
              await _appPreferences.reload();

              // Check if another isolate (background service) already refreshed
              final currentToken = _appPreferences.token;
              final requestToken = e.requestOptions.headers['Authorization']
                  ?.toString().replaceFirst('Bearer ', '');
              if (currentToken != null && currentToken != requestToken) {
                _refreshCompleter!.complete();
                _refreshCompleter = null;
                e.requestOptions.headers['Authorization'] =
                    "Bearer $currentToken";
                if (e.requestOptions.headers['Content-Type']?.startsWith(
                  'multipart/form-data',
                ) == true) {
                  e.requestOptions.data = (e.requestOptions.data as FormData)
                      .clone();
                }
                return handler.resolve(await _dio.fetch(e.requestOptions));
              }

              Either<Failure, UserResponse> response =
                  await instance<RefreshAuthTokenUseCase>().execute(
                    RefreshTokenRequest(
                      refreshToken: _appPreferences.refreshToken!,
                    ),
                  );
              return response.fold(
                (failure) async {
                  _refreshCompleter!.completeError(failure);
                  _refreshCompleter = null;
                  return handler.reject(e);
                },
                (response) async {
                  await _appPreferences.setToken(response.accessToken!);
                  await _appPreferences.setRefreshToken(response.refreshToken!);
                  await _appPreferences.setUserData(response.user!);
                  await _appPreferences.sharedPreferences.reload();
                  _refreshCompleter!.complete();
                  _refreshCompleter = null;
                  if (e.requestOptions.headers['Content-Type']?.startsWith(
                    'multipart/form-data',
                  ) == true) {
                    e.requestOptions.data = (e.requestOptions.data as FormData)
                        .clone();
                  }
                  e.requestOptions.headers['Authorization'] =
                      "Bearer ${_appPreferences.token}";
                  return handler.resolve(await _dio.fetch(e.requestOptions));
                },
              );
            } catch (error) {
              if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
                _refreshCompleter!.completeError(error);
              }
              _refreshCompleter = null;
              return handler.reject(e);
            }
          }
          return handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
    }
  }

  Future<Response> request(
    String path, {
    RequestMethod method = RequestMethod.GET,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.request(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(method: method.name, headers: headers),
    );
  }
}
