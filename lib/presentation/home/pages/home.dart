import 'package:electra/common/widgets/popups/blurred_popup.dart';
import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/presentation/auth/widgets/sign_in_form.dart';
import 'package:electra/presentation/home/model/task.dart';
import 'package:electra/presentation/home/widgets/home_header.dart';
import 'package:electra/presentation/home/widgets/monthly_snapshot_card.dart';
import 'package:electra/presentation/home/widgets/recently_completed.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_cubit.dart';
import 'package:electra/presentation/purchase/blocs/purchase/purchase_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch once — cubit caches the result for the session
    context.read<PurchaseCubit>().loadPurchases();
  }

  void _showSignInPopup() {
    BlurredPopup.show(context, child: const SignInForm());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseCubit, PurchaseState>(
      listener: (context, state) {
        // Single routing decision point — no duplication anywhere
        if (state is PurchaseLoaded && state.isEmpty) {
          context.goNamed(RouteNames.expenseRecorder);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // 1. HomeHeader - scrolls off screen
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: HomeHeader(
                      name: "Ghislain",
                      date: "October 14, 2025",
                    ),
                  ),
                ),

                // 2. MonthlySnapshotCard - Pinned at the top
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: _SnapshotHeaderDelegate(
                    child: Container(
                      color: AppColors.lightBackground,
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
                        subtitle:
                            "Prepare a slide deck for tomorrow's meeting...",
                        completedAt: DateTime(2025, 1, 5, 10, 0),
                      ),
                      Task(
                        title: "Client Feedback Review",
                        subtitle: "Review comments and update design assets",
                        completedAt: DateTime(2025, 1, 5, 9, 30),
                      ),
                      Task(
                        title: "Design Team Presentation",
                        subtitle:
                            "Prepare a slide deck for tomorrow's meeting...",
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
                        subtitle:
                            "Prepare a slide deck for tomorrow's meeting...",
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
      },
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
