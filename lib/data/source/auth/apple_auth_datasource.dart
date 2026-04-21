import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:electra/domain/entities/auth/social_auth_credential.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AppleAuthDataSource {
  Future<SocialAuthCredential?> signIn();
}

class AppleAuthDataSourceImpl implements AppleAuthDataSource {
  @override
  Future<SocialAuthCredential?> signIn() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256Nonce(rawNonce);

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw Exception('Apple Sign-In: identityToken is null');
    }

    // Apple only provides name on the very first sign-in
    final fullName = [
      credential.givenName,
      credential.familyName,
    ].where((e) => e != null && e.isNotEmpty).join(' ');

    return SocialAuthCredential(
      providerId: idToken,
      name: fullName.isEmpty ? null : fullName,
      email: credential.email,
      provider: OAuthProvider.apple,
    );
  }

  /// Generates a cryptographically secure random nonce
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Returns the SHA-256 hash of the nonce
  String _sha256Nonce(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
