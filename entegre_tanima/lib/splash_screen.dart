import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Kamera kütüphanesini ekledik
import 'main.dart'; // Ana sayfanın kodlarını buraya çağırıyoruz

class SplashScreen extends StatefulWidget {
  final List<CameraDescription> cameras; // Kameraları tutacak değişken eklendi
  
  const SplashScreen({super.key, required this.cameras}); // Kurucu metoda eklendi

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3 saniyelik kronometre başlatıyoruz
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // DİKKAT: Kameraları asıl sayfaya burada teslim ediyoruz ve 'const'u kaldırdık
          builder: (context) => ScannerPage(cameras: widget.cameras), 
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 250,
            ),
            const SizedBox(height: 30),
            const Text(
              'Entegre Tanıma Sistemi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}