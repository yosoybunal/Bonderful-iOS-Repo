import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:herkese_sor/dummy_data/data.dart';
import 'package:herkese_sor/models/category.dart';
import 'package:herkese_sor/screens/how_to_play_screen.dart';
import 'package:herkese_sor/screens/questions_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:herkese_sor/main.dart';
import 'package:herkese_sor/screens/account_settings_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final Uri urlInstagram =
        Uri.parse('https://www.instagram.com/bonderfulapp/'); //Instagram

    Future<void> launchUrlInstagram() async {
      if (!await launchUrl(urlInstagram)) {
        throw Exception('Could not launch $urlInstagram');
      }
    }

    final Uri urlTwitter =
        Uri.parse('https://twitter.com/bonderfulapp'); //Twitter

    Future<void> launchUrlTwitter() async {
      if (!await launchUrl(urlTwitter)) {
        throw Exception('Could not launch $urlTwitter');
      }
    }

    final Color drawerItemsColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? Theme.of(context).colorScheme.background
        : Theme.of(context).colorScheme.onBackground;

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Image.asset(
                'assets/images/bonderful_sole.png',
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.shuffle,
                size: 22,
                color: drawerItemsColor,
              ),
              title: Text(
                'Shuffle',
                textScaleFactor: 1.2,
                style: TextStyle(color: drawerItemsColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuestionsScreen(
                        category: Category(
                          id: 'c1',
                          title: 'Deep Talks',
                          color: Colors.purple,
                          iconSmall: Image.asset('assets/images/shuffle.png'),
                        ),
                        questions: dummyQuestions,
                        title: 'Shuffled Questions'),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.lightbulb,
                size: 22,
                color: drawerItemsColor,
              ),
              title: Text(
                'How to Play',
                textScaleFactor: 1.2,
                style: TextStyle(color: drawerItemsColor),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HowToPlayScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.text_bubble,
                size: 22,
                color: drawerItemsColor,
              ),
              title: Text(
                'Share Suggestions',
                textScaleFactor: 1.2,
                style: TextStyle(color: drawerItemsColor),
              ),
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'bonderfulapp@gmail.com',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Share your question ideas of any category!',
                    'body': ''
                  }),
                );
                if (await canLaunchUrl(emailLaunchUri)) {
                  launchUrl(emailLaunchUri);
                } else {
                  throw Exception(
                    'Could not launch $emailLaunchUri',
                  );
                }
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.instagram,
                size: 22,
                color: drawerItemsColor,
              ),
              title: Text(
                'Instagram',
                textScaleFactor: 1.2,
                style: TextStyle(color: drawerItemsColor),
              ),
              onTap: launchUrlInstagram,
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.twitter,
                size: 22,
                color: drawerItemsColor,
              ),
              title: Text(
                'Twitter',
                textScaleFactor: 1.2,
                style: TextStyle(color: drawerItemsColor),
              ),
              onTap: launchUrlTwitter,
            ),
            ListTile(
              leading: FaIcon(
                CupertinoIcons.brightness_solid,
                size: 22,
                color: drawerItemsColor,
              ),
              title: Text(
                'Switch Theme',
                textScaleFactor: 1.2,
                style: TextStyle(color: drawerItemsColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                MyApp.themeNotifier.value =
                    MyApp.themeNotifier.value == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
              },
            ),
            ListTile(
              leading: FaIcon(
                CupertinoIcons.person_crop_circle,
                size: 22,
                color: drawerItemsColor,
              ),
              title: Text(
                'Account Settings',
                textScaleFactor: 1.2,
                style: TextStyle(color: drawerItemsColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AccountSettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
