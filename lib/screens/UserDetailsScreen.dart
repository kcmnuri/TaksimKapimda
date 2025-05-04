import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:taksim_kapimda/screens/home_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  final String phoneNumber;

  UserDetailsScreen({required this.phoneNumber});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedGender = 'Erkek';
  bool _obscurePassword = true;
  final _databaseRef = FirebaseDatabase.instance.ref().child("Uyeler_Tablo");

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _saveUserDetails() async {
    String name = _nameController.text.trim();
    String surname = _surnameController.text.trim();
    String age = _ageController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String gender = _selectedGender;

    if (name.isNotEmpty &&
        surname.isNotEmpty &&
        age.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        isValidEmail(email)) {

      // Firebase'e kullanıcı bilgilerini kaydet
      try {
        await _databaseRef.child(widget.phoneNumber).set({
          'name': name,
          'surname': surname,
          'age': age,
          'email': email,
          'password': password,
          'gender': gender,
          'nezaketPuani': 0,
        });

        // Başarılı olduğunda HomeScreen'e yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userPhone: widget.phoneNumber,)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu: $e')),
        );
      }
    } else if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geçerli bir e-posta adresi girin')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm bilgileri doldurun')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text('Kullanıcı Bilgileri'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: _buildInputDecoration('Ad', 'Adınızı girin'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _surnameController,
                decoration: _buildInputDecoration('Soyad', 'Soyadınızı girin'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration('Yaş', 'Yaşınızı girin'),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                items: <String>['Erkek', 'Kadın', 'Diğer']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration('E-posta', 'E-posta adresinizi girin'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: _buildInputDecoration('Şifre', 'Şifrenizi belirleyin').copyWith(
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
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveUserDetails,
                child: Text('Devam Et'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.yellow[700],
                  foregroundColor: Colors.black,
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

  InputDecoration _buildInputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white24,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
