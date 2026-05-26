  ```dart
  Future<void> onLoginSuccess() async {
    // TODO: Uncomment and test this once notification is ready to be done
    // await _fcmService.init();
    emit(const AppAuthState.authenticated());
  }
```

- After deleting a purchase it is not refreshing the purchases (Check for the entire CRUD operation including deleting the Items)
- Fix the toast messages themes especially dark mode
- Fix the Google auth on android
- Fix the onboarding screens
- 



#### Improvements
- able to update/delete a purchase by sliding the list tile and clicking on the update/delete icon buttons