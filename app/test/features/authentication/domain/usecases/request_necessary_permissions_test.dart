import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_history/core/failures/permission/activity_permission_not_granted_failure.dart';
import 'package:location_history/core/failures/permission/basic_location_permission_not_granted_failure.dart';
import 'package:location_history/features/authentication/domain/usecases/request_necessary_permissions.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late RequestNecessaryPermissions requestNecessaryPermissions;
  late MockPermissionsRepository mockPermissionsRepository;

  setUp(() {
    mockPermissionsRepository = MockPermissionsRepository();
    requestNecessaryPermissions = RequestNecessaryPermissions(
      permissionsRepository: mockPermissionsRepository,
    );
  });

  setUp(() {
    when(
      () => mockPermissionsRepository.requestLocationPermission(),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockPermissionsRepository.requestActivityPermission(),
    ).thenAnswer((_) async => const Right(None()));
  });

  test('should request activity recognition permissions', () async {
    // act
    await requestNecessaryPermissions();

    // assert
    verify(() => mockPermissionsRepository.requestActivityPermission());
  });

  test(
    'should return an ActivityPermissionNotGrantedFailure if activity recognition permissions are not granted',
    () async {
      // arrange
      when(
        () => mockPermissionsRepository.requestActivityPermission(),
      ).thenAnswer(
        (_) async => const Left(ActivityPermissionNotGrantedFailure()),
      );

      // act
      final result = await requestNecessaryPermissions();

      // assert
      expect(result, const Left(ActivityPermissionNotGrantedFailure()));
    },
  );

  test('should request location permissions and return None', () async {
    // act
    final result = await requestNecessaryPermissions();

    // assert
    expect(result, const Right(None()));
    verify(() => mockPermissionsRepository.requestLocationPermission());
  });

  test(
    'should return a LocationPermissionNotGrantedFailure if location permissions are not granted',
    () async {
      // arrange
      when(
        () => mockPermissionsRepository.requestLocationPermission(),
      ).thenAnswer(
        (_) async => const Left(BasicLocationPermissionNotGrantedFailure()),
      );

      // act
      final result = await requestNecessaryPermissions();

      // assert
      expect(result, const Left(BasicLocationPermissionNotGrantedFailure()));
    },
  );
}
