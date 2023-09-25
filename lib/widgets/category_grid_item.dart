import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herkese_sor/main.dart';
import 'package:herkese_sor/models/category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class CategoryGridItem extends StatefulWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
    required this.onSelectCategory,
  });

  final Category category;
  final void Function() onSelectCategory;

  @override
  State<CategoryGridItem> createState() => _CategoryGridItemState();
}

class _CategoryGridItemState extends State<CategoryGridItem> {
  bool isSubForTruth = false;
  bool isSubForMost = false;
  bool isSubForRather = false;

  @override
  void initState() {
    super.initState();

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

  Widget lockIcon() {
    if (widget.category.id == 'c3' && isSubForMost == false) {
      return const Icon(CupertinoIcons.lock_fill, size: 20);
    } else if (widget.category.id == 'c3' && isSubForMost == true) {
      return const Icon(CupertinoIcons.lock_open_fill, size: 20);
    }

    if (widget.category.id == 'c4' && isSubForTruth == false) {
      return const Icon(CupertinoIcons.lock_fill, size: 20);
    } else if (widget.category.id == 'c4' && isSubForTruth == true) {
      return const Icon(CupertinoIcons.lock_open_fill, size: 20);
    }

    if (widget.category.id == 'c11' && isSubForRather == false) {
      return const Icon(CupertinoIcons.lock_fill, size: 20);
    } else if (widget.category.id == 'c11' && isSubForRather == true) {
      return const Icon(CupertinoIcons.lock_open_fill, size: 20);
    }
    return const SizedBox(
      height: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color itemsColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? Colors.white
        : Theme.of(context).colorScheme.onBackground;

    return InkWell(
      onTap: widget.onSelectCategory,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              widget.category.color.withOpacity(0.55),
              widget.category.color.withOpacity(0.9)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            lockIcon(),
            const SizedBox(
              height: 12,
            ),
            widget.category.iconSmall,
            const SizedBox(
              height: 18,
            ),
            Text(
              widget.category.title,
              style: GoogleFonts.alef(fontSize: 14).copyWith(color: itemsColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
