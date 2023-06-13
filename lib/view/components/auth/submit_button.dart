import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final Future<bool?> Function() onPressed;
  final String text;
  final void Function()? onSuccess;
  final void Function()? onFailure;

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.onSuccess,
    this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepOrangeAccent,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Colors.black45, width: 2),
      ),
    ),
    onPressed: () async {
      bool? result = await onPressed();
      if (result == null) return;

      if (result) {
        if (onSuccess != null) onSuccess!();
      } else {
        if (onFailure != null) onFailure!();
      }
    },
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 19,
        color: Colors.white,
      ),
    ),
  );
  }
}
