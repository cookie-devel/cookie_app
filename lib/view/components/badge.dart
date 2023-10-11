import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as badges;

class BadgedIcon extends StatelessWidget {
  final IconData icon;
  final String? label;
  final double? size;

  const BadgedIcon({super.key, required this.icon, this.label, this.size});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      showBadge: label != null,
      position: badges.BadgePosition.topEnd(top: -14, end: -14),
      badgeContent: Text(
        label ?? '',
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      child: Icon(icon, size: size),
    );
  }
}
