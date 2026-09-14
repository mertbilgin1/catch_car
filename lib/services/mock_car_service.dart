import '../models/car.dart';

class MockCarService {
  Future<Car?> analyzeImage(String imagePath) async {
    // Simulate AI analysis delay
    await Future.delayed(const Duration(seconds: 2));
    
    // No data currently, return null
    return null;
  }

  List<Car> getGarageCars() {
    // Return empty list
    return [];
  }

  int getTotalPoints() {
    return 0;
  }
}
