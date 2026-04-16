import 'package:electra/data/models/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

enum OnboardingPageType { content, custom }

class OnboardingPage {
  final OnboardingPageType type;
  final OnboardingData? data;
  final Widget? customWidget;

  OnboardingPage.content(this.data)
      : type = OnboardingPageType.content,
        customWidget = null;

  OnboardingPage.custom(this.customWidget)
      : type = OnboardingPageType.custom,
        data = null;
}
