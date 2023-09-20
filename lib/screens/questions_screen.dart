import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herkese_sor/models/category.dart';

import 'package:herkese_sor/models/question.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:herkese_sor/screens/tabs_screen.dart';
import 'package:herkese_sor/widgets/question_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

var parser = EmojiParser();

class QuestionsScreen extends ConsumerStatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.questions,
    required this.title,
    required this.category,
  });

  final Category category;
  final String title;
  final List<Question> questions;

  @override
  ConsumerState<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends ConsumerState<QuestionsScreen> {
  int currentQuestionIndex = 0;
  void _nextQuestion() {
    setState(() {
      currentQuestionIndex++;
    });
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final categoryQuestions = widget.questions;
    var currentQuestion = categoryQuestions[currentQuestionIndex];

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Future<void> updateArrayFields(
        String arrayField, String itemToRemove, String itemToAdd) async {
      final user = FirebaseAuth.instance.currentUser!;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      List currentQuestionArray = snapshot.data()?['listQuestions'] ?? [];
      List currentIntensityArray = snapshot.data()?['listIntensities'] ?? [];

      if (currentQuestionArray.contains(currentQuestion.question)) {
        currentQuestionArray.remove(currentQuestion.question);
        currentIntensityArray.remove(
          currentQuestion.intensity.name[0].toUpperCase() +
              currentQuestion.intensity.name.substring(1),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'listQuestions': currentQuestionArray,
          'listIntensities': currentIntensityArray,
        });
      } else {
        currentQuestionArray.add(currentQuestion.question);
        currentIntensityArray.add(
          currentQuestion.intensity.name[0].toUpperCase() +
              currentQuestion.intensity.name.substring(1),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'listQuestions': currentQuestionArray,
          'listIntensities': currentIntensityArray,
        });
      }
    }

    final userd = FirebaseAuth.instance.currentUser!;

    Widget favIcon = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userd.uid)
          .snapshots(),
      builder: (context, snapshot) {
        List listRef = snapshot.data?.data()?['listQuestions'] ?? [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Unexpected error! Please try again.'),
          );
        }

        if (listRef.isEmpty) {
          return Icon(
            CupertinoIcons.heart,
            size: 42,
            color: Theme.of(context).colorScheme.inversePrimary,
          );
        }

        if (listRef.contains(currentQuestion.question)) {
          return Icon(
            CupertinoIcons.heart_fill,
            size: 42,
            color: Theme.of(context).colorScheme.inversePrimary,
          );
        }
        return Icon(
          CupertinoIcons.heart,
          size: 42,
          color: Theme.of(context).colorScheme.inversePrimary,
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: width < 600 || height > 700
          ? CustomSlideAnimation(
              key: UniqueKey(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                    bottom: 30,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        categoryQuestions.length - 1 != currentQuestionIndex
                            ? widget.category.iconSmall
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Text(
                                  parser.emojify('Last One :heart:'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: Text(
                              currentQuestion.question,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          currentQuestion.intensity.name[0].toUpperCase() +
                              currentQuestion.intensity.name.substring(1),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                updateArrayFields(
                                    'listQuestion',
                                    currentQuestion.question,
                                    currentQuestion.question);
                              },
                              icon: favIcon,
                            ),
                            IconButton(
                              onPressed: () {
                                Share.share(
                                  '${currentQuestion.question} @BonderfulApp',
                                );
                              },
                              icon: Icon(
                                CupertinoIcons.bubble_left_bubble_right,
                                size: 32,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        categoryQuestions.length - 1 != currentQuestionIndex
                            ? IconButton.filled(
                                onPressed: _nextQuestion,
                                icon: const Icon(
                                  CupertinoIcons.arrow_right_circle_fill,
                                ),
                                iconSize: 32,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 5.0,
                                    ),
                                    elevation: kFloatingActionButtonMargin,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        parser.emojify(
                                            'Sorry! This is the last question in this category for the time being. If you have any question ideas for this category please click on Send Suggestions and we can add that question with referrence to your username :crown:'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                          onPressed: () async {
                                            final Uri emailLaunchUri = Uri(
                                              scheme: 'mailto',
                                              path: 'bonderfulapp@gmail.com',
                                              query:
                                                  encodeQueryParameters(<String,
                                                      String>{
                                                'subject':
                                                    'Share your question ideas of any category!',
                                                'body': ''
                                              }),
                                            );
                                            if (await canLaunchUrl(
                                                emailLaunchUri)) {
                                              launchUrl(emailLaunchUri);
                                            } else {
                                              throw Exception(
                                                'Could not launch $emailLaunchUri',
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                              CupertinoIcons.lightbulb),
                                          label: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            child: Text('Send Suggestions'),
                                          )),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const TabsScreen(),
                                            ),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: Text('Back to Categories'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 75,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        child: Text(
                          currentQuestion.question,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        currentQuestion.intensity.name[0].toUpperCase() +
                            currentQuestion.intensity.name.substring(1),
                        style:
                            Theme.of(context).textTheme.titleSmall!.copyWith(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              updateArrayFields(
                                  'listQuestion',
                                  currentQuestion.question,
                                  currentQuestion.question);
                            },
                            icon: favIcon,
                          ),
                          IconButton(
                            onPressed: () {
                              Share.share(
                                '${currentQuestion.question} @BonderfulApp',
                              );
                            },
                            icon: Icon(
                              CupertinoIcons.bubble_left_bubble_right,
                              size: 40,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      categoryQuestions.length - 1 != currentQuestionIndex
                          ? IconButton.filled(
                              onPressed: _nextQuestion,
                              icon: const Icon(
                                CupertinoIcons.arrow_right_circle_fill,
                              ),
                              iconSize: 30,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 60,
                                    vertical: 30,
                                  ),
                                  elevation: kFloatingActionButtonMargin,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      parser.emojify(
                                          'Sorry! This is the last question in this category for the time being. If you have any question ideas for this category please click on Send Suggestions and we can add that question with referrence to your username :crown:'),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 200,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          final Uri emailLaunchUri = Uri(
                                            scheme: 'mailto',
                                            path: 'bonderfulapp@gmail.com',
                                            query:
                                                encodeQueryParameters(<String,
                                                    String>{
                                              'subject':
                                                  'Share your question ideas of any category!',
                                              'body': ''
                                            }),
                                          );
                                          if (await canLaunchUrl(
                                              emailLaunchUri)) {
                                            launchUrl(emailLaunchUri);
                                          } else {
                                            throw Exception(
                                              'Could not launch $emailLaunchUri',
                                            );
                                          }
                                        },
                                        icon: const Icon(
                                            CupertinoIcons.text_bubble),
                                        label: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: Text('Share Suggestions'),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const TabsScreen(),
                                            ),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: Text('Back to Categories'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
