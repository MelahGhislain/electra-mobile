import 'package:electra/presentation/home/widgets/shimmer/skeleton_box.dart';
import 'package:flutter/material.dart';

class MonthlySnapshotShimmer extends StatelessWidget {
  const MonthlySnapshotShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Keep the real purple background so the card shape is visible
        // while the white skeleton boxes shimmer over it
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + title + total
          Row(
            children: [
              SkeletonBox(
                width: 44,
                height: 44,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    width: 140,
                    height: 16,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 6),
                  SkeletonBox(
                    width: 80,
                    height: 13,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SkeletonBox(
                    width: 40,
                    height: 12,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 6),
                  SkeletonBox(
                    width: 70,
                    height: 22,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Divider
          SkeletonBox(
            width: double.infinity,
            height: 1,
            borderRadius: BorderRadius.circular(1),
          ),

          const SizedBox(height: 20),

          // 3 stat columns — ITEMS | AVG PRICE | PAYMENT
          Row(
            children: [
              Expanded(child: _StatColumnSkeleton()),
              SkeletonBox(
                width: 1,
                height: 40,
                borderRadius: BorderRadius.circular(1),
              ),
              Expanded(child: _StatColumnSkeleton()),
              SkeletonBox(
                width: 1,
                height: 40,
                borderRadius: BorderRadius.circular(1),
              ),
              Expanded(child: _StatColumnSkeleton()),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumnSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonBox(
          width: 36,
          height: 22,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 6),
        SkeletonBox(
          width: 56,
          height: 11,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}
