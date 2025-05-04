import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Yardim extends StatefulWidget {
  const Yardim({super.key});

  @override
  State<Yardim> createState() => _YardimState();
}

class _YardimState extends State<Yardim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yardım Merkezi"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Sıkça Sorulan Sorular",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFaqItem(
            question: "1. Taksiyi nasıl çağırabilirim?",
            answer: "Ana sayfadaki haritadan en yakın müsait taksiyi seçip 'Taksi Çağır' butonuna basarak çağırabilirsiniz.",
          ),
          _buildFaqItem(
            question: "2. Şoför ile nasıl iletişim kurarım?",
            answer: "Taksi çağırma işleminden sonra açılan ekrandaki 'Ara' butonuyla iletişime geçebilirsiniz.",
          ),
          _buildFaqItem(
            question: "3. Yolculuk sonunda nasıl puan veririm?",
            answer: "Yolculuk bittikten sonra karşınıza çıkan değerlendirme ekranından şoföre puan verebilirsiniz.",
          ),
          _buildFaqItem(
            question: "4. Bir şikayetim var, nereye başvurmalıyım?",
            answer: "Aşağıdaki 'Destek ile İletişime Geç' butonuna tıklayarak şikayetinizi bize iletebilirsiniz.",
          ),
          _buildFaqItem(
            question: "5. Taksici nasıl olurum?",
            answer: "Hesabım kısmındaki menüden taksici modu ile olabilirsiniz",
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              final Uri whatsappUrl = Uri.parse("https://wa.me/905469723899"); // <- DESTEK TELEFONU
              if (await canLaunchUrl(whatsappUrl)) {
                await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("WhatsApp bağlantısı açılamadı.")),
                );
              }
            },
            icon: const Icon(Icons.support_agent),
            label: const Text("Destek ile İletişime Geç"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(answer),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
