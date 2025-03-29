import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/data/datasources/supabase_handler.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:location_history/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:location_history/features/authentication/domain/usecases/initialize_server_connection.dart';
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

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockInitializeServerConnection extends Mock
    implements InitializeServerConnection {}
