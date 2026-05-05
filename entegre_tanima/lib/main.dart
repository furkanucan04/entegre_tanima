import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'splash_screen.dart';

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

  @override
  void initState() {
    super.initState();
    // KAMERAYI YAPAY ZEKANIN ANLAYACAĞI FORMATTA BAŞLATIYORUZ
    _cameraController = CameraController(
      widget.cameras[0], 
      ResolutionPreset.high,
      enableAudio: false, // Mikrofonu kapattık, hız artacak
      imageFormatGroup: ImageFormatGroup.nv21, // <--- SİHİRLİ KOD BURASI (Android için şart)
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
      
      setState(() {
        if (recognizedText.text.isEmpty) {
          _recognizedText = "Yazı aranıyor...";
        } else {
          _recognizedText = recognizedText.text; 
        }
      });
    } catch (e) {
      print("ML KIT HATASI: $e");
    } finally {
      _isProcessing = false;
    }
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
          CameraPreview(_cameraController),// Bizim eklediğimiz yeşil tarama çerçevesi
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
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              color: Colors.black87,
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
Widget buildScannerOverlay(BuildContext context) {
  return Stack(
    children: [
      // Ekranın geri kalanını hafif karartmak için
      ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.5),
          BlendMode.srcOver,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
        ),
      ),
      // Tam ortadaki yeşil çerçeve (Entegre alanı)
      Center(
        child: Container(
          width: 280, // Genişlik
          height: 180, // Yükseklik (Entegre şekline uygun)
          decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent, width: 3),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ],
  );
}