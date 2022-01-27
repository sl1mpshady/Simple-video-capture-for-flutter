import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  void onOpenTap(BuildContext context) {
    Navigator.pushNamed(context, '/camera');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: Scaffold(
            body: Center(
          child: ElevatedButton(
              child: const Text('Open Camera'),
              onPressed: () => onOpenTap(context)),
        )));
  }
}
