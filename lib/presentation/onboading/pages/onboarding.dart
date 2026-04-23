import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/core/utils/storage/onboarding_storage.dart';
import 'package:electra/data/models/onboarding/onboarding.dart';
import 'package:electra/domain/entities/user/language.dart';
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

  final List<OnboardingPage> _pages = [
    OnboardingPage.content(
      OnboardingData(
        title: "Where Did My Money Go?",
        description:
            "Stop guessing your spending.\nElectra helps you track every expense effortlessly.",
        imagePrompt:
            "A dramatic full-screen photo of a person looking confused at a wallet with money flying away in a modern city at dusk, cinematic lighting, snow-capped mountains in background like the reference screenshot, high resolution, realistic, winter vibe",
      ),
    ),
    OnboardingPage.content(
      OnboardingData(
        title: "Just Say It",
        description:
            "“Bought lunch for \$12”\nElectra records it instantly — no typing needed.",
        imagePrompt:
            "Close-up of a person speaking into a glowing microphone with audio waveform visualization, modern minimalist style, snowy mountain background, vibrant colors, high detail, realistic photo like the reference image",
      ),
    ),
    OnboardingPage.content(
      OnboardingData(
        title: "Snap Your Receipts",
        description:
            "Take a picture and we’ll extract items, prices, and totals automatically.",
        imagePrompt:
            "Smartphone camera scanning a receipt with AI overlay highlighting items and totals, clean modern UI elements floating, snowy landscape background, professional photography style",
      ),
    ),
    OnboardingPage.content(
      OnboardingData(
        title: "Track Your Way",
        description:
            "Type it, say it, or snap it.\nElectra organizes, categorizes, and calculates everything for you. No spreadsheets. No stress.",
        imagePrompt:
            "Person using phone with multiple expense tracking options (voice, camera, keyboard) glowing around it, beautiful winter mountain road background, dynamic composition, realistic high-quality photo",
      ),
    ),
    OnboardingPage.content(
      OnboardingData(
        title: "See Where Your Money Goes",
        description:
            "Get instant breakdowns by category, trends, and spending habits.",
        imagePrompt:
            "Beautiful pie chart and spending insights dashboard floating over a scenic snowy mountain view, elegant data visualization, premium finance app aesthetic, cinematic lighting",
      ),
    ),
    // OnboardingPage.custom(const AccountSetupScreen()),
  ];

  Future<void> _onOnboardingComplete(BuildContext context) async {
    await sl<OnboardingStorage>().markOnboardingSeen();
    if (!context.mounted) return;
    // context.goNamed(RouteNames.signIn);
    context.goNamed(RouteNames.home);
  }

  Future<void> _nextPage() async {
    if (_currentPage < _pages.length - 1) {
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
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          // PageView with full-screen images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];

              if (page.type == OnboardingPageType.content) {
                return OnboardingWidget(
                  data: page.data!,
                  currentPage: index,
                  totalPages: _pages.length,
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
                      "Skip",
                      style: TextStyle(
                        color: AppColors.lightText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Overlay Content
          ...(_pages[_currentPage].type == OnboardingPageType.content
              ? [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.42,
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
                                  child: Text(
                                    _pages[_currentPage].data!.title,
                                    style: const TextStyle(
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
                              _pages[_currentPage].data!.description,
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
                                  onPressed: _nextPage,
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
                                        _currentPage == _pages.length - 1
                                            ? "Add First Expense"
                                            : "Next",
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
              : [_pages[_currentPage].customWidget!]),
        ],
      ),
    );
  }
}
