import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gizlilik Politikası"),
        backgroundColor: Colors.white12,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Gizlilik Politikası",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Şirketimiz, kullanıcılarının gizliliğine ve kişisel verilerine büyük önem verir. Kullanıcılarımıza daha iyi hizmet sunabilmek için belirli verileri toplar ve işleriz. Bu gizlilik politikası, kişisel verilerinizin nasıl toplandığını, kullanıldığını ve korunduğunu açıklar.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "1. Topladığımız Veriler",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Kişisel bilgileriniz, yalnızca hizmetlerimizi sunmak amacıyla toplanır. Topladığımız bilgiler arasında şunlar yer alabilir:\n\n"
                    "• Ad ve soyad\n"
                    "• Telefon numarası\n"
                    "• E-posta adresi\n"
                    "• Yaş, cinsiyet ve diğer demografik bilgiler\n"
                    "• Kullanıcı geri bildirimleri ve değerlendirmeleri\n",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "2. Verilerin Kullanımı",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Topladığımız veriler, aşağıdaki amaçlarla kullanılabilir:\n\n"
                    "• Hizmetlerimizi sağlamak, iyileştirmek ve kişiselleştirmek\n"
                    "• Kullanıcı deneyimini geliştirmek\n"
                    "• Kullanıcı taleplerine ve geri bildirimlerine yanıt vermek\n"
                    "• Kullanıcıları bilgilendirmek, duyurular yapmak\n"
                    "• Güvenlik ve doğrulama işlemleri\n",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "3. Verilerin Korunması",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Verilerinizin güvenliğini sağlamak için uygun güvenlik önlemleri alıyoruz. Kişisel verileriniz yalnızca yetkilendirilmiş kişiler tarafından erişilebilir ve üçüncü şahıslarla paylaşılmaz. Ancak, yasal zorunluluklar veya kullanıcı güvenliği durumunda verileriniz üçüncü şahıslarla paylaşılabilir.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "4. Üçüncü Taraf Bağlantıları",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Uygulamamızda, üçüncü taraflara ait web sitelerine veya hizmetlere bağlantılar bulunabilir. Bu bağlantılar, yalnızca kullanıcıları bilgilendirme amacıyla sunulmaktadır. Üçüncü tarafların gizlilik politikaları bizim politikamızdan farklı olabilir, bu nedenle bu bağlantılara tıkladığınızda kendi gizlilik politikalarını incelemeniz önemlidir.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "5. Veri Saklama Süresi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Kişisel verileriniz, belirli bir süre boyunca saklanır. Bu süre, hizmetlerin sağlanması için gerekli olduğu sürece ve yasal zorunluluklara uymak için geçerlidir. Verilerinizin saklanma süresi sona erdiğinde, verileriniz güvenli bir şekilde silinir.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "6. Kullanıcı Hakları",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Kullanıcılar, topladığımız kişisel verilere erişme, verileri güncelleme veya silme hakkına sahiptir. Bu haklarınızı kullanmak için bizimle iletişime geçebilirsiniz.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "7. Politika Değişiklikleri",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Gizlilik politikamız zaman zaman güncellenebilir. Değişiklikler bu sayfada yayınlanacaktır. Bu nedenle, gizlilik politikamızı düzenli olarak gözden geçirebilirsiniz.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "İletişim",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Gizlilik politikası ile ilgili herhangi bir sorunuz varsa, lütfen bizimle iletişime geçin:\n\n"
                    "E-posta: kcmnuri.com\n"
                    "Telefon: 0546-972-3899",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
