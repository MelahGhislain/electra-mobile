import 'package:flutter/material.dart';

/// Renders [text] with any word/phrase in [highlights] coloured [highlightColor].
/// Matching is case-insensitive. Non-highlighted text uses [baseStyle].
class HighlightedTitle extends StatelessWidget {
  final String text;
  final List<String> highlights;
  final TextStyle baseStyle;
  final Color highlightColor;

  const HighlightedTitle({
    super.key,
    required this.text,
    required this.highlights,
    required this.baseStyle,
    this.highlightColor = const Color(0xFF22C55E), // green accent
  });

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) {
      return Text(text, style: baseStyle);
    }

    // Build a regex that matches any of the highlight phrases (case-insensitive).
    final pattern = highlights.map((h) => RegExp.escape(h)).join('|');
    final regex = RegExp('($pattern)', caseSensitive: false);

    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Normal text before this match
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      // Highlighted match
      spans.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(color: highlightColor),
        ),
      );
      lastEnd = match.end;
    }

    // Remaining normal text
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(style: baseStyle, children: spans),
    );
  }
}
