import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart'; // Import Custom Widgets

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(
                  244, 238, 255, 1), // Warna latar belakang
              borderRadius: BorderRadius.circular(10), // Radius sudut
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Tentang Pembuat',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('assets/images/profile.png'), // Gambar profil
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ainun Alvia Fauziah',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Seorang mahasiswa ambisius dan penuh semangat, sedang mengejar gelar S1 Teknik Informatika di Institut Teknologi Garut. la berdedikasi untuk mengembangkan keterampilan di bidang pemrograman dan desain grafis, serta pernah berpengalaman sebagai asisten dosen dalam mata kuliah praktikum grafik komputer.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
