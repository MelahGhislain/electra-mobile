import 'package:electra/core/assets/app_images.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/core/utils/storage/onboarding_storage.dart';
import 'package:electra/data/models/onboarding/onboarding.dart';
import 'package:electra/domain/entities/user/language.dart';
import 'package:electra/l10n/app_localizations.dart';
import 'package:electra/presentation/onboading/widgets/highlighted_title.dart';
import 'package:electra/presentation/onboading/widgets/language/language_selector.dart';
import 'package:electra/presentation/onboading/widgets/onboarding_page.dart';
import 'package:electra/presentation/onboading/widgets/onboarding_widget.dart';
import 'package:electra/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Language language = languages.first;

  List<OnboardingPage> _pages(AppLocalizations l) {
    return [
      OnboardingPage.content(
        OnboardingData(
          title: "Where Did My Money Go?",
          highlights: const ['My Money'],
          topPosition: 60,
          description:
              "Stop guessing your spending. Electra helps you track every expense effortlessly.",
          image: AppImages.onboarding1,
        ),
      ),
      OnboardingPage.content(
        OnboardingData(
          title: "Track with Your Voice",
          highlights: const ['Voice'],
          topPosition: 50,
          description:
              "Just speak, and we'll take care of the rest. Fast, smart and super easy.",
          image: AppImages.onboarding2,
        ),
      ),
      OnboardingPage.content(
        OnboardingData(
          title: "Auto-Categorize Expenses",
          highlights: const ['Auto-Categorize'],
          topPosition: 200,
          description:
              "Electra automatically categorizes your expenses so you can focus on what matters.",
          image: AppImages.onboarding3,
        ),
      ),
      OnboardingPage.content(
        OnboardingData(
          title: "Insights That Help You Save",
          highlights: const ['Save'],
          topPosition: 80,
          description:
              "Understand your spending patterns and make smarter financial decisions.",
          image: AppImages.onboarding4,
        ),
      ),
      OnboardingPage.content(
        OnboardingData(
          title: "Your Data is Always Safe",
          highlights: const ['Safe'],
          topPosition: 10,
          description:
              "We keep your data private and secure. Your trust is our priority.",
          image: AppImages.onboarding5,
        ),
      ),
      OnboardingPage.content(
        OnboardingData(
          title: "Save More. Stress Less.",
          highlights: const ['Save More.'],
          topPosition: 10,
          description:
              "Stay on top of your finances and build better money habits every day.",
          image: AppImages.onboarding6,
        ),
      ),
    ];
  }

  Future<void> _onOnboardingComplete(BuildContext context) async {
    await sl<OnboardingStorage>().markOnboardingSeen();
    if (!context.mounted) return;
    // context.goNamed(RouteNames.signIn);
    context.goNamed(RouteNames.home);
  }

  Future<void> _nextPage(AppLocalizations l) async {
    if (_currentPage < _pages(l).length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _onOnboardingComplete(context);
    }
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      /// 👇 THIS controls max height
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: LanguageSelector(
            selectedCode: language.code,
            onSelect: (Language lang) {
              setState(() {
                language = lang;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // PageView with full-screen images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _pages(l).length,
            itemBuilder: (context, index) {
              final page = _pages(l)[index];

              if (page.type == OnboardingPageType.content) {
                return OnboardingWidget(
                  data: page.data!,
                  currentPage: index,
                  totalPages: _pages(l).length,
                );
              } else {
                return page.customWidget!;
              }
            },
          ),

          // Top Navigation Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (hidden on first screen or always visible)
                  if (_currentPage != 0)
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.lightText,
                      ),
                      onPressed: () {
                        if (_currentPage > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.pop();
                        }
                      },
                    )
                  else
                    const SizedBox.shrink(),

                  // Skip button
                  TextButton(
                    onPressed: () =>
                        context.goNamed(RouteNames.home), // adjust route
                    child: Text(
                      l.skip,
                      style: TextStyle(
                        color: theme.textTheme.titleLarge?.color,
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Overlay Content
          ...(_pages(l)[_currentPage].type == OnboardingPageType.content
              ? [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.75),
                            Colors.black.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + Language Selector Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: HighlightedTitle(
                                    text: _pages(l)[_currentPage].data!.title,
                                    highlights: _pages(
                                      l,
                                    )[_currentPage].data!.highlights,
                                    highlightColor: const Color(
                                      0xFF22C55E,
                                    ), // green accent
                                    baseStyle: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  onPressed: _showLanguageSelector,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Description
                            Text(
                              _pages(l)[_currentPage].data!.description,
                              style: TextStyle(
                                fontSize: AppFontSize.md,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.4,
                              ),
                            ),

                            const Spacer(),

                            // Bottom Bar: @electra + Next Button
                            Row(
                              children: [
                                const Text(
                                  "@electra",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () => _nextPage(l),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.lightSurface,
                                    foregroundColor: AppColors.lightText,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _currentPage == _pages(l).length - 1
                                            ? l.letsGo
                                            : l.next,
                                        style: const TextStyle(
                                          fontSize: AppFontSize.buttonText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward, size: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              : [_pages(l)[_currentPage].customWidget!]),
        ],
      ),
    );
  }
}
