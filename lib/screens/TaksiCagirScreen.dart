import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:taksim_kapimda/screens/BekleyenIslemlerScreen.dart';

class TaksiCagirSayfasi extends StatefulWidget {
  final String name;
  final String surname;
  final String phone;
  final String email;

  const TaksiCagirSayfasi({
    required this.name,
    required this.surname,
    required this.phone,
    required this.email,
  });

  @override
  State<TaksiCagirSayfasi> createState() => _TaksiCagirSayfasiState();
}

class _TaksiCagirSayfasiState extends State<TaksiCagirSayfasi> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("Islemler");

  @override
  void initState() {
    super.initState();
    _taksiCagir();
  }

  Future<void> _taksiCagir() async {
    // Konum işlemleri
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    LocationData locationData = await location.getLocation();

    // Mevcut bekleyen işlemleri sil
    DataSnapshot snapshot = await _ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        if (value["telefon"] == widget.phone && value["durum"] == "bekleniyor") {
          _ref.child(key).remove();
        }
      });
    }

    // Yeni işlem oluştur
    await _ref.push().set({
      "ad": widget.name,
      "soyad": widget.surname,
      "telefon": widget.phone,
      "email": widget.email,
      "nezaketPuani": 100,
      "konum": {
        "lat": locationData.latitude,
        "lng": locationData.longitude,
      },
      "taksici": {},
      "durum": "bekleniyor",
      "tarih": DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taksi Çağrıldı"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_taxi, size: 80, color: Colors.yellow[800]),
              SizedBox(height: 20),
              Text(
                "Taksi çağrınız alındı.",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Eşleşme sonrasında sizi bilgilendireceğiz.\nİsterseniz bekleyen işlemlerim sayfasından takip edebilirsiniz.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BekleyenIslemlerSayfasi(telefon: widget.phone),
                    ),
                  );
                },
                child: Text("Bekleyen İşlemlerim" ,style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
