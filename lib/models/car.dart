enum CarRarity { common, rare, epic, legendary }

class Car {
  final String id;
  final String make;
  final String model;
  final String trim;
  final int year;
  final int hp;
  final int torque;
  final double acceleration;
  final int topSpeed;
  final String marketValueMin;
  final String marketValueMax;
  final String marketValueAvg;
  final CarRarity rarity;
  final int points;
  final String imageUrl;
  final String description;
  final DateTime scanDate;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.trim,
    required this.year,
    required this.hp,
    required this.torque,
    required this.acceleration,
    required this.topSpeed,
    required this.marketValueMin,
    required this.marketValueMax,
    required this.marketValueAvg,
    required this.rarity,
    required this.points,
    required this.imageUrl,
    required this.description,
    DateTime? scanDate,
  }) : scanDate = scanDate ?? DateTime.now();
}
