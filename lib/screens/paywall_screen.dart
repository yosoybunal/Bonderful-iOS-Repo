import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herkese_sor/main.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? CupertinoColors.secondaryLabel
        : CupertinoColors.inactiveGray;

    return
        // SafeArea(
        //   child:
        Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'Pick a Category',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(200, 70),
                bottomRight: Radius.elliptical(200, 70),
              ),
              child: Container(
                width: double.infinity,
                height: 350,
                child: Image.asset(
                  'assets/images/paywall_image.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Upgrade to Premium',
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
            SizedBox(height: 16.0),
            Text(
              'Unlock exclusive features and content with our premium subscription.',
              style: CupertinoTheme.of(context).textTheme.textStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0),
            CupertinoButton.filled(
              onPressed: () {
                // Handle the purchase logic here
              },
              child: Text('Subscribe'),
            ),
          ],
        ),
      ),
    );
  }
}
