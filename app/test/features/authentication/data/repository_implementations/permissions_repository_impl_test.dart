import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/permission/activity_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/basic_location_permission_not_granted_failure.dart';
import 'package:location_history/features/authentication/data/repository_implementations/permissions_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late PermissionsRepositoryImpl permissionsRepositoryImpl;
  late MockPermissionsLocalDataSource mockPermissionsLocalDataSource;

  setUp(() {
    mockPermissionsLocalDataSource = MockPermissionsLocalDataSource();
    permissionsRepositoryImpl = PermissionsRepositoryImpl(
      permissionsLocalDataSource: mockPermissionsLocalDataSource,
    );
  });

  group('requestLocationPermission()', () {
    test(
      'should request location permission from local data source and return None',
      () async {
        // arrange
        when(
          () => mockPermissionsLocalDataSource.requestLocationPermission(),
        ).thenAnswer((_) => Future.value());

        // act
        final result =
            await permissionsRepositoryImpl.requestLocationPermission();

        // assert
        expect(result, const Right(None()));
        verify(
          () => mockPermissionsLocalDataSource.requestLocationPermission(),
        );
      },
    );

    test(
      'should relay failures from requesting the location permission',
      () async {
        // arrange
        when(
          () => mockPermissionsLocalDataSource.requestLocationPermission(),
        ).thenThrow(const BasicLocationPermissionNotGrantedFailure());

        // act
        final result =
            await permissionsRepositoryImpl.requestLocationPermission();

        // assert
        expect(result, const Left(BasicLocationPermissionNotGrantedFailure()));
      },
    );
  });

  group('requestActivityPermission()', () {
    test(
      'should request activity permission from local data source and return None',
      () async {
        // arrange
        when(
          () => mockPermissionsLocalDataSource.requestActivityPermission(),
        ).thenAnswer((_) => Future.value());

        // act
        final result =
            await permissionsRepositoryImpl.requestActivityPermission();

        // assert
        expect(result, const Right(None()));
        verify(
          () => mockPermissionsLocalDataSource.requestActivityPermission(),
        );
      },
    );

    test(
      'should relay failures from requesting the activity permission',
      () async {
        // arrange
        when(
          () => mockPermissionsLocalDataSource.requestActivityPermission(),
        ).thenThrow(const ActivityPermissionNotGrantedFailure());

        // act
        final result =
            await permissionsRepositoryImpl.requestActivityPermission();

        // assert
        expect(result, const Left(ActivityPermissionNotGrantedFailure()));
      },
    );
  });
}
