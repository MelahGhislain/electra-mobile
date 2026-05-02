import 'dart:io';

import 'package:electra/core/configs/env.dart';
import 'package:electra/domain/entities/auth/social_auth_credential.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleAuthDataSource {
  /// Must be called once at app startup before any sign-in attempt.
  Future<void> initialize();
  Future<SocialAuthCredential?> signIn();
  Future<void> signOut();
}

class GoogleAuthDataSourceImpl implements GoogleAuthDataSource {
  // v7: singleton — do NOT instantiate with a constructor
  final GoogleSignIn _instance = GoogleSignIn.instance;

  bool _initialized = false;

  /// Call this from your injection_container or app startup.
  /// Pass your web client ID (from Google Cloud Console → OAuth 2.0 credentials).
  /// On Android with google-services.json this is optional but still recommended
  /// so the idToken audience matches your backend.
  @override
  Future<void> initialize() async {
    if (_initialized) return;
    await _instance.initialize(
      // Web client ID — required for idToken to be issued
      serverClientId: Env.googleServerClientId,
      // iOS client ID — only needed on iOS without GoogleService-Info.plist
      // clientId: const String.fromEnvironment('GOOGLE_IOS_CLIENT_ID'),
      clientId: Platform.isAndroid
          ? Env.googleServerClientId
          : Env.googleIosClientId,
    );
    _initialized = true;

    // Attempt silent sign-in for returning users (no UI shown)
    _instance.attemptLightweightAuthentication();
  }

  @override
  Future<SocialAuthCredential?> signIn() async {
    assert(_initialized, 'Call initialize() before signIn()');

    try {
      // v7: authenticate() replaces the old signIn()
      // Returns GoogleSignInAccount or throws GoogleSignInException
      final GoogleSignInAccount account = await _instance.authenticate();

      // Step 1 — get the idToken (for backend verification)
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw Exception(
          'Google Sign-In: idToken is null. '
          'Ensure serverClientId is set correctly.',
        );
      }

      // Step 2 — get the accessToken via authorizationClient (separate step in v7)
      final scopes = <String>['email', 'profile'];

      // Try silent authorization first
      GoogleSignInClientAuthorization? authorization = await account
          .authorizationClient
          .authorizationForScopes(scopes);

      // If not previously authorized, request interactively
      authorization ??= await account.authorizationClient.authorizeScopes(
        scopes,
      );

      return SocialAuthCredential(
        providerId: idToken,
        accessToken: authorization.accessToken,
        name: account.displayName,
        email: account.email,
        provider: OAuthProvider.google,
      );
    } on GoogleSignInException catch (e) {
      // v7: cancellation is an exception, not a null return
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null; // user dismissed — treat as cancellation
      }
      rethrow; // network error, config error, etc.
    }
  }

  @override
  Future<void> signOut() => _instance.disconnect();
}
