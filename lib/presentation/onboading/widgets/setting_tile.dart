import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;

  const SettingTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white)),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
