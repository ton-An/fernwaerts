import 'dart:io';

import 'package:dio/dio.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';

final String tServerUrlString = "https://coolness_checks.com";
final String tServerCallPath = "/is_ted_cool";
final Uri tServerUrl = Uri.parse(tServerUrlString + tServerCallPath);

final Map<String, dynamic> tOkResponseData = {
  "data": {
    "is_ted_cool": true,
    "message": "I am disappointed that you would even ask a question like that",
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
  "data": {"is_server_set_up": true},
};

final DioException tBadResponseDioException = DioException.badResponse(
  statusCode: 400,
  requestOptions: RequestOptions(),
  response: Response(requestOptions: RequestOptions()),
);

final UnknownRequestFailure tUnknownRequestFailure = UnknownRequestFailure();
