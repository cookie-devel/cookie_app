import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class BackKey extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 8),
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }
}
