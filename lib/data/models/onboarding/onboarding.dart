// Data model
class OnboardingData {
  final String title;
  final String description;
  final String imagePrompt; // for generation reference

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePrompt,
  });
}
