import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mocks.dart';

final String tServerUrlString = 'https://coolness_checks.com';
final String tServerCallPath = '/is_ted_cool';
final Uri tServerUrl = Uri.parse(tServerUrlString + tServerCallPath);

final Map<String, dynamic> tRequestBody = {'name': 'Ted'};

final Map<String, dynamic> tOkResponseData = {
  'data': {
    'is_ted_cool': true,
    'message': 'I am disappointed that you would even ask a question like that',
  },
};
final Response tOkResponse = Response(
  data: tOkResponseData,
  statusCode: HttpStatus.ok,
  requestOptions: RequestOptions(path: tServerCallPath),
);

final Response tBadResponse = Response(
  data: null,
  statusCode: HttpStatus.badRequest,
  requestOptions: RequestOptions(path: tServerCallPath),
);

final Response tNullStatusCodeResponse = Response(
  data: null,
  statusCode: null,
  requestOptions: RequestOptions(path: tServerCallPath),
);

final tNullResponseData = null;

final tIsServerSetUpResponseData = {
  'data': {'is_server_set_up': true},
};

final DioException tBadResponseDioException = DioException.badResponse(
  statusCode: 400,
  requestOptions: RequestOptions(),
  response: Response(requestOptions: RequestOptions()),
);

final UnknownRequestFailure tUnknownRequestFailure = const UnknownRequestFailure();

final Map<String, dynamic> tPublicSettingsMap = {
  'name': 'is_set_up',
  'value': true,
};

final MockSupabase tMockSupabase = MockSupabase();

final http.ClientException tTimeoutClientException = http.ClientException(
  'Operation timed out',
  tServerUrl,
);

final StackTrace tStackTrace = StackTrace.empty;

final http.ClientException tUnknownClientException = http.ClientException(
  'Really weird error',
  tServerUrl,
);

final ArgumentError tArgumentError = ArgumentError();

final FormatException tFormatException = const FormatException();

final PostgrestException tPostgresException = const PostgrestException(message: '');

final PlatformException tPlatformException = PlatformException(code: 'bad');

final String tUsername = 'Ted';
final String tEmail = 'ted@example.com';
final String tPassword = 'VeryStrongPassword';
