import 'package:flutter/material.dart';
import 'package:electra/core/configs/theme/app_colors.dart';

class SpendingSearchBar extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SpendingSearchBar({
    super.key,
    this.initialValue,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<SpendingSearchBar> createState() => _SpendingSearchBarState();
}

class _SpendingSearchBarState extends State<SpendingSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 14, color: AppColors.lightText),
        decoration: InputDecoration(
          hintText: 'Search merchant, item or category...',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade400,
            size: 20,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _controller.clear();
                    widget.onClear();
                  },
                  child: Icon(
                    Icons.cancel_rounded,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
