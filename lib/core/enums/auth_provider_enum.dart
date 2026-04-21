enum AuthProviderEnum {
  email('email'),
  google('google'),
  apple('apple');

  final String value;

  const AuthProviderEnum(this.value);
}
