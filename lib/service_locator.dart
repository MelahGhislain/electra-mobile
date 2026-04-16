import 'package:dio/dio.dart';
import 'package:electra/core/utils/storage/secure_storage.dart';
import 'package:electra/data/repository/auth/auth_repository_impl.dart';
import 'package:electra/data/repository/user/user_repository_impl.dart';
import 'package:electra/data/repository/voice/voice_repository_impl.dart';
import 'package:electra/data/source/auth/auth_datasource.dart';
import 'package:electra/data/source/user/user_datasource.dart';
import 'package:electra/data/source/voice/voice_stream_service.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';
import 'package:electra/domain/repository/user/user_repository.dart';
import 'package:electra/domain/repository/voice/voice_repository.dart';
import 'package:electra/domain/usecases/auth/logout_user.dart';
import 'package:electra/domain/usecases/auth/refresh_token.dart';
import 'package:electra/domain/usecases/user/get_user.dart';
import 'package:electra/domain/usecases/auth/login_user.dart';
import 'package:electra/domain/usecases/auth/signup_user.dart';
import 'package:electra/domain/usecases/voice/listen_voice_stream.dart';
import 'package:electra/domain/usecases/voice/start_voice_stream.dart';
import 'package:electra/domain/usecases/voice/stop_voice_stream.dart';
import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'core/network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Core
  final dioClient = DioClient();
  sl.registerLazySingleton(() => dioClient.dio);
  sl.registerLazySingleton(() => ApiClient(sl<Dio>()));

  /// Storage
  sl.registerLazySingleton(() => SecureStorage());

  // =============== DATASOURCES/SERVICES (API calls) ======================
  /// DataSources
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl<ApiClient>()));
  sl.registerLazySingleton(() => UserRemoteDataSource(sl<ApiClient>()));
  sl.registerLazySingleton(() => VoiceStreamService());

  // =============== REPOSITORIES ======================
  /// Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserRemoteDataSource>()),
  );
  sl.registerLazySingleton<VoiceRepository>(
    () => VoiceRepositoryImpl(sl<VoiceStreamService>()),
  );

  // =============== USECASES ======================
  /// Auth Usecases
  sl.registerLazySingleton(() => LoginUser(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignupUser(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RefreshToken(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUser(sl<AuthRepository>()));

  /// User Usecases
  sl.registerLazySingleton(() => GetCurrentUser(sl<UserRepositoryImpl>()));

  /// Voice Usecases
  sl.registerLazySingleton(() => StartVoiceStream(sl<VoiceRepository>()));
  sl.registerLazySingleton(() => StopVoiceStream(sl<VoiceRepository>()));
  sl.registerLazySingleton(() => ListenVoiceStream(sl<VoiceRepository>()));
}
