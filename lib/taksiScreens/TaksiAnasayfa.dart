import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class TaksiAnasayfa extends StatefulWidget {
  final String telefon;
  const TaksiAnasayfa({required this.telefon});

  @override
  State<TaksiAnasayfa> createState() => _TaksiAnasayfaState();
}

class _TaksiAnasayfaState extends State<TaksiAnasayfa> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("Islemler");
  final DatabaseReference _taksicilerRef = FirebaseDatabase.instance.ref("Taksiciler_Tablo");

  @override
  void initState() {
    super.initState();
    _getKonumlar();
  }

  void _getKonumlar() async {
    final snapshot = await _ref.get();
    if (snapshot.exists && snapshot.value != null) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        if (value["durum"] == "bekleniyor" && value["konum"] != null) {
          final konum = value["konum"];
          final double? lat = konum["lat"]?.toDouble();
          final double? lng = konum["lng"]?.toDouble();

          if (lat != null && lng != null) {
            DateTime tarih = DateTime.tryParse(value["tarih"] ?? "") ?? DateTime.now();
            String formattedDate = "${tarih.day.toString().padLeft(2, '0')}.${tarih.month.toString().padLeft(2, '0')}.${tarih.year} ${tarih.hour.toString().padLeft(2, '0')}:${tarih.minute.toString().padLeft(2, '0')}";

            _markers.add(Marker(
              markerId: MarkerId(key),
              position: LatLng(lat, lng),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Ad Soyad: ${value["ad"]} ${value["soyad"]}"),
                        Text("Nezaket Puanı: ${value["nezaketPuani"] ?? 'Bilinmiyor'}"),
                        Text("İşlem Tarihi: $formattedDate"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _markers.removeWhere((m) => m.markerId.value == key);
                                });
                                Navigator.pop(context);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.check_circle, color: Colors.green),
                              onPressed: () async {
                                // Firebase'deki taksici bilgilerini alalım
                                final taksiciSnapshot = await _taksicilerRef.child(widget.telefon).get();
                                if (taksiciSnapshot.exists) {
                                  final taksiciData = taksiciSnapshot.value as Map<dynamic, dynamic>;

                                  // Taksicinin daha önce işlem gönderip göndermediğini kontrol et
                                  final existingRequestSnapshot = await _ref.orderByChild('taksiciId').equalTo(widget.telefon).get();
                                  if (existingRequestSnapshot.exists) {
                                    // Eğer taksici daha önce işlem göndermişse
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Bu taksici daha önce işlem göndermiştir!'),
                                    ));
                                    Navigator.pop(context);
                                    return;
                                  }

                                  // İstek gönderme işlemi
                                  await _ref.child(key).update({
                                    "durum": "istek geldi",
                                    "taksiciId": widget.telefon,  // Taksici bilgisi
                                    "taksiciBilgileri": {
                                      "ad": taksiciData["ad"],
                                      "soyad": taksiciData["soyad"],
                                      "telefon": widget.telefon,
                                      "plaka": taksiciData["plaka"],
                                      "puan": taksiciData["puan"],
                                    },
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('İstek başarıyla gönderildi!'),
                                  ));

                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Taksici bilgileri bulunamadı!'),
                                  ));
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              infoWindow: InfoWindow(
                title: "${value["ad"]} ${value["soyad"]}",
                snippet: "İşlem Bekliyor",
              ),
            ));
          }
        }
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taksici Anasayfa"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Menü', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Profil Bilgileri'),
              onTap: () {
                // Profil sayfasına yönlendirme
              },
            ),
            ListTile(
              title: Text('İşlemler'),
              onTap: () {
                // İşlemler sayfasına yönlendirme
              },
            ),
            ListTile(
              title: Text('Yolculuk İstatistikleri'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Ayarlar'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Güvenlik'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Çıkış Yap'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(41.0082, 28.9784), // İstanbul varsayılan
          zoom: 12,
        ),
        markers: _markers,
      ),
    );
  }
}
