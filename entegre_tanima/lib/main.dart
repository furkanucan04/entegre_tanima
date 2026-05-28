import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart'; // WriteBuffer hatasını çözen paket
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  bool _isPanelOpen = false;

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

      setState(() {
        if (recognizedText.text.isEmpty) {
          _recognizedText = "Yazı aranıyor...";
        } else {
          String okunankod = recognizedText.text.trim().toUpperCase();
          _recognizedText = recognizedText.text;

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
    } catch (e) {
      debugPrint("ML KIT HATASI: $e");
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
      // BUTONU BURAYA, SCAFFOLD'UN İÇİNE EKLİYORUZ
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.search),
        onPressed: () {
          showSearch(
            context: context,
            delegate: EntegreAramaDelegate(),
          );
        },
      ),  
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

  Widget buildScannerOverlay(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
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
                  errorBuilder: (context, error, stackTrace) => const Text("Görsel yüklenemedi"),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final Uri url = Uri.parse('https://www.alldatasheet.com/');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    debugPrint('Datasheet açılamadı.');
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
          ], // Column listesini kapatır
        ), // Column'u kapatır
      ); // Container veya Padding'i kapatır
    }, // builder'ı kapatır
    ).then((_) {
      _isPanelOpen = false;
    });
  } // _elemanDetayPaneliniGoster fonksiyonunu kapatır
}

class EntegreAramaDelegate extends SearchDelegate<String> {
  // Veritabanındaki entegrelerin listesi (Burayı kendi elinizdeki entegrelerle değiştirebilirsiniz)
  final List<String> tumEntegreler = [
    '74LS08', 'NE555', 'LM317', 'BC547', 'IRFZ44N', 'ATMEGA328P', 'TIP120'
  ];

  @override
  String get searchFieldLabel => 'Entegre ara...';

  // Arama çubuğunun sağındaki (X) temizle butonu
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; 
        },
      ),
    ];
  }

  // Arama çubuğunun solundaki (<-) geri dön butonu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); 
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(child: Text('Lütfen listeden bir entegre seçin.'));
  }

  // Kullanıcı harfleri yazarken çalışan anlık filtreleme
  @override
  Widget buildSuggestions(BuildContext context) {
    final oneriler = tumEntegreler.where((entegre) {
      return entegre.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: oneriler.length,
      itemBuilder: (context, index) {
        final entegre = oneriler[index];
        return ListTile(
              leading: Image.asset(
                'assets/images/${entegre.toLowerCase()}_pinout.png',
                width: 50,
                height: 50,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return const Icon(Icons.memory);
                },
              ), // <-- İŞTE EKSİK OLAN KAPATMA PARANTEZİ VE VİRGÜL BURADA
              title: Text(entegre),
              onTap: () {
                // Kullanıcı listedeki entegreye tıkladığında arama ekranını kapatır
                close(context, entegre); 
              },
            );
      },
    );
  }
}