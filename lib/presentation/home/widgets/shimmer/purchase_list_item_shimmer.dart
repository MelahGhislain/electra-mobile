import 'package:electra/presentation/home/widgets/shimmer/skeleton_box.dart';
import 'package:flutter/material.dart';

class PurchaseCategoryShimmer extends StatelessWidget {
  const PurchaseCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const SkeletonCircle(size: 12),
          const SizedBox(width: 10),
          SkeletonBox(
            width: 100,
            height: 16,
            borderRadius: BorderRadius.circular(6),
          ),
          const Spacer(),
          SkeletonBox(
            width: 60,
            height: 14,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(width: 8),
          SkeletonBox(
            width: 16,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

class PurchaseItemShimmer extends StatelessWidget {
  const PurchaseItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 160,
                  height: 15,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 6),
                SkeletonBox(
                  width: 80,
                  height: 12,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SkeletonBox(
                width: 55,
                height: 15,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SkeletonBox(
                    width: 20,
                    height: 20,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(width: 8),
                  SkeletonBox(
                    width: 20,
                    height: 20,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
