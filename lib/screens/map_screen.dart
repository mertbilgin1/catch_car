import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../core/theme.dart';

class MapScreen extends StatefulWidget {
  final bool isActive;
  const MapScreen({super.key, required this.isActive});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _hasActivity = false; // Set to true dynamically to show the activity card
  bool _isExpanded = false;
  Timer? _shrinkTimer;

  @override
  void initState() {
    super.initState();
    // Konum iznini sadece ekran aktifse (kullanıcı harita sekmesindeyse) iste
    if (widget.isActive) {
      _determinePosition();
    }
    _startShrinkTimer();
  }

  @override
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sekme değiştirilip harita sekmesine gelindiğinde konum izni iste
    if (widget.isActive && !oldWidget.isActive) {
      if (_currentLocation == null) {
        _determinePosition();
      }
    }
  }

  @override
  void dispose() {
    _shrinkTimer?.cancel();
    super.dispose();
  }

  void _startShrinkTimer() {
    _shrinkTimer?.cancel();
    if (_hasActivity && _isExpanded) {
      _shrinkTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _isExpanded = false;
          });
        }
      });
    }
  }

  void _onFireTapped() {
    setState(() {
      _isExpanded = true;
    });
    _startShrinkTimer();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      // Center the map on the user's location
      _mapController.move(_currentLocation!, 15.0);
    }
  }

  Future<void> _centerOnUser() async {
    // If activity card is expanded, touching the map closes it instantly
    if (_hasActivity && _isExpanded) {
      setState(() {
        _isExpanded = false;
      });
      _shrinkTimer?.cancel();
    }

    if (_currentLocation != null) {
      // Already have location, just center it
      _mapController.move(_currentLocation!, 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? const LatLng(41.0082, 28.9784), // Istanbul or user
              initialZoom: 15.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate, // Disable fast rotation
              ),
              onTap: (_, __) => _centerOnUser(), // Tapping anywhere on the map centers it
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.catchcar',
                retinaMode: true,
                tileBuilder: (context, widget, tile) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      -1,  0,  0, 0, 255,
                       0, -1,  0, 0, 255,
                       0,  0, -1, 0, 255,
                       0,  0,  0, 1,   0,
                    ]),
                    child: widget,
                  );
                },
              ),
              // Deep blue overlay to match theme
              Container(
                color: AppTheme.midnightBlue.withAlpha(128), // 0.5 opacity
              ),
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 60,
                      height: 60,
                      child: _buildGlowingDot(),
                    ),
                  ],
                ),
            ],
          ),

          // Header Overlay with Animated Activity Card
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainer.withAlpha(204),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withAlpha(25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.radar, color: AppTheme.electricBlueLight),
                        SizedBox(width: 8),
                        Text(
                          'CANLI KEŞİF',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (_hasActivity)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child));
                      },
                      child: _isExpanded
                          ? _buildFullActivityCard()
                          : _buildFireEmojiButton(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingDot() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.electricBlue.withAlpha(50),
          ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.electricBlue.withAlpha(100),
          ),
        ),
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppTheme.electricBlueLight,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFullActivityCard() {
    return Container(
      key: const ValueKey('full_card'),
      padding: const EdgeInsets.all(16),
      width: 250,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer.withAlpha(230),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cyberLime.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '🔥 YENİ ARAÇ BULUNDU!',
            style: TextStyle(
              color: AppTheme.cyberLime,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Yakınlarda nadir bir araç tarandı. Hemen keşfet!',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFireEmojiButton() {
    return GestureDetector(
      key: const ValueKey('fire_emoji'),
      onTap: _onFireTapped,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainer.withAlpha(230),
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.cyberLime.withAlpha(128)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.cyberLime.withAlpha(50),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Text(
          '🔥',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
