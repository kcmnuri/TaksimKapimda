import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Yıldızlı puanlama kütüphanesi

class BekleyenIslemlerSayfasi extends StatefulWidget {
  final String telefon;
  const BekleyenIslemlerSayfasi({required this.telefon});

  @override
  State<BekleyenIslemlerSayfasi> createState() => _BekleyenIslemlerSayfasiState();
}

class _BekleyenIslemlerSayfasiState extends State<BekleyenIslemlerSayfasi> {
  final _ref = FirebaseDatabase.instance.ref("Islemler");
  final _yolculukRef = FirebaseDatabase.instance.ref("Yolculuklar");
  final _taksicilerRef = FirebaseDatabase.instance.ref("Taksiciler_Tablo");

  double _puan = 3; // varsayılan puan
  String _yorum = "";

  // Puan ve yorum taksiciye eklenirken aynı zamanda ortalama puanı güncelle
  Future<void> _puanVeYorumGonder(String telefon) async {
    final taksiciSnapshot = await _taksicilerRef.child(telefon).get();
    final taksici = taksiciSnapshot.value as Map<dynamic, dynamic>?;

    if (taksici != null) {
      double mevcutPuan = (taksici["ortalamaPuan"] ?? 0).toDouble(); // double olarak al
      int puanSayisi = taksici["puanSayisi"] ?? 0;
      double toplamPuan = mevcutPuan * puanSayisi + _puan;
      double ortalamaPuan = toplamPuan / (puanSayisi + 1);

      // Veriyi güncelle
      await _taksicilerRef.child(telefon).update({
        "ortalamaPuan": ortalamaPuan,
        "puanSayisi": puanSayisi + 1,
        "yorumlar": {
          "puan": _puan,
          "yorum": _yorum,
          "musteriTelefon": widget.telefon,
        },
      });
    } else {
      // İlk defa bir puanlama yapılıyorsa
      await _taksicilerRef.child(telefon).set({
        "ortalamaPuan": _puan,
        "puanSayisi": 1,
        "yorumlar": {
          "puan": _puan,
          "yorum": _yorum,
          "musteriTelefon": widget.telefon,
        },
      });
    }
  }

  void _yolculuguBitirDialogGoster(Map islem, String key) {
    final taksici = islem["taksiciBilgileri"];
    final taksiciTelefon = taksici["telefon"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Yolculuğu Bitir"),
          content: Container(
            height: 250, // sabit bir yükseklik veriyoruz
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${taksici['ad']} ${taksici['soyad']}"),
                SizedBox(height: 10),
                Text("Nezaket Puanı"),
                RatingBar.builder(
                  initialRating: _puan,
                  minRating: 1,
                  itemSize: 40,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _puan = rating;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Yorum yaz..."),
                  onChanged: (value) {
                    _yorum = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Yolculuk bilgisi Yolculuklar'a taşınır
                await _yolculukRef.push().set(islem);

                // Taksiciye puan ve yorum yazılır
                await _puanVeYorumGonder(taksiciTelefon);

                // İşlem silinir
                await _ref.child(key).remove();

                Navigator.of(context).pop(); // dialog kapat
                setState(() {}); // ekranı güncelle
              },
              child: Text("Yolculuğu Bitir"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bekleyen İşlemler")),
      body: FutureBuilder<DataSnapshot>(
        future: _ref.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.value == null)
            return Center(child: Text("İşlem bulunamadı."));

          final data = snapshot.data!.value as Map<dynamic, dynamic>;
          final islemler = data.entries.where((entry) =>
          entry.value["telefon"] == widget.telefon).toList();

          if (islemler.isEmpty) {
            return Center(child: Text("İşlem bulunamadı."));
          }

          return ListView(
            children: islemler.map((entry) {
              final islem = entry.value;
              final key = entry.key;
              final durum = islem["durum"];
              final taksici = islem["taksiciBilgileri"];

              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ad: ${islem['ad']} ${islem['soyad']}"),
                      Text("Durum: $durum"),
                      SizedBox(height: 10),

                      if (taksici != null) ...[
                        Divider(),
                        Text("Taksici: ${taksici['ad']} ${taksici['soyad']}"),
                        Text("Telefon: ${taksici['telefon']}"),
                        Text("Nezaket Puanı: ${taksici['ortalamaPuan'?? 0]}"),
                        SizedBox(height: 10),
                      ],

                      if (durum == "istek geldi" && taksici != null) ...[
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await _ref.child(key).update({"durum": "kabul edildi"});
                                setState(() {});
                              },
                              child: Text("Kabul Et"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                await _ref.child(key).update({
                                  "durum": "bekleniyor",
                                  "taksiciBilgileri": null,
                                });
                                setState(() {});
                              },
                              child: Text("Reddet"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            ),
                          ],
                        )
                      ],

                      if (durum == "kabul edildi") ...[
                        ElevatedButton(
                          onPressed: () => _yolculuguBitirDialogGoster(islem, key),
                          child: Text("Yolculuğu Bitir"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        )
                      ]
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
