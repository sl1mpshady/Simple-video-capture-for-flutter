import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:video/camera/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  bool isRecording = false;
  DateTime? recordingStarted;
  late CameraController controller;
  Timer? timer;
  double percentage = 0;
  final List<Map<String, dynamic>> sideButtons = [
    {'label': 'Flip', 'icon': CupertinoIcons.arrow_2_circlepath},
    {'label': 'Speed', 'icon': CupertinoIcons.speedometer},
    {'label': 'Filters', 'icon': CupertinoIcons.color_filter},
    {'label': 'Beautify', 'icon': CupertinoIcons.bitcoin_circle_fill},
  ];

  @override
  void initState() {
    initCameraController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initCameraController() async {
    final List<CameraDescription> cameras = await availableCameras();

    controller = CameraController(cameras.first, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void onVideoRecordTap() async {
    if (controller.value.isRecordingVideo) {
      controller.stopVideoRecording();
      setState(() {
        isRecording = false;
        recordingStarted = null;
      });
    } else {
      await controller.startVideoRecording();
      final DateTime dateTime = DateTime.now();
      Timer.periodic(const Duration(milliseconds: 1), (Timer t) {
        percentage = DateTime.now().difference(dateTime).inSeconds / 30;
        if (percentage > 1) {
          t.cancel();
        }
        setState(() {
          isRecording = percentage >= 1 ? false : isRecording;
        });
      });
      setState(() {
        isRecording = true;
        recordingStarted = dateTime;
        percentage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: !controller.value.isInitialized
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(children: [
                  CameraPreview(controller),
                  Positioned.fill(
                      child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            width: 50,
                            child: Icon(
                              CupertinoIcons.clear,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 2.5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.5)),
                                  child: const Text(
                                    'Button',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: onVideoRecordTap,
                                  child: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: CircularPercentIndicator(
                                        animateFromLastPercent: true,
                                        animation: true,
                                        radius: 45.0,
                                        lineWidth: 5.0,
                                        percent: min(percentage, 1),
                                        animationDuration: 1000,
                                        progressColor: Colors.blue,
                                        backgroundColor: Colors.transparent,
                                        center: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 45, 85, 0.3),
                                              shape: BoxShape.circle),
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    width: 2),
                                                color: const Color.fromRGBO(
                                                    255, 45, 85, 0.5),
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: 50,
                              child: Column(
                                children: [
                                  Column(
                                      children: sideButtons
                                          .map((sideBtn) => renderSidetool(
                                              label: sideBtn['label'],
                                              icon: sideBtn['icon']))
                                          .toList())
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ]),
        ));
  }
}
