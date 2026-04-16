class OnboardingSettings {
  final String currency;
  final String language;
  final bool expensesOnly;
  final double monthlyBudget;

  OnboardingSettings({
    required this.currency,
    required this.language,
    required this.expensesOnly,
    required this.monthlyBudget,
  });

  OnboardingSettings copyWith({
    String? currency,
    String? language,
    bool? expensesOnly,
    double? monthlyBudget,
  }) {
    return OnboardingSettings(
      currency: currency ?? this.currency,
      language: language ?? this.language,
      expensesOnly: expensesOnly ?? this.expensesOnly,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    );
  }
}
