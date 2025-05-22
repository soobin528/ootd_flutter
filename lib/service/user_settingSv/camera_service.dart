import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

Future<void> openCamera(BuildContext context) async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CameraScreen()),
  );
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('카메라 화면')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('📸 사진 저장됨: ${image.path}')),
            );
          } catch (e) {
            print('❌ 오류 발생: $e');
          }
        },
      ),
    );
  }
}
