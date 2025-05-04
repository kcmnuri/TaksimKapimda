import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String phoneNumber;

  ChangePasswordScreen({required this.phoneNumber});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  final _database = FirebaseDatabase.instance.ref().child("Uyeler_Tablo");

  void _changePassword() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Yeni şifreler uyuşmuyor")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Veritabanından mevcut şifreyi al
      final snapshot = await _database.child(widget.phoneNumber).get();
      if (snapshot.exists) {
        final userData = Map<String, dynamic>.from(snapshot.value as Map);

        // Mevcut şifreyi doğrula
        if (userData['password'] == oldPassword) {
          // Yeni şifreyi güncelle
          await _database.child(widget.phoneNumber).update({
            'password': newPassword,
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Şifre başarıyla değiştirildi")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mevcut şifre yanlış")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kullanıcı bulunamadı")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Şifre Değiştir")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mevcut Şifre'),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Yeni Şifre'),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Yeni Şifreyi Onayla'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _changePassword,
              child: Text('Şifreyi Değiştir'),
            ),
          ],
        ),
      ),
    );
  }
}
