enum Intensity {
  bonding,
  curiosity,
  acquaintance,
  adventure,
  laughter,
  openness,
}

class Question {
  const Question({
    required this.id,
    required this.categories,
    required this.intensity,
    required this.title,
    required this.question,
  });

  final String id;
  final List<String> categories;
  final Intensity intensity;
  final String title;
  final String question;
}
