import 'package:dio/dio.dart';
import 'package:electra/common/blocs/auth/app_auth_cubit.dart';
import 'package:electra/core/network/auth_interceptor.dart';
import 'package:electra/core/utils/storage/auth_storage.dart';
import 'package:electra/core/utils/storage/onboarding_storage.dart';
import 'package:electra/core/utils/storage/secure_storage.dart';
import 'package:electra/data/repository/auth/auth_repository_impl.dart';
import 'package:electra/data/repository/insights/insights_repository_impl.dart';
import 'package:electra/data/repository/purchase/purchase_repository_impl.dart';
import 'package:electra/data/repository/receipt/receipt_repository_impl.dart';
import 'package:electra/data/repository/subscription/subscription_repository_impl.dart';
import 'package:electra/data/repository/user/user_repository_impl.dart';
import 'package:electra/data/repository/voice/voice_repository_impl.dart';
import 'package:electra/data/source/auth/apple_auth_datasource.dart';
import 'package:electra/data/source/auth/auth_remote_datasource.dart';
import 'package:electra/data/source/auth/google_auth_datasource.dart';
import 'package:electra/data/source/insights/insights_remote_datasource.dart';
import 'package:electra/data/source/purchase/purchase_remote_datasource.dart';
import 'package:electra/data/source/receipt/receipt_data_source.dart';
import 'package:electra/data/source/subscription/iap_datasource.dart';
import 'package:electra/data/source/subscription/subscription_remote_datasource.dart';
import 'package:electra/data/source/user/user_datasource.dart';
import 'package:electra/data/source/voice/voice_stream_service.dart';
import 'package:electra/domain/repository/insights/insights_repository.dart';
import 'package:electra/domain/repository/purchase/purchase_repository.dart';
import 'package:electra/domain/repository/receipt/receipt_repository.dart';
import 'package:electra/domain/repository/subscription/subscription_repository.dart';
import 'package:electra/domain/repository/voice/voice_repository.dart';
import 'package:electra/domain/usecases/auth/logout_user.dart';
import 'package:electra/domain/usecases/auth/refresh_token.dart';
import 'package:electra/domain/usecases/auth/social_login_usecase.dart';
import 'package:electra/domain/usecases/insights/get_insights_usecase.dart';
import 'package:electra/domain/usecases/purchase/check_has_purchases_usecase.dart';
import 'package:electra/domain/usecases/purchase/get_purchase_detail_usecase.dart';
import 'package:electra/domain/usecases/purchase/get_purchases_usecase.dart';
import 'package:electra/domain/usecases/purchase/purchase_item_usecases.dart';
import 'package:electra/domain/usecases/purchase/purchase_usecases.dart';
import 'package:electra/domain/usecases/receipt/pick_receipt_image.dart';
import 'package:electra/domain/usecases/auth/login_user.dart';
import 'package:electra/domain/usecases/auth/register_user.dart';
import 'package:electra/domain/usecases/subscription/subscription_usecase.dart';
import 'package:electra/domain/usecases/user/setting_usecase.dart';
import 'package:electra/domain/usecases/user/user_usecase.dart';
import 'package:electra/domain/usecases/voice/listen_voice_stream.dart';
import 'package:electra/domain/usecases/voice/start_voice_stream.dart';
import 'package:electra/domain/usecases/voice/stop_voice_stream.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase_detail/purchase_detail_cubit.dart';
import 'package:electra/presentation/subscription/bloc/subscription_cubit.dart';
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

  // ── IAP (In-App Purchase) ──────────────────────────────────────
  final iapDataSource = IAPDataSource();
  await iapDataSource.initialize(); // sets up the purchase stream listener
  sl.registerLazySingleton(() => iapDataSource);

  /// Core
  final dioClient = DioClient();
  sl.registerLazySingleton(() => dioClient.dio);
  sl.registerLazySingleton(() => ApiClient(sl<Dio>()));

  /// Storage
  sl.registerLazySingleton(() => SecureStorage());
  sl.registerLazySingleton(() => AuthStorage(sl<SecureStorage>()));

  // Cubits
  sl.registerLazySingleton(
    () => PurchaseCubit(
      getPurchases: sl(),
      createPurchase: sl(),
      updatePurchase: sl(),
      deletePurchase: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => PurchaseDetailCubit(
      getPurchaseDetail: sl(),
      createItem: sl(),
      updateItem: sl(),
      deleteItem: sl(),
      purchaseCubit: sl<PurchaseCubit>(),
    ),
  );

  // Global auth state
  // AppAuthCubit now needs AuthRepository too
  sl.registerLazySingleton(
    () => AppAuthCubit(sl<AuthStorage>(), sl<AuthRepositoryImpl>()),
  );

  // =============== DATASOURCES/SERVICES (API calls) ======================
  /// DataSources
  sl.registerLazySingleton(() => AuthRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton(() => UserRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton(() => ReceiptDataSource(ImagePicker()));
  sl.registerLazySingleton(() => VoiceStreamService());
  sl.registerLazySingleton<PurchaseRemoteDataSourceImpl>(
    () => PurchaseRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(() => InsightsRemoteDataSourceImpl(sl<ApiClient>()));
  // ── Subscription datasource ────────────────────────────────────
  sl.registerLazySingleton<SubscriptionRemoteDataSource>(
    () => SubscriptionRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // =============== REPOSITORIES ======================
  /// Repository
  sl.registerLazySingleton(() => GoogleAuthDataSourceImpl());
  await sl<GoogleAuthDataSourceImpl>().initialize();
  sl.registerLazySingleton(() => AppleAuthDataSourceImpl());
  sl.registerLazySingleton(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSourceImpl>(),
      storage: sl<AuthStorage>(),
      googleAuthDataSource: sl<GoogleAuthDataSourceImpl>(),
      appleAuthDataSource: sl<AppleAuthDataSourceImpl>(),
    ),
  );
  sl.registerLazySingleton<UserRepositoryImpl>(
    () => UserRepositoryImpl(sl<UserRemoteDataSourceImpl>()),
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
  sl.registerLazySingleton<InsightsRepository>(
    () => InsightsRepositoryImpl(sl<InsightsRemoteDataSourceImpl>()),
  );
  // ── Subscription repository ────────────────────────────────────
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(
      remoteDataSource: sl<SubscriptionRemoteDataSource>(),
      iapDataSource: sl<IAPDataSource>(),
    ),
  );

  /// ================ INTERCEPTORS ======================
  // ✅ THIS is the missing call — runs after storage + repository are ready
  dioClient.addAuthInterceptor(
    AuthInterceptor(storage: sl<AuthStorage>(), dio: sl<Dio>()),
  );

  // =============== USECASES ======================
  /// Auth Usecases
  sl.registerLazySingleton(() => LoginUser(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => RegisterUser(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => RefreshToken(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => LogoutUser(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => SocialLoginUseCase(sl<AuthRepositoryImpl>()));

  /// User Usecases
  sl.registerLazySingleton(
    () => GetCurrentUserUsecase(sl<UserRepositoryImpl>()),
  );
  sl.registerLazySingleton(() => UpdateUserUsecase(sl<UserRepositoryImpl>()));
  sl.registerLazySingleton(() => DeleteUserUsecase(sl<UserRepositoryImpl>()));
  sl.registerLazySingleton(
    () => UpdateUserSettingUsecase(sl<UserRepositoryImpl>()),
  );

  /// Voice Usecases
  sl.registerLazySingleton(() => StartVoiceStream(sl<VoiceRepository>()));
  sl.registerLazySingleton(() => StopVoiceStream(sl<VoiceRepository>()));
  sl.registerLazySingleton(() => ListenVoiceStream(sl<VoiceRepository>()));

  /// Receipt Usecases
  sl.registerLazySingleton(() => PickReceiptImage(sl<ReceiptRepository>()));

  /// Purchase Usecases
  sl.registerLazySingleton(() => CheckHasPurchasesUseCase(sl()));
  sl.registerLazySingleton(() => GetPurchasesUseCase(sl()));
  sl.registerLazySingleton(() => CreatePurchaseUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePurchaseUseCase(sl()));
  sl.registerLazySingleton(() => DeletePurchaseUseCase(sl()));

  // Purchase Detail Usecases
  sl.registerLazySingleton(() => GetPurchaseDetailUseCase(sl()));
  sl.registerLazySingleton(() => CreatePurchaseItemUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePurchaseItemUseCase(sl()));
  sl.registerLazySingleton(() => DeletePurchaseItemUseCase(sl()));

  /// Insights Usecases
  sl.registerLazySingleton(() => GetInsightsUseCase(sl()));

  /// ── Subscription usecases ──────────────────────────────────────
  sl.registerLazySingleton(() => GetSubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => VerifySubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => RestoreSubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => CancelSubscriptionUseCase(sl()));

  // ── Subscription cubit ─────────────────────────────────────────
  // Registered as factory (not lazy singleton) because the screen
  // creates a fresh cubit each time it opens.
  sl.registerFactory(
    () => SubscriptionCubit(
      getSubscription: sl(),
      verifyPurchase: sl(),
      restorePurchases: sl(),
      cancelSubscription: sl(),
      iap: sl<IAPDataSource>(),
    ),
  );
}
