// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herkese_sor/dummy_data/data.dart';
import 'package:herkese_sor/models/purchase_api.dart';
import 'package:herkese_sor/screens/auth_screen.dart';
import 'package:herkese_sor/screens/questions_screen.dart';
import 'package:herkese_sor/widgets/category_grid_item.dart';
import 'package:herkese_sor/models/category.dart';
import 'package:herkese_sor/widgets/main_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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

    Purchases.addCustomerInfoUpdateListener(
        (customerInfo) => updateCustomerStatus());
    updateCustomerStatus();
  }

  Future updateCustomerStatus() async {
    final customerInfo = await Purchases.getCustomerInfo();

    setState(() {
      final entitlement = customerInfo.entitlements.active['Truth or Dare'];
      isSubForTruth = entitlement != null;
    });

    setState(() {
      final entitlement =
          customerInfo.entitlements.active['Who is most likely'];
      isSubForMost = entitlement != null;
    });

    setState(() {
      final entitlement = customerInfo.entitlements.active['Would you rather?'];
      isSubForRather = entitlement != null;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) async {
    // final customerInfo = await Purchases.getCustomerInfo();
    Offerings offerings = await Purchases.getOfferings();

    Package? packageForMost =
        offerings.getOffering("Who is most likely")!.lifetime;

    Package? packageForTruth = offerings.getOffering("Truth or Dare")!.lifetime;

    Package? packageForRather =
        offerings.getOffering("Would you rather?")!.lifetime;

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
      showCupertinoModalPopup<int>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Title'),
          message: const Text('Message'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: Text(
                isSubForMost ? 'kilitsiz' : 'Continue',
                style: const TextStyle(color: CupertinoColors.link),
              ),
              onPressed: () async {
                try {
                  if (category.id == 'c3' && isSubForMost == false) {
                    await Purchases.purchasePackage(packageForMost!);
                    // await Purchases.purchaseStoreProduct(
                    //   const StoreProduct(
                    //     'bonderful_1.99_mostlikely',
                    //     'Purchase will unlock this category',
                    //     'Who is most likely',
                    //     1.99,
                    //     'onenintynine',
                    //     'USD',
                    //   ),
                    // );
                    updateCustomerStatus();
                  }
                } catch (e) {
                  debugPrint('Failed to purchase category!');
                }
                try {
                  if (category.id == 'c4' && isSubForTruth == false) {
                    // await Purchases.purchasePackage(packageForTruth!);
                    await Purchases.purchaseStoreProduct(
                      const StoreProduct(
                        'bonderful_1.99_truth',
                        'Purchase will unlock this category',
                        'Truth or Dare',
                        1.99,
                        'onenintynine',
                        'USD',
                      ),
                    );
                  }
                } catch (e) {
                  debugPrint('Failed to purchase category!');
                }
                try {
                  if (category.id == 'c11' && isSubForRather == false) {
                    await Purchases.purchasePackage(packageForRather!);
                  }
                } catch (e) {
                  debugPrint('Failed to purchase category!');
                }
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Cancel',
                  style: TextStyle(color: CupertinoColors.destructiveRed)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick a Category',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
        actions: [
          IconButton(
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
