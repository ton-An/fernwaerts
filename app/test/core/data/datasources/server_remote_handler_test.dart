import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/failures/networking/status_code_not_ok_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  late ServerRemoteHandlerImpl serverRemoteHandlerImpl;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    serverRemoteHandlerImpl = ServerRemoteHandlerImpl(dio: mockDio);
  });

  setUpAll(() {
    registerFallbackValue(tServerUrl);
  });

  group('get()', () {
    setUp(() {
      when(() => mockDio.getUri(any())).thenAnswer((_) async => tOkResponse);
    });

    test("should return the response body if the status code is 200", () async {
      // act
      final result = await serverRemoteHandlerImpl.get(url: tServerUrl);

      // assert
      expect(result, tOkResponseData);
    });

    test(
      "should throw StatusCodeNotOkFailure if the status code is not 200",
      () async {
        // arrange
        when(() => mockDio.getUri(any())).thenAnswer((_) async => tBadResponse);

        // act & assert
        expect(
          () => serverRemoteHandlerImpl.get(url: tServerUrl),
          throwsA(isA<StatusCodeNotOkFailure>()),
        );
      },
    );

    test(
      "should throw UnknownRequestFailure if the status code is null",
      () async {
        // arrange
        when(
          () => mockDio.getUri(any()),
        ).thenAnswer((_) async => tNullStatusCodeResponse);

        // act & assert
        expect(
          () => serverRemoteHandlerImpl.get(url: tServerUrl),
          throwsA(isA<UnknownRequestFailure>()),
        );
      },
    );
  });
}
