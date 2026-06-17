import 'package:dio/dio.dart';
import 'package:qleo/common/blocs/auth/app_auth_cubit.dart';
import 'package:qleo/core/network/auth_interceptor.dart';
import 'package:qleo/core/utils/storage/auth_storage.dart';
import 'package:qleo/core/utils/storage/onboarding_storage.dart';
import 'package:qleo/core/utils/storage/secure_storage.dart';
import 'package:qleo/data/repository/auth/auth_repository_impl.dart';
import 'package:qleo/data/repository/insights/insights_repository_impl.dart';
import 'package:qleo/data/repository/purchase/purchase_repository_impl.dart';
import 'package:qleo/data/repository/receipt/receipt_repository_impl.dart';
import 'package:qleo/data/repository/subscription/subscription_repository_impl.dart';
import 'package:qleo/data/repository/user/user_repository_impl.dart';
import 'package:qleo/data/repository/voice/voice_repository_impl.dart';
import 'package:qleo/data/source/auth/apple_auth_datasource.dart';
import 'package:qleo/data/source/auth/auth_remote_datasource.dart';
import 'package:qleo/data/source/auth/google_auth_datasource.dart';
import 'package:qleo/data/source/insights/insights_remote_datasource.dart';
import 'package:qleo/data/source/purchase/purchase_remote_datasource.dart';
import 'package:qleo/data/source/receipt/receipt_data_source.dart';
import 'package:qleo/data/source/subscription/iap_datasource.dart';
import 'package:qleo/data/source/subscription/subscription_remote_datasource.dart';
import 'package:qleo/data/source/user/user_datasource.dart';
import 'package:qleo/domain/repository/insights/insights_repository.dart';
import 'package:qleo/domain/repository/purchase/purchase_repository.dart';
import 'package:qleo/domain/repository/receipt/receipt_repository.dart';
import 'package:qleo/domain/repository/subscription/subscription_repository.dart';
import 'package:qleo/domain/repository/voice/voice_repository.dart';
import 'package:qleo/domain/usecases/auth/logout_user.dart';
import 'package:qleo/domain/usecases/auth/refresh_token.dart';
import 'package:qleo/domain/usecases/auth/social_login_usecase.dart';
import 'package:qleo/domain/usecases/insights/get_insights_usecase.dart';
import 'package:qleo/domain/usecases/purchase/check_has_purchases_usecase.dart';
import 'package:qleo/domain/usecases/purchase/export_purchase_usecase.dart';
import 'package:qleo/domain/usecases/purchase/get_purchase_detail_usecase.dart';
import 'package:qleo/domain/usecases/purchase/get_purchases_usecase.dart';
import 'package:qleo/domain/usecases/purchase/purchase_item_usecases.dart';
import 'package:qleo/domain/usecases/purchase/purchase_usecases.dart';
import 'package:qleo/domain/usecases/receipt/pick_receipt_image.dart';
import 'package:qleo/domain/usecases/auth/login_user.dart';
import 'package:qleo/domain/usecases/auth/register_user.dart';
import 'package:qleo/domain/usecases/subscription/subscription_usecase.dart';
import 'package:qleo/domain/usecases/user/setting_usecase.dart';
import 'package:qleo/domain/usecases/user/user_usecase.dart';
import 'package:qleo/domain/usecases/voice/listen_voice_stream.dart';
import 'package:qleo/domain/usecases/voice/start_voice_stream.dart';
import 'package:qleo/domain/usecases/voice/stop_voice_stream.dart';
import 'package:qleo/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:qleo/presentation/purchase/blocs/purchase_detail/purchase_detail_cubit.dart';
import 'package:qleo/presentation/receipt/bloc/voice/voice_cubit.dart';
import 'package:qleo/presentation/subscription/bloc/subscription_cubit.dart';
import 'package:qleo/core/services/fcm_service.dart';
import 'package:qleo/data/source/notification/notification_datasource.dart';
import 'package:qleo/data/repository/notification/notification_repository_impl.dart';
import 'package:qleo/domain/usecases/notification/notification_usecase.dart';
import 'package:qleo/presentation/notification/blocs/notification_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/api_client.dart';
import 'core/network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => OnboardingStorage(sl()));

  // ── IAP (In-App Purchase) ──────────────────────────────────────
  final iapDataSource = IAPDataSource();
  await iapDataSource.initialize(); // sets up the purchase stream listener
  sl.registerLazySingleton(() => iapDataSource);

  // ── Core network ──────────────────────────────────────────────────────────
  final dioClient = DioClient();
  sl.registerLazySingleton(() => dioClient.dio);
  sl.registerLazySingleton(() => ApiClient(sl<Dio>()));

  // ── Storage ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => SecureStorage());
  sl.registerLazySingleton(() => AuthStorage(sl<SecureStorage>()));

  // ── Global auth cubit ──────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => AppAuthCubit(
      sl<AuthStorage>(),
      sl<AuthRepositoryImpl>(),
      sl<FcmService>(),
      sl<RemovePushTokenUsecase>(),
    ),
  );

  // ── Shared cubits (singleton — live for the app lifetime) ─────────────────
  sl.registerLazySingleton(
    () => PurchaseCubit(
      getPurchases: sl(),
      createPurchase: sl(),
      updatePurchase: sl(),
      deletePurchase: sl(),
      exportPurchase: sl(),
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

  // ── DataSources ───────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton(() => UserRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton(
    () => ReceiptDataSource(ImagePicker(), sl<ApiClient>()),
  );
  // NOTE: VoiceStreamService is NOT registered here.
  // VoiceRepositoryImpl creates a fresh instance per session so the token
  // is always current. Registering it as a singleton would bake in a
  // stale token from startup.
  sl.registerLazySingleton<PurchaseRemoteDataSourceImpl>(
    () => PurchaseRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(() => InsightsRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<SubscriptionRemoteDataSource>(
    () => SubscriptionRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton(
    () => NotificationRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // ── Repositories ──────────────────────────────────────────────────────────
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

  // VoiceRepository takes AuthStorage — reads a fresh token on every
  // startStream() call, never a stale one from app startup.
  sl.registerLazySingleton<VoiceRepository>(
    () => VoiceRepositoryImpl(sl<AuthStorage>()),
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
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(
      remoteDataSource: sl<SubscriptionRemoteDataSource>(),
      iapDataSource: sl<IAPDataSource>(),
    ),
  );
  sl.registerLazySingleton<NotificationRepositoryImpl>(
    () => NotificationRepositoryImpl(sl<NotificationRemoteDataSourceImpl>()),
  );

  // ── Interceptors ──────────────────────────────────────────────────────────
  dioClient.addAuthInterceptor(
    AuthInterceptor(
      storage: sl<AuthStorage>(),
      dio: sl<Dio>(),
      onForceLogout: () => sl<AppAuthCubit>().onLogout(),
    ),
  );
  sl.registerLazySingleton(
    () => FcmService(registerToken: sl<RegisterPushTokenUsecase>()),
  );

  // ── Auth usecases ──────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUser(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => RegisterUser(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => RefreshToken(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => LogoutUser(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => SocialLoginUseCase(sl<AuthRepositoryImpl>()));

  // ── User usecases ──────────────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => GetCurrentUserUsecase(sl<UserRepositoryImpl>()),
  );
  sl.registerLazySingleton(() => UpdateUserUsecase(sl<UserRepositoryImpl>()));
  sl.registerLazySingleton(() => DeleteUserUsecase(sl<UserRepositoryImpl>()));
  sl.registerLazySingleton(
    () => UpdateUserSettingUsecase(sl<UserRepositoryImpl>()),
  );

  // ── Notification usecases ──────────────────────────────────────────────────
  sl.registerLazySingleton(
    () => RegisterPushTokenUsecase(sl<NotificationRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => RemovePushTokenUsecase(sl<NotificationRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => GetNotificationsUsecase(sl<NotificationRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => MarkAllReadUsecase(sl<NotificationRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => GetUnreadCountUsecase(sl<NotificationRepositoryImpl>()),
  );

  // ── Voice usecases ─────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => StartVoiceStream(sl<VoiceRepository>()));
  sl.registerLazySingleton(() => StopVoiceStream(sl<VoiceRepository>()));
  sl.registerLazySingleton(() => ListenVoiceStream(sl<VoiceRepository>()));

  // ── Receipt usecases ───────────────────────────────────────────────────────
  sl.registerLazySingleton(() => PickReceiptImage(sl<ReceiptRepository>()));
  sl.registerLazySingleton(() => UploadReceipt(sl<ReceiptRepository>()));
  sl.registerLazySingleton(() => ExtractReceiptText(sl<ReceiptRepository>()));
  sl.registerLazySingleton(() => ProcessReceiptText(sl<ReceiptRepository>()));

  // ── Purchase usecases ──────────────────────────────────────────────────────
  sl.registerLazySingleton(() => CheckHasPurchasesUseCase(sl()));
  sl.registerLazySingleton(() => GetPurchasesUseCase(sl()));
  sl.registerLazySingleton(() => CreatePurchaseUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePurchaseUseCase(sl()));
  sl.registerLazySingleton(() => DeletePurchaseUseCase(sl()));
  sl.registerLazySingleton(() => ExportPurchaseUseCase(sl()));
  sl.registerLazySingleton(() => GetPurchaseDetailUseCase(sl()));
  sl.registerLazySingleton(() => CreatePurchaseItemUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePurchaseItemUseCase(sl()));
  sl.registerLazySingleton(() => DeletePurchaseItemUseCase(sl()));

  // ── Insights usecases ──────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetInsightsUseCase(sl()));

  // ── Subscription usecases ──────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetSubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => VerifySubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => RestoreSubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => CancelSubscriptionUseCase(sl()));

  // ── Per-screen cubits (factory = fresh instance every time) ───────────────

  // VoiceCubit: factory so each recorder session gets its own clean state.
  // The usecases are singletons but the cubit (and its subscriptions) are not.
  sl.registerFactory(
    () => VoiceCubit(
      startVoiceStream: sl(),
      stopVoiceStream: sl(),
      listenVoiceStream: sl(),
      repository: sl<VoiceRepository>(),
    ),
  );

  sl.registerFactory(
    () => SubscriptionCubit(
      getSubscription: sl(),
      verifyPurchase: sl(),
      restorePurchases: sl(),
      cancelSubscription: sl(),
      iap: sl<IAPDataSource>(),
    ),
  );

  sl.registerFactory(
    () => NotificationCubit(
      registerToken: sl(),
      removeToken: sl(),
      getNotifications: sl(),
      markAllRead: sl(),
      getUnreadCount: sl(),
    ),
  );
}
