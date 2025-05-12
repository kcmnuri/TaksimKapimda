import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'TaksiAnasayfa.dart';

class TaksiLoginEkrani extends StatefulWidget {
  final String phone;

  TaksiLoginEkrani({required this.phone});

  @override
  _TaksiLoginEkraniState createState() => _TaksiLoginEkraniState();
}

class _TaksiLoginEkraniState extends State<TaksiLoginEkrani> {
  final TextEditingController _sifreController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  Future<void> _girisYap() async {
    final girilenSifre = _sifreController.text.trim();

    if (girilenSifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen şifrenizi girin")),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    final ref = FirebaseDatabase.instance.ref('Taksiciler_Tablo/${widget.phone}');
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.child('sifre').value != null) {
      final kayitliSifre = snapshot.child('sifre').value.toString();

      if (kayitliSifre == girilenSifre) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TaksiAnasayfa(telefon: widget.phone,)),

        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Şifre yanlış")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt bulunamadı")),
      );
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Taksici Giriş")),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Şifrenizi girin",style: TextStyle(color: Colors.grey[700], fontSize: 15),
              textAlign: TextAlign.center,)
            ,
            TextField(
              controller: _sifreController,
              obscureText: true,
              decoration: InputDecoration(
              labelText: 'Şifre',
              labelStyle: TextStyle(color: Colors.grey[800]),
              hintText: 'Şifrenizi girin',
              hintStyle: TextStyle(color: Colors.grey[800]),
              filled: true,
              fillColor: Colors.white24,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _girisYap,
              child: Text("Giriş Yap"),
            ),
          ],
        ),
      ),
    );
  }
}
