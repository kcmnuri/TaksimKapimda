import 'package:flutter/material.dart';
class TaksiAnasayfa extends StatefulWidget {
  const TaksiAnasayfa({super.key});

  @override
  State<TaksiAnasayfa> createState() => _TaksiAnasayfaState();
}

class _TaksiAnasayfaState extends State<TaksiAnasayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFCC9933),

      ),

      body: Row(
        children: [
          Container(
            child: Text("Taksi Anasayfa"),
          )
        ],
      ),
    );
  }
}
