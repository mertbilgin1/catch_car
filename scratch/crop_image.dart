import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('logo.png');
  if (!file.existsSync()) {
    print('logo.png not found');
    return;
  }
  
  final originalBytes = file.readAsBytesSync();
  final originalImage = img.decodeImage(originalBytes);

  if (originalImage == null) {
    print('Failed to decode image');
    return;
  }

  int minX = originalImage.width;
  int minY = originalImage.height;
  int maxX = 0;
  int maxY = 0;

  for (int y = 0; y < originalImage.height; y++) {
    for (int x = 0; x < originalImage.width; x++) {
      final pixel = originalImage.getPixel(x, y);
      
      // The white background has high brightness.
      final brightness = (pixel.r + pixel.g + pixel.b) / 3;
      if (brightness > 200) { 
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
    }
  }

  print('Bounding box: \$minX, \$minY to \$maxX, \$maxY');

  if (minX <= maxX && minY <= maxY) {
    // Add a tiny bit of padding to not cut off the white edge completely
    final pad = 0;
    final startX = (minX - pad).clamp(0, originalImage.width - 1);
    final startY = (minY - pad).clamp(0, originalImage.height - 1);
    final endX = (maxX + pad).clamp(0, originalImage.width - 1);
    final endY = (maxY + pad).clamp(0, originalImage.height - 1);

    final cropped = img.copyCrop(originalImage, x: startX, y: startY, width: endX - startX + 1, height: endY - startY + 1);
    
    // Do NOT modify inner pixels to avoid ruining the blue brackets
    // Android and iOS will automatically mask the outer corners

    final dir = Directory('assets');
    if (!dir.existsSync()) dir.createSync();
    
    File('assets/icon.png').writeAsBytesSync(img.encodePng(cropped));
    print('Cropped image saved to assets/icon.png');
  } else {
    print('No light pixels found.');
  }
}
