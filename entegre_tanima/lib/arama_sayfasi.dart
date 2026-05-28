import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'database.dart';

class AramaSayfasi extends StatefulWidget {
  const AramaSayfasi({super.key});

  @override
  State<AramaSayfasi> createState() => _AramaSayfasiState();
}

class _AramaSayfasiState extends State<AramaSayfasi> {
  List<ElektronikParca> _bulunanParcalar = [];
  String _arananKelime = "";

  // Arama çubuğuna her harf girildiğinde tetiklenen fonksiyon
  void _aramaYap(String sorgu) {
    setState(() {
      _arananKelime = sorgu;
      if (sorgu.isEmpty) {
        _bulunanParcalar = []; // Kutu boşsa listeyi temizle
      } else {
        // Veritabanında filtreleme yap (Hem kodda hem isimde arar)
        _bulunanParcalar = parcaVeritabani.where((parca) {
          final kodKucuk = parca.kod.toLowerCase();
          final isimKucuk = parca.isim.toLowerCase();
          final arananKucuk = sorgu.toLowerCase();
          
          return kodKucuk.contains(arananKucuk) || isimKucuk.contains(arananKucuk);
        }).toList();
      }
    });
  }

  // Kameradaki aynı şık detay panelini burada da kullanıyoruz
  void _elemanDetayPaneliniGoster(BuildContext context, ElektronikParca parca) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(parca.kod, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
                    child: Text(parca.kategori, style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(parca.isim, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey)),
              const SizedBox(height: 15),
              Text(parca.aciklama, style: const TextStyle(fontSize: 14, height: 1.4)),
              const SizedBox(height: 20),
              const Text("Bacak Bağlantısı (Pinout):", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  parca.pinoutGorseli,
                  height: 150, fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Text("Görsel yüklenemedi", style: TextStyle(color: Colors.redAccent)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse(parca.datasheetUrl);
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      print("Link açılamadı: $url");
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Datasheet'i Gör (PDF)"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Veritabanında Ara"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ARAMA ÇUBUĞU (Google Tarzı)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: _aramaYap, // Her harf girildiğinde çalışır
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Örn: 74HC08 veya LM358...",
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // ARAMA SONUÇLARI LİSTESİ
          Expanded(
            child: _arananKelime.isNotEmpty && _bulunanParcalar.isEmpty
                ? const Center(
                    child: Text("Sonuç bulunamadı", style: TextStyle(fontSize: 18, color: Colors.grey)),
                  )
                : ListView.builder(
                    itemCount: _bulunanParcalar.length,
                    itemBuilder: (context, index) {
                      final parca = _bulunanParcalar[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: ListTile(
                          // Küçük Pinout Resmi
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              parca.pinoutGorseli,
                              width: 50, height: 50, fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                          title: Text(parca.kod, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(parca.isim, maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: const Icon(Icons.chevron_right, color: Colors.blueAccent),
                          onTap: () {
                            // Tıklandığında aynı detayı açar
                            _elemanDetayPaneliniGoster(context, parca);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}