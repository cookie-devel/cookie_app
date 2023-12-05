import 'package:cookie_app/theme/default.dart';
import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24.0),
          CupertinoActivityIndicator(
            animating: true,
            color: DefaultColor.colorMainBrown,
            radius: 35,
          ),
          const SizedBox(height: 16.0),
          Text(
            "Loading",
            style: TextStyle(
              color: DefaultColor.colorMainBrown,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
