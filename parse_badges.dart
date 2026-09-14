import 'dart:io';
import 'dart:convert';

void main() async {
  final file = File('raw_badges.txt');
  final lines = await file.readAsLines();

  List<Map<String, dynamic>> badges = [];
  String currentCategory = '';
  int badgeId = 1;

  for (var line in lines) {
    line = line.trim();
    if (line.isEmpty) continue;

    // Detect category header (Starts with number and dot)
    if (RegExp(r'^\d+\.').hasMatch(line) && line.contains('ROZETLERİ')) {
      // 1. GENEL İLERLEME VE AV SAYISI ROZETLERİ (1 - 50) -> GENEL İLERLEME VE AV SAYISI ROZETLERİ
      currentCategory = line.replaceFirst(RegExp(r'^\d+\.\s*'), '').split(' (')[0].trim();
      continue;
    }

    if (line.contains(':')) {
      final parts = line.split(':');
      if (parts.length >= 2) {
        final title = parts[0].trim();
        final description = parts.sublist(1).join(':').trim();
        
        // Assign generic icon/color based on category
        String iconName = 'star';
        String colorHex = '0xFFFFFFFF';

        if (currentCategory.contains('GENEL İLERLEME')) { iconName = 'chart_bar'; colorHex = '0xFF00FFCC'; }
        else if (currentCategory.contains('NADİRLİK')) { iconName = 'sparkles'; colorHex = '0xFFFFD700'; }
        else if (currentCategory.contains('DONANIM')) { iconName = 'gear'; colorHex = '0xFFFF5555'; }
        else if (currentCategory.contains('COĞRAFYA')) { iconName = 'map_pin'; colorHex = '0xFF44AAFF'; }
        else if (currentCategory.contains('ALMAN')) { iconName = 'shield'; colorHex = '0xFFAAAAAA'; }
        else if (currentCategory.contains('JAPON')) { iconName = 'flame'; colorHex = '0xFFFF3333'; }
        else if (currentCategory.contains('İTALYAN')) { iconName = 'heart'; colorHex = '0xFFE32636'; }
        else if (currentCategory.contains('AMERİKAN')) { iconName = 'hammer'; colorHex = '0xFF191970'; }
        else if (currentCategory.contains('ELEKTRİKLİ')) { iconName = 'bolt'; colorHex = '0xFF32CD32'; }
        else if (currentCategory.contains('GİZLİ')) { iconName = 'eye'; colorHex = '0xFF9932CC'; }

        badges.add({
          'id': 'badge_$badgeId',
          'title': title,
          'description': description,
          'category': currentCategory,
          'icon': iconName,
          'color': colorHex,
          'isUnlocked': false,
        });
        badgeId++;
      }
    }
  }

  final outputFile = File('assets/data/badges.json');
  await outputFile.writeAsString(jsonEncode({'badges': badges}));
  print('Successfully parsed $badgeId badges into assets/data/badges.json');
}
