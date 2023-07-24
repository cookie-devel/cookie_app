import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  Icon? icon,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) icon,
          const SizedBox(width: 10),
          Flexible(
            child: Text(message),
          )
        ],
      ),
    ),
  );
}

showErrorSnackBar(BuildContext context, String message) {
  showSnackBar(
    context: context,
    icon: const Icon(
      Icons.error_outline,
      color: Colors.red,
    ),
    message: message,
  );
}
