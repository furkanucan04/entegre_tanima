import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'splash_screen.dart';
import 'database.dart';

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
      debugShowCheckedModeBanner: false, 
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
  bool _isPanelOpen = false;
  bool _isProcessing = false;

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
      
      String odaklanmisMetin = "";
      double imgWidth = image.width.toDouble();
      double imgHeight = image.height.toDouble();
      
      if (widget.cameras[0].sensorOrientation == 90 || widget.cameras[0].sensorOrientation == 270) {
        imgWidth = image.height.toDouble();
        imgHeight = image.width.toDouble();
      }

      double imgCenterX = imgWidth / 2;
      double imgCenterY = (imgHeight / 2) + (imgHeight * 0.05); 

      Rect hedefKutu = Rect.fromCenter(
        center: Offset(imgCenterX, imgCenterY),
        width: imgWidth * 0.6,  
        height: imgHeight * 0.22, 
      );

      for (TextBlock block in recognizedText.blocks) {
        Offset metinMerkezi = Offset(
          block.boundingBox.left + (block.boundingBox.width / 2),
          block.boundingBox.top + (block.boundingBox.height / 2),
        );

        if (hedefKutu.contains(metinMerkezi)) {
          odaklanmisMetin += block.text + " ";
        }
      }

      if (mounted) {
        setState(() {
          if (odaklanmisMetin.trim().isEmpty) {
            _recognizedText = "Çerçeveye entegre yerleştirin...";
          } else {
            String okunankod = odaklanmisMetin.trim().toUpperCase();
            _recognizedText = okunankod; 

            final bulunanParca = parcaVeritabani.firstWhere(
              (parca) => okunankod.contains(parca.kod.toUpperCase()),
              orElse: () => ElektronikParca(kod: '', kategori: '', isim: '', aciklama: '', datasheetUrl: '', pinoutGorseli: ''),
            );

            if (bulunanParca.kod.isNotEmpty && !_isPanelOpen) {
              _isPanelOpen = true; 
              _elemanDetayPaneliniGoster(context, bulunanParca); 
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

  void _elemanDetayPaneliniGoster(BuildContext context, ElektronikParca parca) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
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
                  height: 150,
                  fit: BoxFit.contain,
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
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() {
          _isPanelOpen = false;
        });
      }
    });
  }

  Widget buildScannerOverlay(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut, 
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
                  color: Colors.black, 
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
  void dispose() {
    _cameraController.dispose();
    _textRecognizer.close();
    super.dispose();
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
          buildScannerOverlay(context), 
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
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
}