import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../core/theme.dart';
import '../models/badge_model.dart';
import 'badges_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isProfileSet = false;
  String _username = '';
  final TextEditingController _nameController = TextEditingController();

  List<BadgeModel> _allBadges = [];
  List<String> _categories = [];
  bool _isLoadingBadges = true;

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
        _categories = badgesList.map((e) => e.category).toSet().toList();
        _isLoadingBadges = false;
      });
    } catch (e) {
      debugPrint('Error loading badges: \$e');
      setState(() {
        _isLoadingBadges = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_nameController.text.trim().isNotEmpty) {
      setState(() {
        _username = _nameController.text.trim();
        _isProfileSet = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir kullanıcı adı girin.')),
      );
    }
  }

  IconData _getCategoryIcon(String category) {
    if (category == 'Genel') return CupertinoIcons.chart_bar_alt_fill;
    if (category == 'Nadirlik') return CupertinoIcons.sparkles;
    if (category == 'Donanım') return CupertinoIcons.settings;
    return CupertinoIcons.rosette;
  }

  Color _getCategoryColor(String category) {
    if (category == 'Genel') return AppTheme.electricBlue;
    if (category == 'Nadirlik') return Colors.amber;
    if (category == 'Donanım') return AppTheme.cyberLime;
    return AppTheme.electricBlue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Profilim', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    if (_isProfileSet)
                      IconButton(
                        icon: const Icon(CupertinoIcons.settings, color: AppTheme.electricBlueLight),
                        onPressed: () {},
                      )
                  ],
                ),
                const SizedBox(height: 24),

                if (!_isProfileSet)
                  _buildSetupProfileView()
                else
                  _buildFullProfileView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSetupProfileView() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.electricBlue.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.electricBlue.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(CupertinoIcons.person_add_solid, size: 64, color: AppTheme.electricBlue),
            const SizedBox(height: 16),
            const Text(
              'Avcı Profilini Oluştur',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rozet koleksiyonuna başlamak ve seviye atlamak için kendine bir avcı adı seç.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Kullanıcı Adı',
                hintStyle: const TextStyle(color: AppTheme.textMuted),
                prefixIcon: const Icon(CupertinoIcons.person, color: AppTheme.electricBlueLight),
                filled: true,
                fillColor: Colors.black.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.electricBlue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.electricBlue,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Profilimi Oluştur',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullProfileView() {
    final String tag = "@${_username.toLowerCase().replaceAll(' ', '_')}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar and Basic Info
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.electricBlue, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.electricBlue.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.surfaceBright,
                  child: Icon(Icons.person, size: 50, color: AppTheme.electricBlueLight),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tag,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Stats Row
        Row(
          children: [
            _buildStatCard('SEVİYE', '0', AppTheme.electricBlueLight),
            const SizedBox(width: 16),
            _buildStatCard('TARANAN', '0', Colors.white),
            const SizedBox(width: 16),
            _buildStatCard('PUAN', '0', AppTheme.cyberLime),
          ],
        ),
        const SizedBox(height: 32),

        // Categories Section Header
        const Text(
          'ROZET KATEGORİLERİ',
          style: TextStyle(
            color: AppTheme.textMuted,
            letterSpacing: 2,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: _isLoadingBadges
              ? const Center(child: CircularProgressIndicator(color: AppTheme.electricBlue))
              : Row(
                  children: _categories.map((category) {
                    final categoryBadges = _allBadges.where((b) => b.category == category).toList();
                    final bool isCategoryUnlocked = true; // Categories are always unlocked
                    
                    final color = _getCategoryColor(category);
                    final icon = _getCategoryIcon(category);

                    return Expanded(
                      child: GestureDetector(
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
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isCategoryUnlocked ? color.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isCategoryUnlocked ? color.withOpacity(0.5) : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon, color: color, size: 28),
                              const SizedBox(height: 8),
                              Text(
                                category,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isCategoryUnlocked ? color : AppTheme.textMuted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 32),

        // Actions List
        const Text(
          'HESAP',
          style: TextStyle(
            color: AppTheme.textMuted,
            letterSpacing: 2,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              _buildActionRow(CupertinoIcons.person_solid, 'Kişisel Bilgiler'),
              const Divider(color: AppTheme.outline, height: 1),
              _buildActionRow(CupertinoIcons.bell_solid, 'Bildirim Tercihleri'),
              const Divider(color: AppTheme.outline, height: 1),
              _buildActionRow(CupertinoIcons.lock_fill, 'Gizlilik ve Güvenlik'),
              const Divider(color: AppTheme.outline, height: 1),
              _buildActionRow(CupertinoIcons.square_arrow_right, 'Çıkış Yap', isDestructive: true),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String label, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.redAccent : AppTheme.electricBlueLight,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? Colors.redAccent : Colors.white,
          fontSize: 16,
          fontWeight: isDestructive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isDestructive
          ? null
          : const Icon(CupertinoIcons.chevron_right, color: AppTheme.textMuted, size: 16),
      onTap: () {},
    );
  }
}
