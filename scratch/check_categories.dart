import 'dart:convert';
import 'dart:io';
void main() {
  final c = jsonDecode(File('assets/data/badges.json').readAsStringSync());
  final cats = (c['badges'] as List).map((e) => e['category']).toSet().toList();
  print(cats);
}
