class OnboardingData {
  final String title;
  final String description;
  final String image;
  final double topPosition;

  /// Words or phrases in [title] to render in the green accent colour.
  /// Matching is case-insensitive. e.g. ['My Money'] or ['Voice', 'Easy'].
  final List<String> highlights;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    this.topPosition = 0,
    this.highlights = const [],
  });
}
