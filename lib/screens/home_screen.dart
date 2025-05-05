import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:taksim_kapimda/homeScreens/profile.dart';
import 'package:taksim_kapimda/homeScreens/kampanyalar.dart';
import 'package:taksim_kapimda/homeScreens/yardim.dart';
import 'package:taksim_kapimda/homeScreens/gecmisyolculuklar.dart';
import 'package:taksim_kapimda/screens/BekleyenIslemlerScreen.dart';

import 'TaksiCagirScreen.dart';

class HomeScreen extends StatefulWidget {
  final String userPhone; // Kullanıcı telefon numarasıyla firebase datasına eriş
  const HomeScreen({required this.userPhone});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String surname = "";
  String email = "";
  String get fullName => "$name $surname";

  late GoogleMapController mapController;
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    getCurrentLocation();
  }

  void fetchUserData() {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("Uyeler_Tablo")
        .child(widget.userPhone);

    ref.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          name = data['name'] ?? '';
          surname = data['surname'] ?? '';
          email = data['email'] ?? '';
        });
      }
    });
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData _locationData = await location.getLocation();
    setState(() {
      currentLocation = _locationData;
    });
  }


  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Günaydın";
    if (hour < 18) return "İyi Öğlenler";
    return "İyi Akşamlar";
  }

  @override
  Widget build(BuildContext context) {
    final greetingMessage = getGreeting();

    return Scaffold(
      appBar: AppBar(
        title: Text("TAKSİM KAPIMDA"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(fullName),
              accountEmail: Text(email),
              decoration: BoxDecoration(color: Colors.deepPurple),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blueGrey),
              ),
            ),
            ListTile(
              title: Text(
                '$greetingMessage $fullName!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              enabled: false,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Hesabım'),
              onTap: () {

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile(phoneNumber: widget.userPhone)));
              }
              ),
            ListTile(
              leading: Icon(Icons.add_alert),
              title: Text('Bekleyen İşlemler'),
              onTap: () =>  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BekleyenIslemlerSayfasi(telefon: widget.userPhone,))),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Geçmiş Yolculuklarım'),
              onTap: () =>  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Gecmisyolculuklar())),
            ),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text('Kampanyalar'),
              onTap: () =>  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Kampanyalar())),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Yardım'),
              onTap: () =>  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Yardim())),
            ),
          ],
        ),
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => TaksiCagirSayfasi(
            name: name,
            surname: surname,
            phone: widget.userPhone,
            email: email,
          ),
          ),);
        },
        label: Text('Taksi Çağır'),
        icon: Icon(Icons.local_taxi),
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
      ),
    );
  }
}
