import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herkese_sor/main.dart';
import 'package:herkese_sor/models/category.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
    required this.onSelectCategory,
    required this.lockIcon,
  });

  final Category category;
  final void Function() onSelectCategory;
  final Widget lockIcon;

  @override
  Widget build(BuildContext context) {
    final Color itemsColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? Colors.white
        : Theme.of(context).colorScheme.onBackground;

    // Icon(
    //   category.id == 'c3' || category.id == 'c4' || category.id == 'c11'
    //       ? lockIcon
    //       : null,
    //   size: 15.0,
    // );

    return InkWell(
      onTap: onSelectCategory,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.55),
              category.color.withOpacity(0.9)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            category.id == 'c3' || category.id == 'c4' || category.id == 'c11'
                ? lockIcon
                : const SizedBox(height: 20),
            const SizedBox(
              height: 12,
            ),
            category.iconSmall,
            const SizedBox(
              height: 18,
            ),
            Text(
              category.title,
              style: GoogleFonts.alef(fontSize: 14).copyWith(color: itemsColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
