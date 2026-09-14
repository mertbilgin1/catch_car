import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  final file = File('assets/data/badges.json');
  if (!file.existsSync()) {
    print('File not found');
    return;
  }

  final content = file.readAsStringSync();
  final data = jsonDecode(content);
  final badges = data['badges'] as List;

  final random = Random();

  for (var badge in badges) {
    final oldCategory = (badge['category'] as String).toLowerCase();
    
    // Map to new categories
    if (oldCategory.contains('donanım') || oldCategory.contains('elektrik')) {
      badge['category'] = 'Donanım';
    } else if (oldCategory.contains('nadir') || oldCategory.contains('alman') || oldCategory.contains('jdm') || oldCategory.contains('amerikan') || oldCategory.contains('i̇talyan') || oldCategory.contains('italyan')) {
      badge['category'] = 'Nadirlik';
    } else {
      badge['category'] = 'Genel';
    }
    
    // Assign a random bright color to the badge for when it is unlocked
    final r = 100 + random.nextInt(156);
    final g = 100 + random.nextInt(156);
    final b = 100 + random.nextInt(156);
    final colorHex = '0xFF' + r.toRadixString(16).padLeft(2, '0') + g.toRadixString(16).padLeft(2, '0') + b.toRadixString(16).padLeft(2, '0');
    badge['color'] = colorHex;
  }

  file.writeAsStringSync(jsonEncode(data));
  print('Done rewriting badges.json');
}
