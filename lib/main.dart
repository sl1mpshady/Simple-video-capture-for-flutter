import 'package:camera/camera.dart';
import 'package:video/camera/camera.dart';
import 'package:video/home.dart';
import 'package:video/player/player.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/camera': (context) => Camera(),
        '/player': (context) => Player()
      },
    );
  }
}
