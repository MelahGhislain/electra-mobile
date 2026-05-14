# FCM Platform Setup Guide

## 1 — pubspec.yaml

```yaml
dependencies:
  firebase_core: ^3.x.x
  firebase_messaging: ^15.x.x
```

Run `flutter pub get` then `dart run flutterfire configure` (FlutterFire CLI)
to generate `lib/firebase_options.dart` for all platforms automatically.

---

## 2 — Android

### 2a. google-services.json
Download from Firebase Console → Project Settings → Your Android app.
Place at: `android/app/google-services.json`

### 2b. android/build.gradle (project-level)
```groovy
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.4.x'
  }
}
```

### 2c. android/app/build.gradle (app-level)
```groovy
plugins {
    id 'com.google.gms.google-services'
}
```

### 2d. AndroidManifest.xml
FCM works out of the box on Android 12 and below. For Android 13+ (API 33+),
the POST_NOTIFICATIONS permission is required. Add inside <manifest>:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

FCM also needs the Internet permission (usually already present):
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

To customise the default notification icon / colour, add inside <application>:
```xml
<meta-data
    android:name="com.google.firebase.messaging.default_notification_icon"
    android:resource="@drawable/ic_notification" />
<meta-data
    android:name="com.google.firebase.messaging.default_notification_color"
    android:resource="@color/colorAccent" />
```

No further setup needed — FCM data messages and notification messages both
work without a custom Service on modern Flutter versions.

---

## 3 — iOS

### 3a. GoogleService-Info.plist
Download from Firebase Console → Project Settings → Your iOS app.
Place at: `ios/Runner/GoogleService-Info.plist`
Add it to the Runner target in Xcode (drag & drop, tick "Copy if needed").

### 3b. Xcode — Capabilities
In Xcode → Runner → Signing & Capabilities → "+ Capability":
  ✅ Push Notifications
  ✅ Background Modes → check "Remote notifications"

### 3c. APNs Auth Key (recommended over certificates)
Firebase Console → Project Settings → Cloud Messaging → Apple app section
Upload your APNs Auth Key (.p8) with:
  - Key ID  (from Apple Developer → Keys)
  - Team ID (from Apple Developer → Membership)

FCM will handle the APNs routing for you — no server-side APNs code needed.

### 3d. AppDelegate.swift
With the Flutter Firebase plugin, nothing extra is needed in AppDelegate.
If you have a custom AppDelegate, make sure it does NOT override
`application(_:didRegisterForRemoteNotificationsWithDeviceToken:)` unless
you forward the call to `super`.

### 3e. Foreground notifications on iOS
By default iOS suppresses notification banners while the app is in the
foreground. To show them, call this once during FcmService.init():

```dart
await FirebaseMessaging.instance
    .setForegroundNotificationPresentationOptions(
  alert: true,
  badge: true,
  sound: true,
);
```

---

## 4 — Verify end-to-end

1. Run the app on a real device (simulators don't receive FCM push on iOS).
2. Check your server logs for the registered token.
3. From Firebase Console → Cloud Messaging → Send test message, paste the
   device token and send. You should see a notification arrive.