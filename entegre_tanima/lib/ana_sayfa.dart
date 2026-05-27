import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'main.dart'; // Kameraya gitmek için ScannerPage'i alır
import 'arama_sayfasi.dart'; // Aramaya gitmek için

class AnaSayfa extends StatelessWidget {
  final List<CameraDescription> cameras;
  const AnaSayfa({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Entegre Tanıma Sistemi"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. BUTON: KAMERAYA OKUT
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ScannerPage(cameras: cameras)));
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 50, color: Colors.white),
                    SizedBox(width: 20),
                    Text("Kameraya Okut", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // 2. BUTON: ARAYARAK BUL
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AramaSayfasi()));
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 50, color: Colors.white),
                    SizedBox(width: 20),
                    Text("Arayarak Bul", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}