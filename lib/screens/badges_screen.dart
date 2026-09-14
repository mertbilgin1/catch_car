import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../core/theme.dart';
import '../models/badge_model.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  List<BadgeModel> _allBadges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/badges.json');
      final jsonData = jsonDecode(jsonString);
      final badgesList = (jsonData['badges'] as List)
          .map((item) => BadgeModel.fromJson(item))
          .toList();

      setState(() {
        _allBadges = badgesList;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading badges: \$e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> _getCategories() {
    return _allBadges.map((e) => e.category).toSet().toList();
  }

  IconData _getCategoryIcon(String category) {
    if (category.contains('Genel')) return CupertinoIcons.chart_bar_alt_fill;
    if (category.contains('Nadir')) return CupertinoIcons.sparkles;
    if (category.contains('Donanım')) return CupertinoIcons.settings;
    if (category.contains('Coğrafya')) return CupertinoIcons.map_pin_ellipse;
    if (category.contains('Alman')) return CupertinoIcons.shield_fill;
    if (category.contains('JDM')) return CupertinoIcons.flame_fill;
    if (category.contains('İtalyan')) return CupertinoIcons.heart_solid;
    if (category.contains('Amerikan')) return CupertinoIcons.hammer_fill;
    if (category.contains('Elektrik')) return CupertinoIcons.bolt_fill;
    if (category.contains('Gizli')) return CupertinoIcons.eye_solid;
    return CupertinoIcons.star_fill;
  }

  Color _getCategoryColor(String category) {
    if (category.contains('Genel')) return AppTheme.electricBlue;
    if (category.contains('Nadir')) return Colors.amber;
    if (category.contains('Donanım')) return Colors.grey;
    if (category.contains('Coğrafya')) return Colors.green;
    if (category.contains('Alman')) return Colors.white;
    if (category.contains('JDM')) return Colors.redAccent;
    if (category.contains('İtalyan')) return Colors.greenAccent;
    if (category.contains('Amerikan')) return Colors.blueAccent;
    if (category.contains('Elektrik')) return AppTheme.cyberLime;
    if (category.contains('Gizli')) return Colors.deepPurpleAccent;
    return AppTheme.electricBlue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      appBar: AppBar(
        title: const Text('Rozet Kategorileri', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.electricBlue))
          : _allBadges.isEmpty
              ? const Center(child: Text('Kategoriler yüklenemedi', style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _getCategories().length,
                  itemBuilder: (context, index) {
                    final category = _getCategories()[index];
                    final categoryBadges = _allBadges.where((b) => b.category == category).toList();
                    final unlockedCount = categoryBadges.where((b) => b.isUnlocked).length;
                    final totalCount = categoryBadges.length;
                    final bool isCategoryUnlocked = unlockedCount > 0;
                    
                    final color = isCategoryUnlocked ? _getCategoryColor(category) : AppTheme.textMuted;
                    final icon = isCategoryUnlocked ? _getCategoryIcon(category) : CupertinoIcons.lock_fill;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryBadgesScreen(
                              categoryName: category,
                              badges: categoryBadges,
                              categoryColor: _getCategoryColor(category),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isCategoryUnlocked ? color.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isCategoryUnlocked ? color.withOpacity(0.5) : Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isCategoryUnlocked ? color.withOpacity(0.2) : Colors.black.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, color: color, size: 32),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category,
                                    style: TextStyle(
                                      color: isCategoryUnlocked ? Colors.white : AppTheme.textMuted,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isCategoryUnlocked 
                                      ? '\$unlockedCount / \$totalCount Açıldı'
                                      : 'Henüz rozet kazanılmadı',
                                    style: TextStyle(
                                      color: isCategoryUnlocked ? color : AppTheme.textMuted.withOpacity(0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: totalCount == 0 ? 0 : unlockedCount / totalCount,
                                    backgroundColor: Colors.black.withOpacity(0.3),
                                    valueColor: AlwaysStoppedAnimation<Color>(color),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              CupertinoIcons.chevron_right,
                              color: isCategoryUnlocked ? color : AppTheme.textMuted,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class CategoryBadgesScreen extends StatelessWidget {
  final String categoryName;
  final List<BadgeModel> badges;
  final Color categoryColor;

  const CategoryBadgesScreen({
    super.key,
    required this.categoryName,
    required this.badges,
    required this.categoryColor,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'chart_bar': return CupertinoIcons.chart_bar_alt_fill;
      case 'sparkles': return CupertinoIcons.sparkles;
      case 'gear': return CupertinoIcons.settings;
      case 'map_pin': return CupertinoIcons.map_pin_ellipse;
      case 'shield': return CupertinoIcons.shield_fill;
      case 'flame': return CupertinoIcons.flame_fill;
      case 'heart': return CupertinoIcons.heart_solid;
      case 'hammer': return CupertinoIcons.hammer_fill;
      case 'bolt': return CupertinoIcons.bolt_fill;
      case 'eye': return CupertinoIcons.eye_solid;
      default: return CupertinoIcons.rosette;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemCount: badges.length,
        itemBuilder: (context, idx) {
          final badge = badges[idx];
          final colorValue = int.tryParse(badge.color) ?? 0xFFFFFFFF;
          final badgeColor = Color(colorValue);
          final iconData = _getIconData(badge.icon);

          return _buildBadgeItem(context, badge, badgeColor, iconData);
        },
      ),
    );
  }

  Widget _buildBadgeItem(BuildContext context, BadgeModel badge, Color color, IconData icon) {
    final bool isUnlocked = badge.isUnlocked;

    return GestureDetector(
      onTap: () {
        _showBadgeDetails(context, badge, color, icon, isUnlocked);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? color.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? color.withOpacity(0.5) : Colors.white.withOpacity(0.1),
          ),
          boxShadow: isUnlocked ? [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ] : [],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUnlocked ? icon : CupertinoIcons.lock_fill,
              color: isUnlocked ? color : AppTheme.textMuted,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isUnlocked ? color : AppTheme.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetails(BuildContext context, BadgeModel badge, Color color, IconData icon, bool isUnlocked) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isUnlocked ? color.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUnlocked ? color : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  isUnlocked ? icon : CupertinoIcons.lock_fill,
                  size: 40,
                  color: isUnlocked ? color : AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                badge.title,
                style: TextStyle(
                  color: isUnlocked ? color : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                badge.category,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Text(
                badge.description,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
