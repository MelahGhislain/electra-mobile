import 'package:electra/presentation/home/widgets/shimmer/skeleton_box.dart';
import 'package:flutter/material.dart';

class HomeHeaderShimmer extends StatelessWidget {
  const HomeHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1 — greeting + scan icon + avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(
                width: 140,
                height: 26,
                borderRadius: BorderRadius.circular(6),
              ),
              Row(
                children: [
                  SkeletonBox(
                    width: 40,
                    height: 40,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  const SizedBox(width: 8),
                  const SkeletonCircle(size: 40),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Row 2 — date
          Row(
            children: [
              SkeletonBox(
                width: 20,
                height: 20,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(width: 8),
              SkeletonBox(
                width: 160,
                height: 18,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 3 — headline (2 lines)
          SkeletonBox(
            width: 220,
            height: 34,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 6),
          SkeletonBox(
            width: 160,
            height: 34,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}
