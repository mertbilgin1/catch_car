import 'dart:io';
import 'dart:convert';

void main() async {
  final file = File(r'C:\Users\Pc\.gemini\antigravity\brain\462708a3-5eed-4d22-9e15-839459593ae3\.system_generated\steps\239\output.txt');
  final content = await file.readAsString();
  final data = jsonDecode(content);
  for (var screen in data['screens']) {
    print('${screen['id']} - ${screen['name']}');
  }
}
