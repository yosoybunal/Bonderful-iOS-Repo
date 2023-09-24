import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herkese_sor/main.dart';
import 'package:herkese_sor/models/category.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool isSubForTruth = false;
  bool isSubForMost = false;
  bool isSubForRather = false;
  var isTransaction = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Purchases.addCustomerInfoUpdateListener(
        (customerInfo) => updateCustomerStatus());
    updateCustomerStatus();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
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

  void onSelectLockedCategory() async {
    Offerings offerings = await Purchases.getOfferings();

    Package? packageForMost =
        offerings.getOffering("Who is most likely")!.lifetime;

    Package? packageForTruth = offerings.getOffering("Truth or Dare")!.lifetime;

    Package? packageForRather =
        offerings.getOffering("Would you rather?")!.lifetime;

    try {
      setState(() {
        isTransaction = true;
      });
      if (widget.category.id == 'c3' && isSubForMost == false) {
        await Purchases.purchasePackage(packageForMost!);
      }
    } catch (e) {
      debugPrint('Failed to purchase category!');
      setState(() {
        isTransaction = false;
      });
    }
    try {
      if (widget.category.id == 'c4' && isSubForTruth == false) {
        await Purchases.purchasePackage(packageForTruth!);
      }
    } catch (e) {
      debugPrint('Failed to purchase category!');
    }
    try {
      if (widget.category.id == 'c11') {
        await Purchases.purchasePackage(packageForRather!);
      }
    } catch (e) {
      debugPrint('Failed to purchase category!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? CupertinoColors.secondaryLabel
        : CupertinoColors.inactiveGray;

    final Color intensityColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? Theme.of(context).colorScheme.inversePrimary
        : Theme.of(context).colorScheme.tertiary;

    final Color bodyColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? CupertinoColors.extraLightBackgroundGray
        : CupertinoColors.black;

    final height = MediaQuery.of(context).size.height * 0.4;

    var catName = widget.category.title;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'Unlock the Category',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.elliptical(200, 70),
                  bottomRight: Radius.elliptical(200, 70),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: height,
                  child: Image.asset(
                    'assets/images/paywall_image.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Text(
                'Bonderful Idea!',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: intensityColor),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '$catName category has unique questions to explore. This one time payment will permanently unlock this category.',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: bodyColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12.0),
              if (isTransaction)
                const CupertinoActivityIndicator(
                    radius: 15.0, color: CupertinoColors.activeBlue),
              if (!isTransaction)
                CupertinoButton.filled(
                  onPressed: onSelectLockedCategory,
                  child: Text(
                    'Continue',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: CupertinoColors.extraLightBackgroundGray),
                  ),
                ),
              const SizedBox(height: 40.0),
              RichText(
                text: TextSpan(
                  text: 'Privacy Policy',
                  style: GoogleFonts.alef(
                    fontSize: 14,
                    color: bodyColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
