import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BekleyenIslemlerSayfasi extends StatefulWidget {
  final String telefon;
  const BekleyenIslemlerSayfasi({required this.telefon});

  @override
  State<BekleyenIslemlerSayfasi> createState() => _BekleyenIslemlerSayfasiState();
}

class _BekleyenIslemlerSayfasiState extends State<BekleyenIslemlerSayfasi> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("Islemler");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bekleyen İşlemler"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<DataSnapshot>(
        future: _ref.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Bir hata oluştu."));
          }

          if (!snapshot.hasData || snapshot.data!.value == null) {
            return Center(child: Text("Bekleyen işlem bulunmamaktadır."));
          }

          final data = snapshot.data!.value as Map<dynamic, dynamic>;
          final bekleyenIslemler = data.entries.where((entry) {
            final value = entry.value;
            return value["telefon"] == widget.telefon && value["durum"] == "bekleniyor";
          }).toList();

          if (bekleyenIslemler.isEmpty) {
            return Center(child: Text("Bekleyen işlem bulunmamaktadır."));
          }

          return ListView.builder(
            itemCount: bekleyenIslemler.length,
            itemBuilder: (context, index) {
              final entry = bekleyenIslemler[index];
              final islem = entry.value;
              return ListTile(
                title: Text("${islem['ad']} ${islem['soyad']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Durum: ${islem['durum']}"),
                    Text("İşlem Saati:  ${_formatSaat(islem['tarih'])}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
String _formatSaat(String tarih) {
  try {
    final dateTime = DateTime.parse(tarih);
    final saat = dateTime.hour.toString().padLeft(2, '0');
    final dakika = dateTime.minute.toString().padLeft(2, '0');
    return "$saat:$dakika";
  } catch (e) {
    return "Bilinmiyor";
  }
}

