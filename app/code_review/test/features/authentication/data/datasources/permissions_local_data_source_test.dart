import 'package:flutter_activity_recognition/models/activity_permission.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_history/core/failures/permission/activity_permission_not_granted_failure.dart';
import 'package:location_history/features/authentication/data/datasources/permissions_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late PermissionsLocalDataSource permissionsLocalDataSource;
  late MockFlutterActivityRecognition mockFlutterActivityRecognition;

  setUp(() {
    mockFlutterActivityRecognition = MockFlutterActivityRecognition();
    permissionsLocalDataSource = PermissionsLocalDataSourceImpl(
      flutterActivityRecognition: mockFlutterActivityRecognition,
    );
  });

  group('requestActivityPermission()', () {
    test(
      'should request activity permission using the flutter_activity_recognition package',
      () async {
        // arrange
        when(
          () => mockFlutterActivityRecognition.requestPermission(),
        ).thenAnswer((_) async => ActivityPermission.GRANTED);

        // act
        await permissionsLocalDataSource.requestActivityPermission();

        // assert
        verify(() => mockFlutterActivityRecognition.requestPermission());
      },
    );

    test(
      'should throw ActivityPermissionNotGrantedFailure when permission is denied',
      () async {
        // arrange
        when(
          () => mockFlutterActivityRecognition.requestPermission(),
        ).thenAnswer((_) async => ActivityPermission.DENIED);

        // act
        final call = permissionsLocalDataSource.requestActivityPermission;

        // assert
        expect(call, throwsA(isA<ActivityPermissionNotGrantedFailure>()));
      },
    );
  });
}
