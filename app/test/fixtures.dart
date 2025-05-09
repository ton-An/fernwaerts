import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';
import 'package:location_history/features/authentication/domain/models/server_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mocks.dart';

const String tServerUrlString = 'https://coolness_checks.com';
const String tServerCallPath = '/is_ted_cool';
const String tAnonKey = 'psssttttt';
const ServerInfo tServerInfo = ServerInfo(
  url: tServerUrlString,
  anonKey: tAnonKey,
);

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

const tNullResponseData = null;

final tIsServerSetUpResponseData = {
  'data': {'is_server_set_up': true},
};

final tGetAnonKeyResponseData = {
  'data': {'anon_key': tAnonKey},
};

final DioException tBadResponseDioException = DioException.badResponse(
  statusCode: 400,
  requestOptions: RequestOptions(),
  response: Response(requestOptions: RequestOptions()),
);

const UnknownRequestFailure tUnknownRequestFailure = UnknownRequestFailure();

final Map<String, dynamic> tPublicSettingsMap = {
  'name': 'is_set_up',
  'value': true,
};

final MockSupabase tMockSupabase = MockSupabase();

final http.ClientException tTimeoutClientException = http.ClientException(
  'Operation timed out',
  tServerUrl,
);

const StackTrace tStackTrace = StackTrace.empty;

final http.ClientException tUnknownClientException = http.ClientException(
  'Really weird error',
  tServerUrl,
);

final ArgumentError tArgumentError = ArgumentError();

const FormatException tFormatException = FormatException();

const PostgrestException tPostgresException = PostgrestException(message: '');

final PlatformException tPlatformException = PlatformException(code: 'bad');

const String tUsername = 'Ted';
const String tEmail = 'ted@example.com';
const String tPassword = 'VeryStrongPassword';
