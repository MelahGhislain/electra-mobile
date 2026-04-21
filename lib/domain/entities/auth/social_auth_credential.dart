enum OAuthProvider { google, apple }

class SocialAuthCredential {
  final String providerId;
  final String? accessToken;
  final String? name;
  final String? email;
  final OAuthProvider provider;

  const SocialAuthCredential({
    required this.providerId,
    required this.provider,
    this.accessToken,
    this.name,
    this.email,
  });
}
