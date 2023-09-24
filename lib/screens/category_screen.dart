// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herkese_sor/dummy_data/data.dart';
import 'package:herkese_sor/main.dart';
import 'package:herkese_sor/screens/auth_screen.dart';
import 'package:herkese_sor/screens/paywall_screen.dart';
import 'package:herkese_sor/screens/questions_screen.dart';
import 'package:herkese_sor/widgets/category_grid_item.dart';
import 'package:herkese_sor/models/category.dart';
import 'package:herkese_sor/widgets/main_drawer.dart';
import 'package:flutter/cupertino.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool isSubForTruth = false;
  bool isSubForMost = false;
  bool isSubForRather = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();

    // Purchases.addCustomerInfoUpdateListener(
    //     (customerInfo) => updateCustomerStatus());
    // updateCustomerStatus();
  }

  // Future updateCustomerStatus() async {
  //   final customerInfo = await Purchases.getCustomerInfo();

  //   setState(() {
  //     final entitlement = customerInfo.entitlements.active['Truth or Dare'];
  //     isSubForTruth = entitlement != null;
  //   });

  //   setState(() {
  //     final entitlement =
  //         customerInfo.entitlements.active['Who is most likely'];
  //     isSubForMost = entitlement != null;
  //   });

  //   setState(() {
  //     final entitlement = customerInfo.entitlements.active['Would you rather?'];
  //     isSubForRather = entitlement != null;
  //   });
  // }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) async {
    // Offerings offerings = await Purchases.getOfferings();

    // Package? packageForMost =
    //     offerings.getOffering("Who is most likely")!.lifetime;

    // Package? packageForTruth = offerings.getOffering("Truth or Dare")!.lifetime;

    // Package? packageForRather =
    //     offerings.getOffering("Would you rather?")!.lifetime;

    if (category.id == 'c1' ||
        category.id == 'c2' ||
        category.id == 'c5' ||
        category.id == 'c6' ||
        category.id == 'c7' ||
        category.id == 'c8' ||
        category.id == 'c9' ||
        category.id == 'c10' ||
        category.id == 'c12' ||
        category.id == 'c3' && isSubForMost == true ||
        category.id == 'c4' && isSubForTruth == true ||
        category.id == 'c11' && isSubForRather == true) {
      final filteredQuestions = dummyQuestions
          .where((question) => question.categories.contains(category.id))
          .toList();
      filteredQuestions.shuffle();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionsScreen(
            category: category,
            title: category.title,
            questions: filteredQuestions,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaywallScreen(
            category: category,
          ),
        ),
      );
      // showCupertinoModalPopup<int>(
      //   context: context,
      //   builder: (BuildContext context) => CupertinoActionSheet(
      //     title: Text(
      //       'Bonderful Idea!',
      //       style: GoogleFonts.alef(fontSize: 18)
      //           .copyWith(color: kColorScheme.inversePrimary),
      //     ),
      //     message: Text(
      //       'You will proceed to unlock this category through App Store.',
      //       style: GoogleFonts.alef(fontSize: 15),
      //     ),
      //     actions: <CupertinoActionSheetAction>[
      //       CupertinoActionSheetAction(
      //         child: const Text(
      //           'Continue',
      //           style: TextStyle(color: CupertinoColors.link),
      //         ),
      //         onPressed: () async {
      //           try {
      //             if (category.id == 'c3' && isSubForMost == false) {
      //               await Purchases.purchasePackage(packageForMost!);

      //               // updateCustomerStatus();
      //             }
      //           } catch (e) {
      //             debugPrint('Failed to purchase category!');
      //           }
      //           try {
      //             if (category.id == 'c4' && isSubForTruth == false) {
      //               await Purchases.purchasePackage(packageForTruth!);
      //             }
      //           } catch (e) {
      //             debugPrint('Failed to purchase category!');
      //           }
      //           try {
      //             if (category.id == 'c11') {
      //               await Purchases.purchasePackage(packageForRather!);
      //             }
      //           } catch (e) {
      //             debugPrint('Failed to purchase category!');
      //           }
      //         },
      //       ),
      //       CupertinoActionSheetAction(
      //         child: const Text('Go back',
      //             style: TextStyle(color: CupertinoColors.destructiveRed)),
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // );
    }
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text(
            'You\'re about to sign out.',
            style: TextStyle(
              color: CupertinoDynamicColor.withBrightness(
                  color: Colors.blueGrey, darkColor: Colors.blueGrey),
            ),
          ),
          content: const Text('Do you wish to sign out?'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                FutureBuilder(
                  future: FirebaseAuth.instance.signOut(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CupertinoActivityIndicator(
                            radius: 15.0, color: CupertinoColors.activeBlue),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Unexpected error! Please try again.'),
                      );
                    }
                    return const AuthScreen();
                  },
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final Color appBarColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? CupertinoColors.secondaryLabel
        : CupertinoColors.inactiveGray;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'Pick a Category',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).restorablePush(_dialogBuilder);
            },
            icon: Icon(
              CupertinoIcons.arrow_left_to_line,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: width < 600
          ? AnimatedBuilder(
              animation: _animationController,
              child: GridView(
                padding: const EdgeInsets.all(17),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 15,
                ),
                children: [
                  for (final category in availableCategories)
                    CategoryGridItem(
                        category: category,
                        onSelectCategory: () {
                          _selectCategory(context, category);
                        })
                ],
              ),
              builder: (context, child) => SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.4),
                  end: const Offset(0, 0),
                ).animate(
                  CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOutCubicEmphasized),
                ),
                child: child,
              ),
            )
          : AnimatedBuilder(
              animation: _animationController,
              child: GridView(
                padding: const EdgeInsets.all(17),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 13,
                  mainAxisSpacing: 15,
                ),
                children: [
                  for (final category in availableCategories)
                    CategoryGridItem(
                        category: category,
                        onSelectCategory: () {
                          _selectCategory(context, category);
                        })
                ],
              ),
              builder: (context, child) => SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.4),
                  end: const Offset(0, 0),
                ).animate(
                  CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOutCubicEmphasized),
                ),
                child: child,
              ),
            ),
    );
  }
}
