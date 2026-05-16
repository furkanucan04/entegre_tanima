import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'splash_screen.dart';
import 'database.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Entegre Tanıma',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(cameras: cameras),
    );
  }
}

class ScannerPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ScannerPage({super.key, required this.cameras});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late CameraController _cameraController;
  late TextRecognizer _textRecognizer;
  String _recognizedText = "Yazı aranıyor...";
  bool _isProcessing = false;
  bool _isDialogShowing = false; // Ekranda pencere açık mı kontrolü

  // Kameradan gelen metni analiz edip veritabanında arayan fonksiyon
  ElektronikParca? parcaBul(String okunanMetin) {
    String temizMetin = okunanMetin.toUpperCase();

    for (var parca in parcaVeritabani) {
      if (temizMetin.contains(parca.kod)) {
        return parca;
      }
    }
    return null; 
  }

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.cameras[0], 
      ResolutionPreset.high,
      enableAudio: false, 
      imageFormatGroup: ImageFormatGroup.nv21, 
    );
    
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    _cameraController.initialize().then((_) {
      if (!mounted) return;
      _cameraController.startImageStream((CameraImage image) {
        if (!_isProcessing) {
          _processImage(image);
        }
      });
      setState(() {});
    });
  }

  Future<void> _processImage(CameraImage image) async {
    _isProcessing = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final InputImage inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotationValue.fromRawValue(widget.cameras[0].sensorOrientation) ?? InputImageRotation.rotation0deg,
          format: InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      // --- YENİ: KOORDİNAT FİLTRELEME SİSTEMİ ---
      // --- YENİ: KOORDİNAT FİLTRELEME SİSTEMİ ---
      String odaklanmisMetin = "";

      double imgWidth = image.width.toDouble();
      double imgHeight = image.height.toDouble();
      
      // Sensör yönüne göre resim boyutlarını düzelt
      if (widget.cameras[0].sensorOrientation == 90 || widget.cameras[0].sensorOrientation == 270) {
        imgWidth = image.height.toDouble();
        imgHeight = image.width.toDouble();
      }

      // 1. DÜZELTME: AppBar'ın kapladığı alan yüzünden sanal kutuyu %5 (0.05) oranında aşağı kaydırıyoruz.
      double imgCenterX = imgWidth / 2;
      double imgCenterY = (imgHeight / 2) + (imgHeight * 0.05); 

      // 2. DÜZELTME: Kutunun yüksekliğini 0.30'dan 0.22'ye düşürerek üstten ve alttan daraltıyoruz.
      Rect hedefKutu = Rect.fromCenter(
        center: Offset(imgCenterX, imgCenterY),
        width: imgWidth * 0.6,  
        height: imgHeight * 0.22, 
      );

      // Kameranın bulduğu tüm metin bloklarını (parçalarını) tek tek gez
      for (TextBlock block in recognizedText.blocks) {
        // Okunan yazının ekrandaki tam merkez noktasını (koordinatını) bul
        Offset metinMerkezi = Offset(
          block.boundingBox.left + (block.boundingBox.width / 2),
          block.boundingBox.top + (block.boundingBox.height / 2),
        );

        // Eğer bu yazı, bizim merkezdeki sanal yeşil kutumuzun İÇİNDEYSE listeye al
        if (hedefKutu.contains(metinMerkezi)) {
          odaklanmisMetin += block.text + " ";
        }
      }
      // -----------------------------------------

      if (mounted) {
        setState(() {
          // Artık recognizedText.text yerine, sadece süzdüğümüz odaklanmisMetin'e bakıyoruz
          if (odaklanmisMetin.trim().isEmpty) { 
            _recognizedText = "Çerçeveye entegre yerleştirin...";
          } else {
            _recognizedText = odaklanmisMetin; 
            
            // Veritabanı motorumuza sadece çerçevenin içindeki yazıyı gönderiyoruz
            ElektronikParca? bulunanParca = parcaBul(odaklanmisMetin); 
            
            if (bulunanParca != null && !_isDialogShowing) {
              _isDialogShowing = true; 
              _sonucPenceresiGoster(bulunanParca); 
            }
          }
        });
      }
    } catch (e) {
      print("ML KIT HATASI: $e");
    } finally {
      _isProcessing = false;
    }
  }

  // Parça bulunduğunda ekranın altından kayarak açılan şık bilgi kartı
  // Parça bulunduğunda ekranın altından kayarak açılan şık bilgi kartı
  void _sonucPenceresiGoster(ElektronikParca parca) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ekranın büyük kısmını kaplamasına izin ver
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    parca.kod,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  Chip(
                    label: Text(parca.kategori, style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.blueGrey,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                parca.isim,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const Divider(height: 30, thickness: 1),
              
              // AÇIKLAMA KISMI
              const Text("Teknik Detay:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 5),
              Text(
                parca.aciklama,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              // PİNOUT GÖRSELİ KISMI
              const Text("Pinout (Bacak Yapısı):", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  parca.pinoutGorseli,
                  height: 150,
                  // Eğer resmi klasöre henüz koymadıysan program çökmesin diye koruma ekledik:
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Görsel 'assets/images/' klasöründe bulunamadı.\nLütfen resmi projeye ekleyin.", 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              
              // BUTONLAR (Datasheet ve Devam Et)
              Row(
                children: [
                  // Datasheet Butonu (PDF)
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () async {
                        final Uri url = Uri.parse(parca.datasheetUrl);
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          print("Link açılamadı: $url");
                        }
                      },
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                      label: const Text("Datasheet", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Kapatma Butonu
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Devam Et", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    ).then((value) {
      if (mounted) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _isDialogShowing = false; 
          });
        });
      }
    });
  }

  // Arkadaşının tasarladığı karartmalı odak ekranı
  Widget buildScannerOverlay(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut, // srcOver yerine srcOut kullandık ki ortası şeffaf olsun
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Center(
              child: Container(
                width: 280,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.black, // Bu kısım srcOut sayesinde şeffaf olacak
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 280,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Entegre Tarayıcı')),
      body: Stack(
        children: [
          CameraPreview(_cameraController),
          buildScannerOverlay(context), // Odak çerçevesi eklendi
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _recognizedText,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
} // BÜTÜN SINIF İŞTE ŞİMDİ BURADA KAPANIYOR!