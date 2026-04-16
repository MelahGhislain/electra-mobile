import 'package:electra/core/utils/storage/secure_storage.dart';
import 'package:electra/data/repository/auth/auth_repository_impl.dart';
import 'package:electra/data/repository/user/user_repository_impl.dart';
import 'package:electra/data/source/auth/auth_datasource.dart';
import 'package:electra/data/source/user/user_datasource.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';
import 'package:electra/domain/repository/user/user_repository.dart';
import 'package:electra/domain/usecases/auth/logout_user.dart';
import 'package:electra/domain/usecases/auth/refresh_token.dart';
import 'package:electra/domain/usecases/user/get_user.dart';
import 'package:electra/domain/usecases/auth/login_user.dart';
import 'package:electra/domain/usecases/auth/signup_user.dart';
import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'core/network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Core
  final dioClient = DioClient();
  sl.registerLazySingleton(() => dioClient.dio);
  sl.registerLazySingleton(() => ApiClient(sl()));
  /// Storage
  sl.registerLazySingleton(() => SecureStorage());

  /// DataSources
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  sl.registerLazySingleton(() => UserRemoteDataSource(sl()));

  /// Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  
  

  /// Auth Usecases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => SignupUser(sl()));
  sl.registerLazySingleton(() => RefreshToken(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));

  /// User Usecases
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
}