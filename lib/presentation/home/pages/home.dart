// import 'package:electra/common/widgets/nav/custom_bottom_nav.dart';
// import 'package:electra/core/configs/theme/app_colors.dart';
// import 'package:electra/presentation/home/model/task.dart';
// import 'package:electra/presentation/home/widgets/home_header.dart';
// import 'package:electra/presentation/home/widgets/monthly_snapshot_card.dart';
// import 'package:electra/presentation/home/widgets/recently_completed.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 2; // Camera is default selected

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightBackground,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 90), // Prevents overlap with bottom nav
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               HomeHeader(
//                 name: "Ghislain",
//                 date: "October 14, 2025",
//               ),

//               const SizedBox(height: 18),

//               // Monthly Snapshot Card
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: MonthlySnapshotCard(
//                   spent: 540,
//                   budget: 1000,
//                   avgDaily: 22,
//                   progress: 0.54,
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Recently Completed - Horizontally Scrollable
//               RecentlyCompleted(
//                 tasks: [
//                   Task(
//                     title: "Design Team Presentation",
//                     subtitle: "Prepare a slide deck for tomorrow's meeting with the design team...",
//                     completedAt: DateTime(2025, 1, 5, 10, 0),
//                   ),
//                   // Task(
//                   //   title: "Client Feedback Review",
//                   //   subtitle: "Prepare a slide deck for tomorrow's meeting with the design team...",
//                   //   completedAt: DateTime(2025, 1, 5, 9, 30),
//                   // ),
//                   // Task(
//                   //   title: "Budget Planning",
//                   //   subtitle: "Review monthly expenses and adjust categories...",
//                   //   completedAt: DateTime(2025, 1, 4, 14, 15),
//                   // ),
//                 ],
//                 onViewAllPressed: () {
//                   // Navigate to full completed tasks list
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("View All Completed Tasks")),
//                   );
//                 },
//               ),
            
//             ],
//           ),
//         ),
//       ),

//       // Global Bottom Navigation
//       extendBody: true,
//       bottomNavigationBar: SafeArea(
//         minimum: const EdgeInsets.only(bottom: 16), // 👈 space from bottom
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: CustomBottomNav(
//             currentIndex: _currentIndex,
//             onIndexChanged: (index) {
//               setState(() => _currentIndex = index);

//               if (index != 2) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Navigating to index: $index")),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:electra/common/widgets/nav/custom_bottom_nav.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/home/model/task.dart';
import 'package:electra/presentation/home/widgets/home_header.dart';
import 'package:electra/presentation/home/widgets/monthly_snapshot_card.dart';
import 'package:electra/presentation/home/widgets/recently_completed.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Top Part (Header + Snapshot)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                children: [
                  HomeHeader(name: "Ghislain", date: "October 14, 2025"),
                  const SizedBox(height: 18),
                  const MonthlySnapshotCard(
                    spent: 540,
                    budget: 1000,
                    avgDaily: 22,
                    progress: 0.54,
                  ),
                ],
              ),
            ),

            // Scrollable Recently Completed
            Expanded(
              child: RecentlyCompleted(
                tasks: [
                  Task(
                    title: "Design Team Presentation",
                    subtitle: "Prepare a slide deck for tomorrow's meeting...",
                    completedAt: DateTime(2025, 1, 5, 10, 0),
                  ),
                  Task(
                    title: "Client Feedback Review",
                    subtitle: "Review comments and update design assets",
                    completedAt: DateTime(2025, 1, 5, 9, 30),
                  ),
                  Task(
                    title: "Design Team Presentation",
                    subtitle: "Prepare a slide deck for tomorrow's meeting...",
                    completedAt: DateTime(2025, 1, 5, 10, 0),
                  ),
                  Task(
                    title: "Client Feedback Review",
                    subtitle: "Review comments and update design assets",
                    completedAt: DateTime(2025, 1, 5, 9, 30),
                  ),
                ],
                onViewAllPressed: () {},
              ),
            ),
          ],
        ),
      ),

      extendBody: true,
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: true,
        // minimum: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // child: CustomBottomNav(
          //   currentIndex: _currentIndex,
          //   onIndexChanged: (index) => setState(() => _currentIndex = index),
          // ),
        ),
      ),
    );
  }
}
