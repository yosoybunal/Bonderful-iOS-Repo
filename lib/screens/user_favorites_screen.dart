import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herkese_sor/main.dart';

final user = FirebaseAuth.instance.currentUser!;

class UserFavoritesScreen extends ConsumerStatefulWidget {
  const UserFavoritesScreen({
    super.key,
  });

  @override
  ConsumerState<UserFavoritesScreen> createState() =>
      _UserFavoritesScreenState();
}

class _UserFavoritesScreenState extends ConsumerState<UserFavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final Color appBarColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? CupertinoColors.secondaryLabel
        : CupertinoColors.inactiveGray;

    final Color questionColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? Theme.of(context).colorScheme.background
        : Theme.of(context).colorScheme.secondary;

    final Color intensityColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? Theme.of(context).colorScheme.inversePrimary
        : Theme.of(context).colorScheme.tertiary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Your Favorites'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          List questionsRef = snapshot.data?.data()?['listQuestions'] ?? [];
          List intensitiesRef = snapshot.data?.data()?['listIntensities'] ?? [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (questionsRef.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Uh... nothing here!',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Text(
                      'Start creating your list of favorites.',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'There seems to be someting wrong! Please try again.',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: questionsRef.length,
                itemBuilder: (ctx, index) => Dismissible(
                  confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog.adaptive(
                          title: const Text(
                            'The question will be deleted!',
                            style: TextStyle(
                              color: CupertinoDynamicColor.withBrightness(
                                  color: Colors.blueGrey,
                                  darkColor: Colors.blueGrey),
                            ),
                          ),
                          content: const Text(
                            'Are you sure you wish to delete this one?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: CupertinoColors.activeBlue,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: CupertinoColors.destructiveRed,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: const Color.fromARGB(90, 209, 162, 159),
                  ),
                  key: ValueKey(questionsRef[index]),
                  onDismissed: (direction) async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        duration: const Duration(seconds: 2),
                        content: const Text('Question has been removed!'),
                      ),
                    );

                    questionsRef.remove(questionsRef[index]);
                    intensitiesRef.remove(intensitiesRef[index]);
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .update({
                      'listQuestions': questionsRef,
                      'listIntensities': intensitiesRef,
                    });
                  },
                  child: ListTile(
                    title: Text(
                      questionsRef[index],
                      style: TextStyle(
                        color: questionColor,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(intensitiesRef[index],
                        style: TextStyle(
                          color: intensityColor,
                          fontSize: 15,
                        )),
                    leading: Icon(
                      CupertinoIcons.question_circle,
                      color: intensityColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
