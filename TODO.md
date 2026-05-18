  ```dart
  Future<void> onLoginSuccess() async {
    // TODO: Uncomment and test this once notification is ready to be done
    // await _fcmService.init();
    emit(const AppAuthState.authenticated());
  }
```
