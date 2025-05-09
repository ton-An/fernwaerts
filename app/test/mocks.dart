import 'package:dio/dio.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/permissions_local_data_source.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/repositories/permissions_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_new_server_connection.dart';
import 'package:location_history/features/authentication/domain/usecases/sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -- Third Party -- //
class MockDio extends Mock implements Dio {}

class MockSupabase extends Mock implements Supabase {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder<T> extends Mock
    implements PostgrestFilterBuilder<T> {}

class MockPostgrestTransformBuilder<T> extends Mock
    implements PostgrestTransformBuilder<T> {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockFlutterActivityRecognition extends Mock
    implements FlutterActivityRecognition {}

// -- Core -- //
class MockServerRemoteHandler extends Mock implements ServerRemoteHandler {}

class MockRepositoryFailureHandler extends Mock
    implements RepositoryFailureHandler {}

class MockSupabaseHandler extends Mock implements SupabaseHandler {}

// -- Authentication
class MockAuthLocalDataSource extends Mock
    implements AuthenticationLocalDataSource {}

class MockAuthRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

class MockPermissionsLocalDataSource extends Mock
    implements PermissionsLocalDataSource {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class MockInitializeServerConnection extends Mock
    implements InitializeNewServerConnection {}

class MockSignIn extends Mock implements SignIn {}
