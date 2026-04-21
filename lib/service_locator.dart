import 'package:dio/dio.dart';
import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/core/utils/storage/auth_storage.dart';
import 'package:electra/core/utils/storage/onboarding_storage.dart';
import 'package:electra/core/utils/storage/secure_storage.dart';
import 'package:electra/data/repository/auth/auth_repository_impl.dart';
import 'package:electra/data/repository/purchase/purchase_repository_impl.dart';
import 'package:electra/data/repository/receipt/receipt_repository_impl.dart';
import 'package:electra/data/repository/user/user_repository_impl.dart';
import 'package:electra/data/repository/voice/voice_repository_impl.dart';
import 'package:electra/data/source/auth/apple_auth_datasource.dart';
import 'package:electra/data/source/auth/auth_remote_datasource.dart';
import 'package:electra/data/source/auth/google_auth_datasource.dart';
import 'package:electra/data/source/purchase/purchase_remote_datasource.dart';
import 'package:electra/data/source/receipt/receipt_data_source.dart';
import 'package:electra/data/source/user/user_datasource.dart';
import 'package:electra/data/source/voice/voice_stream_service.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';
import 'package:electra/domain/repository/purchase/purchase_repository.dart';
import 'package:electra/domain/repository/receipt/receipt_repository.dart';
import 'package:electra/domain/repository/user/user_repository.dart';
import 'package:electra/domain/repository/voice/voice_repository.dart';
import 'package:electra/domain/usecases/auth/logout_user.dart';
import 'package:electra/domain/usecases/auth/refresh_token.dart';
import 'package:electra/domain/usecases/auth/social_login_usecase.dart';
import 'package:electra/domain/usecases/purchase/check_has_purchases_usecase.dart';
import 'package:electra/domain/usecases/purchase/get_purchases_usecase.dart';
import 'package:electra/domain/usecases/receipt/pick_receipt_image.dart';
import 'package:electra/domain/usecases/user/get_user.dart';
import 'package:electra/domain/usecases/auth/login_user.dart';
import 'package:electra/domain/usecases/auth/register_user.dart';
import 'package:electra/domain/usecases/voice/listen_voice_stream.dart';
import 'package:electra/domain/usecases/voice/start_voice_stream.dart';
import 'package:electra/domain/usecases/voice/stop_voice_stream.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/api_client.dart';
import 'core/network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Add at the top of init(), before anything else
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => OnboardingStorage(sl()));

  /// Core
  final dioClient = DioClient();
  sl.registerLazySingleton(() => dioClient.dio);
  sl.registerLazySingleton(() => ApiClient(sl<Dio>()));

  /// Storage
  sl.registerLazySingleton(() => SecureStorage());
  sl.registerLazySingleton(() => AuthStorage(sl<SecureStorage>()));

  // Cubits
  sl.registerFactory(() => PurchaseCubit(sl()));

  // Global auth state
  // AppAuthCubit now needs AuthRepository too
  sl.registerLazySingleton(
    () => AppAuthCubit(sl<AuthStorage>(), sl<AuthRepositoryImpl>()),
  );

  // =============== DATASOURCES/SERVICES (API calls) ======================
  /// DataSources
  sl.registerLazySingleton(() => AuthRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton(() => UserRemoteDataSource(sl<ApiClient>()));
  sl.registerLazySingleton(() => ReceiptDataSource(ImagePicker()));
  sl.registerLazySingleton(() => VoiceStreamService());
  sl.registerLazySingleton<PurchaseRemoteDataSourceImpl>(
    () => PurchaseRemoteDataSourceImpl(sl()),
  );

  // =============== REPOSITORIES ======================
  /// Repository
  sl.registerLazySingleton(() => GoogleAuthDataSourceImpl());
  sl.registerLazySingleton(() => AppleAuthDataSourceImpl());
  sl.registerLazySingleton(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSourceImpl>(),
      storage: sl<AuthStorage>(),
      googleAuthDataSource: sl<GoogleAuthDataSourceImpl>(),
      appleAuthDataSource: sl<AppleAuthDataSourceImpl>(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserRemoteDataSource>()),
  );
  sl.registerLazySingleton<VoiceRepository>(
    () => VoiceRepositoryImpl(sl<VoiceStreamService>()),
  );
  sl.registerLazySingleton<ReceiptRepository>(
    () => ReceiptRepositoryImpl(sl<ReceiptDataSource>()),
  );
  sl.registerLazySingleton<PurchaseRepository>(
    () => PurchaseRepositoryImpl(sl<PurchaseRemoteDataSourceImpl>()),
  );

  // =============== USECASES ======================
  /// Auth Usecases
  sl.registerLazySingleton(() => LoginUser(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => RegisterUser(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => RefreshToken(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => LogoutUser(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => SocialLoginUseCase(sl<AuthRepositoryImpl>()));

  /// User Usecases
  sl.registerLazySingleton(() => GetCurrentUser(sl<UserRepositoryImpl>()));

  /// Voice Usecases
  sl.registerLazySingleton(() => StartVoiceStream(sl<VoiceRepository>()));
  sl.registerLazySingleton(() => StopVoiceStream(sl<VoiceRepository>()));
  sl.registerLazySingleton(() => ListenVoiceStream(sl<VoiceRepository>()));

  /// Receipt Usecases
  sl.registerLazySingleton(() => PickReceiptImage(sl<ReceiptRepository>()));

  /// Purchase Usecases
  sl.registerLazySingleton(() => CheckHasPurchasesUseCase(sl()));
  sl.registerLazySingleton(() => GetPurchasesUseCase(sl()));
}
