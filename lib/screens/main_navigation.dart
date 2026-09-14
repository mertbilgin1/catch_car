import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/theme.dart';
import 'scanner_screen.dart';
import 'garage_screen.dart';
import 'leaderboard_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 2; // Default to 'Tara' which is now at index 2

  List<Widget> get _screens => [
    const GarageScreen(),
    const LeaderboardScreen(),
    const ScannerScreen(),
    MapScreen(isActive: _currentIndex == 3),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withAlpha(25), // withOpacity(0.1) -> 25/255
              width: 1,
            ),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppTheme.midnightBlue,
          selectedItemColor: AppTheme.electricBlue,
          unselectedItemColor: AppTheme.textMuted,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.car_detailed),
              label: 'Garaj',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar_alt_fill),
              label: 'Liderlik',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? AppTheme.electricBlue.withAlpha(50) : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _currentIndex == 2 ? AppTheme.electricBlue : Colors.transparent,
                  ),
                ),
                child: const Icon(CupertinoIcons.camera_viewfinder, size: 28),
              ),
              label: 'Tara',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.map),
              label: 'Harita',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
      ),
    );
  }
}
