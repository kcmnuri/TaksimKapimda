import 'package:flutter/material.dart';
import 'package:taksim_kapimda/screens/PhoneNumberScreen.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  // Sayfa navigasyonu işlemi
  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Column(
        children: [
          // Uygulama ikonunu gösterelim
          Container(
            padding: EdgeInsets.only(top: 100),
            child: Icon(
              Icons.local_taxi, // İkonu değiştirebilirsiniz
              size: 100,
              color: Colors.white,
            ),
          ),
          // Sayfa Görüntüleyicisi
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                // 1. Adım
                _buildPage(
                  'Kibar Olun',
                  'Uygulamamızda hem taksiciler hem de müşteriler birbirini puanlar. Nezaket puanınız, deneyiminizi doğrudan etkiler.',
                  isLastPage: false,
                ),
                // 2. Adım
                _buildPage(
                  'Puanlama Sistemi',
                  'Puanlama yaparken, yüksek puanlı taksiciler ve müşteriler öne çıkacak. Düşük puanlar, hizmette zorluk yaşamanıza yol açabilir.',
                  isLastPage: false,
                ),
                // 3. Adım
                _buildPage(
                  'Güvenli Yolculuklar',
                  'Hedefimiz güvenli ve keyifli bir yolculuk deneyimi sunmaktır. Hem şoförler hem de müşteriler birbirlerini değerlendirebilir.',
                  isLastPage: true,
                ),
              ],
            ),
          ),
          // Sayfa Navigasyon Düğmeleri
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: _currentPage == index ? 30 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.yellow : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),
          SizedBox(height: 30),
          // Buton kısmı
          _currentPage < 2
              ? ElevatedButton(
            onPressed: _goToNextPage,
            child: Text(
              'Devam Et',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700],
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          )
              : ElevatedButton(
            onPressed: () {
              // Giriş ekranına yönlendiriyoruz
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PhoneNumberScreen()),
              );
            },
            child: Text(
              'Başla',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700],
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Sayfa içeriği oluşturma fonksiyonu
  Widget _buildPage(String title, String description, {required bool isLastPage}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
