import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';
import '../services/mock_car_service.dart';
import 'result_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _cameraController;
  final MockCarService _carService = MockCarService();
  bool _isScanning = false;
  bool _isCameraInitialized = false;
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    // This will request camera permission immediately when the app launches
    // because IndexedStack builds all tabs initially.
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // Find the back camera
        final backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );

        _cameraController = CameraController(
          backCamera,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: \$e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _scanLiveCamera() async {
    if (!_isCameraInitialized || _cameraController == null) return;
    
    try {
      setState(() {
        _isScanning = true;
      });

      final XFile image = await _cameraController!.takePicture();
      
      setState(() {
        _capturedImage = File(image.path);
      });

      // Simulate analysis
      final result = await _carService.analyzeImage(image.path);

      if (mounted) {
        setState(() {
          _isScanning = false;
        });

        if (result != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(car: result),
            ),
          ).then((_) {
            // Reset state when coming back
            setState(() {
              _capturedImage = null;
            });
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Araç bulunamadı veya veritabanı boş.')),
          );
          setState(() {
            _capturedImage = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _capturedImage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fotoğraf alınırken hata oluştu.')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() {
        _capturedImage = File(image.path);
        _isScanning = true;
      });

      final result = await _carService.analyzeImage(image.path);

      if (mounted) {
        setState(() {
          _isScanning = false;
        });

        if (result != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(car: result),
            ),
          ).then((_) {
            setState(() {
              _capturedImage = null;
            });
          });
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Live Camera Preview
          if (_isCameraInitialized && _cameraController != null)
            SizedBox.expand(
              child: _capturedImage == null 
                  ? CameraPreview(_cameraController!)
                  : Image.file(_capturedImage!, fit: BoxFit.cover),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: AppTheme.electricBlue),
            ),

          // 2. Crosshair and Corner Brackets Overlay
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, -0.3),
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildCornerBox(rotation: 0),
                                _buildCornerBox(rotation: 1),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildCornerBox(rotation: 3),
                                _buildCornerBox(rotation: 2),
                              ],
                            ),
                          ],
                        ),
                        // The Central Crosshair
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 48,
                        ),
                      ],
                    ),
                  ),
                ),

                // Scanning Animation Overlay
                if (_isScanning)
                  Align(
                    alignment: const Alignment(0, -0.3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 250,
                          height: 2,
                          color: AppTheme.cyberLime,
                          child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: AppTheme.cyberLime, blurRadius: 10, spreadRadius: 2)
                              ]
                            ),
                          ),
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                         .moveY(begin: -150, end: 150, duration: const Duration(seconds: 1)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // 3. Scan Actions
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0), // Above bottom nav
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _isScanning ? null : _scanLiveCamera,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.electricBlue.withOpacity(0.2),
                        border: Border.all(
                          color: AppTheme.electricBlue,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.electricBlue.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                     .scaleXY(begin: 1.0, end: 1.05, duration: const Duration(seconds: 1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerBox({int rotation = 0}) {
    return RotatedBox(
      quarterTurns: rotation,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white, width: 4),
            left: BorderSide(color: Colors.white, width: 4),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.5),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Inter',
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }
}
