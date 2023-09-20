import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loading...'),
            SizedBox(height: 10),
            CupertinoActivityIndicator(
                radius: 15.0, color: CupertinoColors.activeBlue),
          ],
        ),
      ),
    );
  }
}
