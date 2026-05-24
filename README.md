# minata

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# How to change it properly (IMPORTANT)
flutter pub run change_app_package_name:main com.melah.expensetracker




# OCR image processing flow

Flutter App
   ↓
Take Receipt Photo
   ↓
OCR (extract raw text)
   ↓
Send text to Gemini Flash
   ↓
Gemini returns structured JSON
   ↓
Validate JSON
   ↓
Save to backend/database

```dart
import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptOcrService {
  final _textRecognizer = TextRecognizer();

  Future<String> extractText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);

    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    return recognizedText.text;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
```


```dart
flutter emulators --launch Medium_Phone_API_36.1
```

### App Names
- Minata