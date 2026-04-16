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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. HomeHeader - scrolls off screen
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: HomeHeader(name: "Ghislain", date: "October 14, 2025"),
              ),
            ),

            // 2. MonthlySnapshotCard - Pinned at the top
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SnapshotHeaderDelegate(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: MonthlySnapshotCard(
                      spent: 540,
                      budget: 1000,
                      avgDaily: 22,
                      progress: 0.54,
                      onViewAllPressed: () {},
                    ),
                  ),
                ),
              ),
            ),

            // 3. Recently Completed - scrolls normally
            SliverToBoxAdapter(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Delegate for pinned MonthlySnapshotCard
class _SnapshotHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SnapshotHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 245; // Adjust based on your MonthlySnapshotCard height

  @override
  double get minExtent => 240;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
