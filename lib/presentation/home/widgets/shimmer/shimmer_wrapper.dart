import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Wraps any skeleton widget with the shimmer sweep.
/// All children share the same gradient phase — looks cohesive.
class ShimmerWrapper extends StatelessWidget {
  final Widget child;

  const ShimmerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}
