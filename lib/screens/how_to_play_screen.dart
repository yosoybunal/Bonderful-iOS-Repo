import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:herkese_sor/main.dart';
import 'package:herkese_sor/models/cards.dart';
import 'package:herkese_sor/screens/tabs_screen.dart';

class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({super.key});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  late List<Widget> cardList;

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();

    cardList = _getCardList();
  }

  List<Widget> _getCardList() {
    List<MatchCard> cards = [
      MatchCard(
        color: kColorScheme.inversePrimary,
        widget: cardPortraitView(
          'That\'s all! You can now get to know each other more and strengthen your bond. Have Bonderful time!',
          '4/4',
          CupertinoButton.filled(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const TabsScreen(),
                ),
              );
            },
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(
              'Back to Categories',
              style: TextStyle(
                color: kColorScheme.onPrimary,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      MatchCard(
        color: kColorScheme.inversePrimary,
        widget: cardPortraitView(
          'You can add any question to Your Favorites by clicking on the star icon.',
          '3/4',
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back_ios),
              Text(
                'Swipe Rigt or Left',
                style: TextStyle(
                  color: kColorScheme.onBackground,
                  fontSize: 20,
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
      MatchCard(
        color: kColorScheme.inversePrimary,
        widget: cardPortraitView(
          'You can also select Shuffle from the side menu to view questions from any category.',
          '2/4',
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back_ios),
              Text(
                'Swipe Rigt or Left',
                style: TextStyle(
                  color: kColorScheme.onBackground,
                  fontSize: 20,
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
      MatchCard(
        color: kColorScheme.inversePrimary,
        widget: cardPortraitView(
          'Select a category to see a question for everyone to answer starting from the person next to you.',
          '1/4',
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back_ios),
              Text(
                'Swipe Rigt or Left',
                style: TextStyle(
                  color: kColorScheme.onBackground,
                  fontSize: 20,
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    ];
    List<Widget> cardList = [];

    cardList.addAll(
      [
        Positioned(
          child: Card(
            elevation: 12,
            color: cards[0].color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: cards[0].widget,
          ),
        ),
        Positioned(
          child: Draggable(
            maxSimultaneousDrags: 1,
            childWhenDragging: Container(),
            feedback: Card(
              elevation: 12,
              color: cards[1].color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: cards[1].widget,
            ),
            child: Card(
              elevation: 12,
              color: cards[1].color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: cards[1].widget,
            ),
            onDragEnd: (drag) {
              _removeCard(1);
            },
          ),
        ),
        Positioned(
          child: Draggable(
            maxSimultaneousDrags: 1,
            childWhenDragging: Container(),
            feedback: Card(
              elevation: 12,
              color: cards[2].color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: cards[2].widget,
            ),
            child: Card(
              elevation: 12,
              color: cards[2].color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: cards[2].widget,
            ),
            onDragEnd: (drag) {
              _removeCard(2);
            },
          ),
        ),
        Positioned(
          child: Draggable(
            maxSimultaneousDrags: 1,
            childWhenDragging: Container(),
            feedback: Card(
              elevation: 12,
              color: cards[3].color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: cards[3].widget,
            ),
            child: Card(
              elevation: 12,
              color: cards[3].color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: cards[3].widget,
            ),
            onDragEnd: (drag) {
              _removeCard(3);
            },
          ),
        ),
      ],
    );

    return cardList;
  }

  Widget cardPortraitView(
    String text,
    String page,
    Widget test,
  ) {
    return SizedBox(
      width: 360,
      height: 720,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 100, 30, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                FontAwesomeIcons.lightbulb,
                size: 250,
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomRight: Radius.zero),
                ),
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 25,
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: kColorScheme.onBackground,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              test,
              Text(
                page,
                style: TextStyle(
                  color: kColorScheme.onBackground,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: width < 600 || height > 700
            ? SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: cardList,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kColorScheme.primary,
                        kColorScheme.inversePrimary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                FontAwesomeIcons.lightbulb,
                                size: 150,
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: kColorScheme.background,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const TabsScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Back to Categories',
                                  style: TextStyle(
                                    color: kColorScheme.background,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 30),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 25,
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    'Select a category to see a question for everyone to answer, starting from the person next to you. You can also select Shuffle from the side menu to view questions from any category. You can add questions to Your Favourites list by clicking on the star icon. Have Bonderful time!',
                                    style: TextStyle(
                                      color: kColorScheme.onBackground,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                // ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
