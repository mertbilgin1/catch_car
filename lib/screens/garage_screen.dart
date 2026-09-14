import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/car.dart';
import '../services/mock_car_service.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  final MockCarService _carService = MockCarService();
  late List<Car> _cars;
  late int _totalPoints;

  @override
  void initState() {
    super.initState();
    _cars = _carService.getGarageCars();
    _totalPoints = _carService.getTotalPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      appBar: AppBar(
        title: const Text('Garajım / Koleksiyon'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOPLAM PUAN',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          letterSpacing: 1.5,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_totalPoints XP',
                        style: const TextStyle(
                          color: AppTheme.cyberLime,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.electricBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.electricBlue),
                  ),
                  child: const Text(
                    'JDM Koleksiyoncusu',
                    style: TextStyle(
                      color: AppTheme.electricBlueLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: AppTheme.outline),
          ),
          
          // Cars List
          Expanded(
            child: _cars.isEmpty
                ? const Center(
                    child: Text(
                      'Garajınız şu an boş. Hemen yeni bir araba tarayın!',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cars.length,
                    itemBuilder: (context, index) {
                      final car = _cars[index];
                      return _buildCarCard(car);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(Car car) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              car.imageUrl,
              width: 120,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${car.make} ${car.model}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+${car.points}',
                        style: TextStyle(
                          color: _getRarityColor(car.rarity),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    car.trim,
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    car.marketValueAvg,
                    style: const TextStyle(
                      color: AppTheme.electricBlueLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(CarRarity rarity) {
    switch (rarity) {
      case CarRarity.common:
        return Colors.grey;
      case CarRarity.rare:
        return AppTheme.electricBlue;
      case CarRarity.epic:
        return Colors.purpleAccent;
      case CarRarity.legendary:
        return Colors.orangeAccent;
    }
  }
}
