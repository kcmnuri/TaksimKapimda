import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:taksim_kapimda/profilescreens/ChangePasswordScreen.dart';
import 'package:taksim_kapimda/profilescreens/PrivacyPolicyScreen.dart';

class SettingsAndSecurity extends StatefulWidget {
  final String phoneNumber;

  SettingsAndSecurity({required this.phoneNumber});

  @override
  _SettingsAndSecurityState createState() => _SettingsAndSecurityState();
}

class _SettingsAndSecurityState extends State<SettingsAndSecurity> {
  final _database = FirebaseDatabase.instance.ref().child("Uyeler_Tablo");
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final snapshot = await _database.child(widget.phoneNumber).get();

    if (snapshot.exists) {
      setState(() {
        userData = Map<String, dynamic>.from(snapshot.value as Map);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı bilgileri bulunamadı.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar ve Güvenlik'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
          ? Center(child: Text("Veri bulunamadı."))
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingTile(
            icon: Icons.phone,
            title: 'Telefon Numarası',
            subtitle: widget.phoneNumber,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Telefon numarası değiştirilemez."),
                ),
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.lock,
            title: 'Şifre Değiştir',
            subtitle: 'Yeni şifre belirle',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordScreen(phoneNumber: widget.phoneNumber)));

            },
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip,
            title: 'Gizlilik Politikası',
            subtitle: 'Veri gizliliği hakkında bilgi',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicyScreen()));
            },
          ),
          _buildSettingTile(
            icon: Icons.delete,
            title: 'Hesabı Sil',
            subtitle: 'Tüm verileri kalıcı olarak sil',
            onTap: _confirmDeleteAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hesabı Sil'),
          content: Text('Hesabınızı kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _database.child(widget.phoneNumber).remove();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Hesap silindi.")),
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('Sil', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
