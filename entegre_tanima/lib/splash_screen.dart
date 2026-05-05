import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan rengini buradan değiştirebilirsin (Şu an beyaz)
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Projeye eklediğimiz logoyu ekrana basan widget
            Image.asset(
              'assets/images/logo.png',
              width: 250, // Logonun büyüklüğünü buradan ayarlayabilirsin
            ),
            const SizedBox(height: 30), // Logo ile yazı arasındaki boşluk
            
            // Uygulamanın adı veya havalı bir başlık
            const Text(
              'Entegre Tanıma Sistemi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 20),
            
            // Alt tarafa şık bir "yükleniyor" yuvarlağı ekleyelim, profesyonel dursun :)
            const CircularProgressIndicator(
              color: Colors.blueGrey,
            ), 
          ],
        ),
      ),
    );
  }
}
