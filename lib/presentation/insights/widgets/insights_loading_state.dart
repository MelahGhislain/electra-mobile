import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class InsightsLoadingState extends StatelessWidget {
  const InsightsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.darkBackground,
        strokeWidth: 2.5,
      ),
    );
  }
}
