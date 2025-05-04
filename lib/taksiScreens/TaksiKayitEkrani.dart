import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'TaksiAnasayfa.dart';

class TaksiKayitEkrani extends StatefulWidget {
  final String phone;

  TaksiKayitEkrani({required this.phone});

  @override
  _TaksiKayitEkraniState createState() => _TaksiKayitEkraniState();
}

class _TaksiKayitEkraniState extends State<TaksiKayitEkrani> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _plakaController = TextEditingController();
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  Future<void> _kayitOl() async {
    final ad = _adController.text.trim();
    final soyad = _soyadController.text.trim();
    final plaka = _plakaController.text.trim();
    final tc = _tcController.text.trim();
    final email = _emailController.text.trim();
    final sifre = _sifreController.text.trim();

    if (ad.isEmpty || soyad.isEmpty || plaka.isEmpty || tc.isEmpty || email.isEmpty || sifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    // Firebase Realtime Database'e veri kaydediyoruz
    final ref = FirebaseDatabase.instance.ref('Taksiciler_Tablo/${widget.phone}');
    await ref.set({
      'ad': ad,
      'soyad': soyad,
      'plaka': plaka,
      'tc': tc,
      'email': email,
      'puan': 0.0,           // Nezaket puanı başlangıçta 0
      'yorumlar': [],        // Yorumlar başlangıçta boş
      'sifre': sifre,        // Şifreyi de kaydediyoruz
    });

    // Kayıt işlemi başarılı, kullanıcıyı bir sonraki ekrana yönlendiriyoruz
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => TaksiAnasayfa()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Taksici Kayıt')),
      backgroundColor: Color(0xFFCC9933),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Adınız'),
              TextField(controller: _adController),
              SizedBox(height: 10),
              Text('Soyadınız'),
              TextField(controller: _soyadController),
              SizedBox(height: 10),
              Text('Plaka'),
              TextField(controller: _plakaController),
              SizedBox(height: 10),
              Text('TC Kimlik No'),
              TextField(controller: _tcController),
              SizedBox(height: 10),
              Text('E-posta'),
              TextField(controller: _emailController),
              SizedBox(height: 10),
              Text('Şifre'),
              TextField(controller: _sifreController, obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _kayitOl,
                child: Text('Kayıt Ol ve Başla'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
