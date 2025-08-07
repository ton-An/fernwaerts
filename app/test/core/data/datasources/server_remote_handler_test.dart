import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/failures/networking/server_type.dart';
import 'package:location_history/core/failures/networking/status_code_not_ok_failure.dart';
import 'package:location_history/core/failures/networking/unknown_request_failure.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures.dart';
import '../../../mocks/mocks.dart';

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
    _dioTests(
      toBeTestedFunction:
          () => serverRemoteHandlerImpl.get(
            url: tServerUrl,
            serverType: ServerType.supabase,
          ),
      toBeMockedFunction: () => mockDio.getUri(any()),
    );
  });

  group('post()', () {
    _dioTests(
      toBeTestedFunction:
          () => serverRemoteHandlerImpl.post(
            url: tServerUrl,
            body: tRequestBody,
            serverType: ServerType.supabase,
          ),
      toBeMockedFunction:
          () => mockDio.postUri(any(), data: any(named: 'data')),
    );
  });
}

void _dioTests({
  required FutureFunction toBeTestedFunction,
  required FutureFunction toBeMockedFunction,
}) {
  setUp(() {
    when(() => toBeMockedFunction()).thenAnswer((_) async => tOkResponse);
  });

  test('should return the response body if the status code is 200', () async {
    // act
    final result = await toBeTestedFunction();

    // assert
    expect(result, tOkResponseData);
  });

  test(
    'should throw StatusCodeNotOkFailure if the status code is not 200',
    () async {
      // arrange
      when(() => toBeMockedFunction()).thenAnswer((_) async => tBadResponse);

      // act & assert
      expect(
        () async => await toBeTestedFunction(),
        throwsA(isA<StatusCodeNotOkFailure>()),
      );
    },
  );

  test(
    'should throw UnknownRequestFailure if the status code is null',
    () async {
      // arrange
      when(
        () => toBeMockedFunction(),
      ).thenAnswer((_) async => tNullStatusCodeResponse);

      // act & assert
      expect(
        () async => await toBeTestedFunction(),
        throwsA(isA<UnknownRequestFailure>()),
      );
    },
  );
}

typedef FutureFunction = Future Function();
