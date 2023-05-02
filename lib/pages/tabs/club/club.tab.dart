import 'package:flutter/material.dart';
import 'package:cookie_app/pages/tabs/club/club.appbar.dart';

class ClubGrid extends StatefulWidget {
  const ClubGrid({Key? key}) : super(key: key);

  @override
  State<ClubGrid> createState() => _ClubGridState();
}

class _ClubGridState extends State<ClubGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: clubAppbar(context),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 8),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
