import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'TaksiLoginScreen.dart';
import 'TaksiKayitEkrani.dart';

class TaksiGecisKontrolEkrani extends StatefulWidget {
  @override
  _TaksiGecisKontrolEkraniState createState() => _TaksiGecisKontrolEkraniState();
}

class _TaksiGecisKontrolEkraniState extends State<TaksiGecisKontrolEkrani> {
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _devamEt() async {
    String phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen telefon numaranızı girin')),
      );
      return;
    }

    final ref = FirebaseDatabase.instance.ref('Taksiciler_Tablo/$phone');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      // Kayıtlı taksici -> giriş ekranına
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TaksiLoginEkrani(phone:phone)),
      );
    } else {
      // Yeni taksici -> kayıt ekranına
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TaksiKayitEkrani(phone: phone)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Taksici Giriş / Kayıt")),
      backgroundColor: Color(0xFFCC9933),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Telefon Numaranızı Girin'),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: '5XX XXX XXXX'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _devamEt,
              child: Text('Devam Et'),
            ),
          ],
        ),
      ),
    );
  }
}

