import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:electra/presentation/home/widgets/shimmer/home_header_shimmer.dart';
import 'package:electra/presentation/home/widgets/shimmer/monthly_snapshot_shimmer.dart';
import 'package:electra/presentation/home/widgets/shimmer/purchase_list_item_shimmer.dart';
import 'package:electra/presentation/home/widgets/shimmer/shimmer_wrapper.dart';
import 'package:flutter/material.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        // Single ShimmerWrapper here — ALL skeleton children share
        // the exact same sweeping gradient phase simultaneously
        child: ShimmerWrapper(
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: HomeHeaderShimmer()),

              SliverPersistentHeader(
                pinned: true,
                delegate: _ShimmerCardDelegate(
                  child: Container(
                    color: AppColors.lightBackground,
                    child: const MonthlySnapshotShimmer(),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _sectionLabel(),
                    const PurchaseCategoryShimmer(),
                    const PurchaseItemShimmer(),
                    const PurchaseItemShimmer(),
                    const PurchaseCategoryShimmer(),
                    const PurchaseItemShimmer(),
                    const PurchaseItemShimmer(),
                    const PurchaseCategoryShimmer(),
                    const PurchaseItemShimmer(),
                    const PurchaseItemShimmer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const Spacer(),
          Container(
            width: 110,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerCardDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _ShimmerCardDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  double get maxExtent => 245;

  @override
  double get minExtent => 240;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
