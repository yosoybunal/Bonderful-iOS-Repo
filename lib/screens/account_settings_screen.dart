import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herkese_sor/main.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final String? email = FirebaseAuth.instance.currentUser!.email;
    final Color itemsColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? Theme.of(context).colorScheme.inversePrimary
        : Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo_png_version.png',
                  scale: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  icon: Icon(
                    CupertinoIcons.mail_solid,
                    size: 22,
                    color: itemsColor,
                  ),
                  label: Text(
                    email!,
                    textScaleFactor: 1.2,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: itemsColor,
                        ),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  icon: Icon(
                    CupertinoIcons.exclamationmark_circle_fill,
                    size: 22,
                    color: itemsColor,
                  ),
                  label: Text(
                    'Send Reset Password to Email',
                    textScaleFactor: 1.2,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: itemsColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        duration: const Duration(seconds: 2),
                        content:
                            const Text('Password reset email has been sent!'),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  icon: Icon(
                    CupertinoIcons.chat_bubble_text,
                    size: 22,
                    color: itemsColor,
                  ),
                  label: Text(
                    'Share Suggestions',
                    textScaleFactor: 1.2,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: itemsColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
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
                const SizedBox(
                  height: 25,
                ),
                TextButton.icon(
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: kColorScheme.inversePrimary,
                  ),
                  label: Text(
                    'Delete Your Account',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: const Color.fromARGB(167, 244, 67, 54)),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.currentUser!.delete().then(
                      (value) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            duration: const Duration(seconds: 2),
                            content:
                                const Text('The account has been deleted!'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
