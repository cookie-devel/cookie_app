import 'package:flutter/material.dart';

class CookieDecoratedContainer extends StatelessWidget {
  final List<Widget> child;
  const CookieDecoratedContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(0.5, 0.5),
          ),
        ],
      ),
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: child,
      ),
    );
  }
}
