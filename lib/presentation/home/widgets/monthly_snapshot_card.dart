import 'package:flutter/material.dart';

class MonthlySnapshotCard extends StatelessWidget {
  final double spent;
  final double budget;
  final double avgDaily;
  final double progress;
  final VoidCallback onViewAllPressed;

  const MonthlySnapshotCard({
    super.key,
    required this.spent,
    required this.budget,
    required this.avgDaily,
    required this.progress,
    required this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 190,

          /// 🟢 BACKGROUND (acts as border + gradient layer)
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(
                  0xFFA5D6A7,
                ).withValues(alpha: 0.45), // top soft green
                const Color(0xFF4CAF50).withValues(alpha: 0.25),
                const Color(0xFF4CAF50).withValues(alpha: 0.12),
                const Color(
                  0xFF4CAF50,
                ).withValues(alpha: 0.20), // slight lift behind text
              ],
              stops: const [0.0, 0.4, 0.75, 1.0],
            ),
          ),

          child: Stack(
            children: [
              /// 🔤 Bottom message (part of background)
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Center(
                  child: Text(
                    "Nice work! You're staying within budget 👍",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              /// 🔲 MAIN CARD (inset → creates border effect)
              Positioned(
                top: 4,
                left: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),

                      BoxShadow(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Monthly Snapshot",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// 💰 Amount
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${spent.toInt()}",
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  "/\$${budget.toInt()}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// 📊 Progress
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 2,
                                    backgroundColor: Colors.grey.shade300,
                                    valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFF4CAF50),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${(progress * 100).toInt()}%",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Avg. daily spend: \$${avgDaily.toInt()}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently Completed',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: onViewAllPressed,
                child: const Text('View all'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
