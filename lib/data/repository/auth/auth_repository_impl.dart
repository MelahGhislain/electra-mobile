import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:electra/core/enums/auth_provider_enum.dart';
import 'package:electra/core/errors/dio_error_mapper.dart';
import 'package:electra/core/errors/failures.dart';
import 'package:electra/core/utils/storage/auth_storage.dart';
import 'package:electra/data/source/auth/apple_auth_datasource.dart';
import 'package:electra/data/source/auth/auth_remote_datasource.dart';
import 'package:electra/data/source/auth/google_auth_datasource.dart';
import 'package:electra/domain/entities/auth/auth_tokens.dart';
import 'package:electra/domain/entities/auth/social_auth_credential.dart';
import 'package:electra/domain/repository/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceImpl remoteDataSource;
  final GoogleAuthDataSourceImpl googleAuthDataSource;
  final AppleAuthDataSourceImpl appleAuthDataSource;
  final AuthStorage storage;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storage,
    required this.googleAuthDataSource,
    required this.appleAuthDataSource,
  });

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final token = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await storage.saveTokens(
        access: token.accessToken,
        refresh: token.refreshToken,
      );
      return Right(token);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final token = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      await storage.saveTokens(
        access: token.accessToken,
        refresh: token.refreshToken,
      );
      return Right(token);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refresh({
    required String refreshToken,
  }) async {
    try {
      final token = await remoteDataSource.refresh(refreshToken: refreshToken);
      await storage.saveTokens(
        access: token.accessToken,
        refresh: token.refreshToken,
      );
      return Right(token);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout(AuthProviderEnum? authProvider) async {
    try {
      await remoteDataSource.logout();
      await storage.clearTokens();
      if (authProvider == AuthProviderEnum.google){
        await googleAuthDataSource.signOut();
      }
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> loginWithSocial(
    SocialAuthCredential credential,
  ) async {
    try {
      final token = await remoteDataSource.loginWithSocial(credential);
      await storage.saveTokens(
        access: token.accessToken,
        refresh: token.refreshToken,
      );
      return Right(token);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  // ── OAuth convenience methods ─────────────────────────────────────────────
  // These sit outside the AuthRepository interface so they return Either
  // directly — the cubit calls them and handles Left/Right itself.

  Future<Either<Failure, AuthTokens?>> signInWithGoogle() async {
    try {
      final credential = await googleAuthDataSource.signIn();
      if (credential == null) return const Right(null); // user cancelled
      return loginWithSocial(credential);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  Future<Either<Failure, AuthTokens?>> signInWithApple() async {
    try {
      final credential = await appleAuthDataSource.signIn();
      if (credential == null) return const Right(null); // user cancelled
      return loginWithSocial(credential);
    } on DioException catch (e) {
      return Left(mapDioError(e));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
