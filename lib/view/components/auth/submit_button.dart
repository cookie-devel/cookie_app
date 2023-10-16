import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.text,
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
      onPressed: onPressed,
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
