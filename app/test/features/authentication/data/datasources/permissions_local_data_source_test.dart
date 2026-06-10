import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/permission/activity_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/background_location_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/basic_location_permission_not_granted_failure.dart';
import 'package:location_history/features/authentication/data/datasources/permissions_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracelet/tracelet.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late PermissionsLocalDataSource permissionsLocalDataSource;
  late MockTraceletAuthorizationWrapper mockTraceletAuthorizationWrapper;

  setUp(() {
    mockTraceletAuthorizationWrapper = MockTraceletAuthorizationWrapper();
    permissionsLocalDataSource = PermissionsLocalDataSourceImpl(
      traceletAuthorizationWrapper: mockTraceletAuthorizationWrapper,
    );
  });

  group('requestActivityPermission()', () {
    test('should request motion authorization using Tracelet', () async {
      // arrange
      when(
        () => mockTraceletAuthorizationWrapper.requestMotionAuthorization(),
      ).thenAnswer((_) async => MotionAuthorizationStatus.granted);

      // act
      await permissionsLocalDataSource.requestActivityPermission();

      // assert
      verify(
        () => mockTraceletAuthorizationWrapper.requestMotionAuthorization(),
      );
    });

    test(
      'should throw ActivityPermissionNotGrantedFailure when permission is denied',
      () async {
        // arrange
        when(
          () => mockTraceletAuthorizationWrapper.requestMotionAuthorization(),
        ).thenAnswer((_) async => MotionAuthorizationStatus.deniedForever);

        // act
        final call = permissionsLocalDataSource.requestActivityPermission;

        // assert
        expect(call, throwsA(isA<ActivityPermissionNotGrantedFailure>()));
      },
    );
  });

  group('requestLocationPermission()', () {
    test(
      'should complete when Tracelet returns always authorization',
      () async {
        // arrange
        when(
          () => mockTraceletAuthorizationWrapper.requestLocationAuthorization(),
        ).thenAnswer((_) async => AuthorizationStatus.always);

        // act
        await permissionsLocalDataSource.requestLocationPermission();

        // assert
        verify(
          () => mockTraceletAuthorizationWrapper.requestLocationAuthorization(),
        );
      },
    );

    test('should throw BasicLocationPermissionNotGrantedFailure when location '
        'authorization is denied', () async {
      // arrange
      when(
        () => mockTraceletAuthorizationWrapper.requestLocationAuthorization(),
      ).thenAnswer((_) async => AuthorizationStatus.denied);

      // act
      final call = permissionsLocalDataSource.requestLocationPermission;

      // assert
      expect(call, throwsA(isA<BasicLocationPermissionNotGrantedFailure>()));
    });

    test('should throw BackgroundLocationPermissionNotGrantedFailure when only '
        'when-in-use authorization is granted', () async {
      // arrange
      when(
        () => mockTraceletAuthorizationWrapper.requestLocationAuthorization(),
      ).thenAnswer((_) async => AuthorizationStatus.whenInUse);

      // act
      final call = permissionsLocalDataSource.requestLocationPermission;

      // assert
      expect(
        call,
        throwsA(isA<BackgroundLocationPermissionNotGrantedFailure>()),
      );
    });
  });
}
