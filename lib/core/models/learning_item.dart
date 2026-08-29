class LearningItem {
  final String title;
  final String subtitle;
  final String visual;
  final String? sound;
  final String? category;
  final String? colorHex;

  const LearningItem({
    required this.title,
    required this.subtitle,
    required this.visual,
    this.sound,
    this.category,
    this.colorHex,
  });

  String get speakText => sound ?? '$title. $subtitle';
}
