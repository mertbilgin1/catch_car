class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String icon;
  final String color;
  final bool isUnlocked;

  BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.isUnlocked,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
    );
  }
}
