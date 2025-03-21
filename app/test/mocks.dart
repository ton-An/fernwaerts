import 'package:dio/dio.dart';
import 'package:location_history/core/data/datasources/server_remote_handler.dart';
import 'package:location_history/core/data/repository/repository_failure_handler.dart';
import 'package:location_history/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

// -- Third Party -- //
class MockDio extends Mock implements Dio {}

// -- Core -- //
class MockServerRemoteHandler extends Mock implements ServerRemoteHandler {}

class MockRepositoryFailureHandler extends Mock
    implements RepositoryFailureHandler {}

// -- Authentication
class MockAuthRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}
