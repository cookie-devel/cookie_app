import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// text 클립보드에 복사
class LongPressCopyableText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const LongPressCopyableText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('클립보드에 복사'),
            duration: Duration(milliseconds: 300),
          ),
        );
      },
      child: Text(text, style: style),
    );
  }
}
