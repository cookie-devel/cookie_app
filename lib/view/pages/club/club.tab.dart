import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('클럽')),
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
