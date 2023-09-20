import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.id,
    required this.title,
    required this.iconSmall,
    this.color = Colors.orange,
  });

  final String id;
  final String title;
  final Color color;
  final Image iconSmall;
}
