import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String content;
  final void Function() onCancel;
  final void Function() onConfirm;
  const Alert({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: [
        CancelButton(onPressed: onCancel),
        ConfirmButton(onPressed: onConfirm),
      ],
    );
  }
}

class CancelButton extends StatelessWidget {
  final void Function() onPressed;
  const CancelButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
        Navigator.of(context).pop();
      },
      child: const Text(
        '취소',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final void Function() onPressed;
  const ConfirmButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
        Navigator.of(context).pop();
      },
      child: const Text('확인'),
    );
  }
}
