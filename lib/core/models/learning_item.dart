class LearningItem {
  final String title;
  final String subtitle;
  final String visual;
  final String category;
  final String colorHex;

  const LearningItem({
    required this.title,
    required this.subtitle,
    required this.visual,
    this.category = '',
    this.colorHex = '#FFFFFF',
  });
}
