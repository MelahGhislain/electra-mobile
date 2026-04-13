import 'package:electra/common/widgets/buttons/main_button.dart';
import 'package:electra/common/widgets/buttons/main_text_button.dart';
import 'package:electra/core/assets/app_images.dart';
import 'package:electra/core/configs/fonts.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/domain/entities/user/language.dart';
import 'package:electra/presentation/onboading/widgets/language_bottomsheet.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Language language = languages.first;

  void _openLanguageSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      /// 👇 THIS controls max height
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: LanguageBottomSheet(
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: MainTextButton(text: 'Skip', onPressed: () {
                  // TODO: Navigate to next screen or skip
                })
              ),

              const SizedBox(height: 40),

              // SNAP DEMO SECTION (camera frame + generated image)
              SizedBox(
                height: 320,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      AppImages.voice,
                      fit: BoxFit.contain,
                      width: 280,
                      height: 280,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Title
              Text(
                'Where Did My Money Go?',
                style: TextStyle(
                  fontSize: AppFontSize.xxxl,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lightText,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Description

              Text(
                'Electra shows you exactly where it goes. Stop guessing. Start knowing.',
                style: TextStyle(
                  fontSize: AppFontSize.xl,
                  color: AppColors.lightTextSecondary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Main CTA Button with bounce effect
              MainButton(
                text: language.code.toUpperCase(),
                width: 100,
                rounded: true,
                isActive: false,
                size: ButtonSize.small,
                icon: Text(language.flag, style: const TextStyle(fontSize: 20)),
                onPressed: _openLanguageSheet,
              ),

              const SizedBox(height: 16),

              MainButton(
                text: "Get Started",
                size: ButtonSize.large,
                onPressed: () {
                  // For now: show feedback. Later you can navigate to home or next onboarding
                  // context.goNamed('home'); // or your actual route name
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:electra/common/widgets/buttons/main_button.dart';
// import 'package:electra/core/assets/app_images.dart';
// import 'package:electra/core/configs/fonts.dart';
// import 'package:electra/core/configs/theme/app_colors.dart';
// import 'package:flutter/material.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int currentPage = 0;

//   final List<_OnboardingPage> _pages = [
//     _OnboardingPage(
//       image: AppImages.voice,
//       title: "Snap receipts instantly",
//       subtitle: "Discover effortless expense tracking",
//       description: "Photo of a receipt — Electra reads every line and auto-categorizes each expense in seconds.",
//     ),
//     _OnboardingPage(
//       image: AppImages.voice,
//       title: "Clear spending insights",
//       subtitle: "See where your money goes at a glance",
//       description: "Monthly summaries, category breakdowns, and smart trends — all built automatically from your data.",
//     ),
//     _OnboardingPage(
//       image: AppImages.voice,
//       title: "Your AI spending copilot",
//       subtitle: "Ask anything about your finances",
//       description: "Questions like \"How much did I spend on food last month?\" get instant answers in plain language.",
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Top logo
//             Padding(
//               padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Electra",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.lightText,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),

//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 onPageChanged: (value) => setState(() => currentPage = value),
//                 itemCount: _pages.length,
//                 itemBuilder: (context, index) => _pages[index].build(context),
//               ),
//             ),

//             // Page indicators
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 _pages.length,
//                 (index) => AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   width: currentPage == index ? 28 : 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: currentPage == index
//                         ? AppColors.primary
//                         : AppColors.lightTextSecondary.withValues(alpha: 0.3),
//                     borderRadius: BorderRadius.circular(999),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 10),

//             // Next button (matches mobilanc style)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: MainButton(
//                 text: "Next",
//                 onPressed: () {
//                   if (currentPage < _pages.length - 1) {
//                     _pageController.nextPage(
//                       duration: const Duration(milliseconds: 450),
//                       curve: Curves.easeInOut,
//                     );
//                   } else {
//                     // TODO: Navigate to account setup or home
//                     // context.goNamed(RouteNames.accountSetup);
//                   }
//                 },
//               ),
//             ),

//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _OnboardingPage {
//   final String image;
//   final String title;
//   final String subtitle;
//   final String description;

//   _OnboardingPage({
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.description,
//   });

//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Column(
//         children: [
//           const SizedBox(height: 20),

//           // Hero image with premium shadow + overlap effect
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.12),
//                   blurRadius: 30,
//                   offset: const Offset(0, 15),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(24),
//               child: Image.asset(
//                 image,
//                 fit: BoxFit.contain,
//                 height: 380,
//               ),
//             ),
//           ),

//           const SizedBox(height: 50),

//           Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: AppFontSize.xxxl,
//               fontWeight: FontWeight.w800,
//               color: AppColors.lightText,
//               height: 1.05,
//             ),
//             textAlign: TextAlign.center,
//           ),

//           const SizedBox(height: 12),

//           Text(
//             title,
//             style: TextStyle(
//               fontSize: AppFontSize.lg,
//               fontWeight: FontWeight.w600,
//               color: AppColors.primary,
//             ),
//             textAlign: TextAlign.center,
//           ),

//           const SizedBox(height: 20),

//           Text(
//             description,
//             style: TextStyle(
//               fontSize: AppFontSize.md,
//               color: AppColors.lightTextSecondary,
//               height: 1.4,
//             ),
//             textAlign: TextAlign.center,
//           ),

//           const Spacer(),
//         ],
//       ),
//     );
//   }
// }
