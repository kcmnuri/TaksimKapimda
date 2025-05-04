import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimpleMapScreen extends StatelessWidget {
  const SimpleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Basit Harita Testi")),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(41.0082, 28.9784), // İstanbul koordinatları
          zoom: 14,
        ),
        myLocationEnabled: false, // Bu testte konum yok
        zoomControlsEnabled: true,
      ),
    );
  }
}
