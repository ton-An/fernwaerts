import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/misc/url_path_constants.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  late ServerRemoteHandler mockServerRemoteHandler;

  setUp(() {
    mockServerRemoteHandler = MockServerRemoteHandler();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(
      serverRemoteHandler: mockServerRemoteHandler,
    );
  });

  setUpAll(() {
    registerFallbackValue(tServerUrl);
  });

  group('isServerReachable', () {
    setUp(() {
      when(
        () => mockServerRemoteHandler.get(url: any(named: "url")),
      ).thenAnswer((_) async => tNullResponseData);
    });
    test("should check if the server is reachable", () async {
      // act
      await authRemoteDataSourceImpl.isServerReachable(tServerUrl);

      // assert
      verify(
        () => mockServerRemoteHandler.get(
          url: Uri.parse(tServerUrlString + UrlPathConstants.healthCheckPath),
        ),
      );
    });
  });

  group("isServerSetUp", () {
    setUp(() {
      when(
        () => mockServerRemoteHandler.get(url: any(named: "url")),
      ).thenAnswer((_) async => tIsServerSetUpResponseData);
    });

    test(
      "should check if the server is set up and return the boolean value",
      () async {
        // act
        final result = await authRemoteDataSourceImpl.isServerSetUp(tServerUrl);

        // assert
        verify(
          () => mockServerRemoteHandler.get(
            url: Uri.parse(
              tServerUrlString + UrlPathConstants.isServerSetUpPath,
            ),
          ),
        );
        expect(result, true);
      },
    );
  });
}
