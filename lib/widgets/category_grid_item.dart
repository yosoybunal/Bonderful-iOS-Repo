import 'package:flutter/material.dart';
import 'package:herkese_sor/main.dart';
import 'package:herkese_sor/models/category.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
    required this.onSelectCategory,
  });

  final Category category;
  final void Function() onSelectCategory;

  @override
  Widget build(BuildContext context) {
    final Color itemsColor = MyApp.themeNotifier.value == ThemeMode.dark
        ? Colors.white
        : Theme.of(context).colorScheme.onBackground;

    return InkWell(
      onTap: onSelectCategory,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            category.iconSmall,
            Text(
              category.title,
              style: GoogleFonts.alef(fontSize: 15).copyWith(color: itemsColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
