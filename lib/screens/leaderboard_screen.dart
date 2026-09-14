import 'package:flutter/material.dart';
import '../core/theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [];
    
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      appBar: AppBar(
        title: const Text('Araba Avcıları Liderlik Tablosu'),
        backgroundColor: Colors.transparent,
      ),
      body: users.isEmpty
          ? const Center(
              child: Text(
                'Henüz liderlik tablosunda kimse yok.',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
              ),
            )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final isMe = user['isMe'] == true;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isMe ? AppTheme.electricBlue.withOpacity(0.2) : AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isMe ? AppTheme.electricBlue : Colors.white.withOpacity(0.05),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '#${user['rank']}',
                  style: TextStyle(
                    color: isMe ? AppTheme.cyberLime : AppTheme.textMuted,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: AppTheme.surfaceBright,
                  child: Icon(Icons.person, color: isMe ? AppTheme.electricBlueLight : Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        user['badge'] as String,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${user['points']} XP',
                  style: const TextStyle(
                    color: AppTheme.electricBlueLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
