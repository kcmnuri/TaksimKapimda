
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taksim_kapimda/screens/UserDetailsScreen.dart';
import 'package:taksim_kapimda/screens/login_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final refNumber = FirebaseDatabase.instance.ref().child("Uyeler_Tablo");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Telefon Numaranızı Girin'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone,
                size: 100,
                color: Colors.black,
              ),
              SizedBox(height: 20),
              Text(
                'Telefon numaranızı girin ve devam edin.',
                style: TextStyle(color: Colors.grey[700], fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                  _PhoneNumberFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'Telefon Numarası',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: '(5XX) XXX XX XX',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _checkPhoneNumber,
                child: Text('Başla'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkPhoneNumber() async {
    String phoneNumber = _phoneController.text.replaceAll(RegExp(r'\D'), '');

    if (phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen geçerli bir telefon numarası girin')),
      );
      return;
    }

    try {
      final snapshot = await refNumber.child(phoneNumber).get();

      if (snapshot.exists) {
        // Kayıt varsa login ekranına git
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen(phoneNumber:phoneNumber)),
        );
      } else {
        // Kayıt yoksa yeni kayıt ekranına git
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserDetailsScreen(phoneNumber: phoneNumber)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';

    if (digitsOnly.length >= 1) {
      formatted += '(' + digitsOnly.substring(0, digitsOnly.length.clamp(0, 3));
    }

    if (digitsOnly.length > 3) {
      formatted += ') ' + digitsOnly.substring(3, digitsOnly.length.clamp(3, 6));
    }

    if (digitsOnly.length > 6) {
      formatted += ' ' + digitsOnly.substring(6, digitsOnly.length.clamp(6, 8));
    }

    if (digitsOnly.length > 8) {
      formatted += ' ' + digitsOnly.substring(8, digitsOnly.length.clamp(8, 10));
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}


