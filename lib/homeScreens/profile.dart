import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:taksim_kapimda/profilescreens/SettingsAndSecurity.dart';
import 'package:taksim_kapimda/taksiScreens/Taksilogin.dart';

class Profile extends StatefulWidget {
  final String phoneNumber;

  Profile({required this.phoneNumber});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı bilgileri bulunamadı.")),
      );
    }
  }

  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add(Icon(Icons.star, color: Colors.amber));
      } else if (rating >= i - 0.5) {
        stars.add(Icon(Icons.star_half, color: Colors.amber));
      } else {
        stars.add(Icon(Icons.star_border, color: Colors.grey));
      }
    }
    return Row(children: stars);
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? '';
    final surname = userData?['surname'] ?? '';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Profil'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text("$name $surname"),
              accountEmail: Text(widget.phoneNumber),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(initials, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil Bilgileri'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.car_rental),
              title: Text('Taksici Modu'),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TaksiGecisKontrolEkrani())),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Yolculuk İstatistikleri'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ayarlar ve Güvenlik'),
              onTap: ()  => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SettingsAndSecurity(phoneNumber: widget.phoneNumber))),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Hesaptan Çıkış Yap'),
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
          ? Center(child: Text("Veri bulunamadı."))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                initials,
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "$name $surname",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              widget.phoneNumber,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            _buildProfileCard(
              icon: Icons.email,
              title: 'Email',
              content: Text(userData!['email']),
            ),
            _buildProfileCard(
              icon: Icons.cake,
              title: 'Yaş',
              content: Text(userData!['age']),
            ),
            _buildProfileCard(
              icon: Icons.wc,
              title: 'Cinsiyet',
              content: Text(userData!['gender']),
            ),
            _buildProfileCard(
              icon: Icons.star,
              title: 'Nezaket Puanı',
              content: _buildStarRating(
                double.tryParse(userData!['nezaketPuani'].toString()) ?? 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Çıkış Yapmak Üzeresiniz'),
          content: Text('Hesabınızdan çıkmak istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hayır'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Logout logic here
              },
              child: Text('Evet'),
            ),
          ],
        );
      },
    );
  }
}


