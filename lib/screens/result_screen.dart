import 'package:flutter/material.dart';
import '../models/car.dart';
import '../core/theme.dart';

class ResultScreen extends StatelessWidget {
  final Car car;

  const ResultScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      appBar: AppBar(
        title: const Text('Analiz Sonucu'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Card
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.electricBlue.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: -10,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    car.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Title and Badges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${car.make} ${car.model}',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          car.trim,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.cyberLime,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getRarityColor(car.rarity).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getRarityColor(car.rarity)),
                    ),
                    child: Text(
                      '+${car.points} Puan',
                      style: TextStyle(
                        color: _getRarityColor(car.rarity),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(
                car.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              
              const SizedBox(height: 32),
              const Text(
                'TEKNİK ÖZELLİKLER',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  letterSpacing: 2,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Specs Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  _buildSpecCard('Motor Gücü', '${car.hp} HP'),
                  _buildSpecCard('Tork', '${car.torque} Nm'),
                  _buildSpecCard('0-100 km/s', '${car.acceleration} sn'),
                  _buildSpecCard('Maks Hız', '${car.topSpeed} km/s'),
                ],
              ),
              
              const SizedBox(height: 32),
              const Text(
                'PİYASA DEĞERİ (2. EL)',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  letterSpacing: 2,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Market Value Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _buildMarketRow('Ortalama Fiyat', car.marketValueAvg, isHighlight: true),
                    const Divider(color: AppTheme.outline, height: 24),
                    _buildMarketRow('En Düşük İlan', car.marketValueMin),
                    const SizedBox(height: 8),
                    _buildMarketRow('En Yüksek İlan', car.marketValueMax),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBright.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: isHighlight ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? AppTheme.electricBlueLight : Colors.white,
            fontSize: isHighlight ? 20 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
