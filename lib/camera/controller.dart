import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';

class CustomCameraController extends GetxController {
  RxDouble percentage = 0.0.obs;
  Rx<DateTime?> recordingStarted = null.obs;
  Rx<CameraController> cameraController =
      CameraController(cameras.first, ResolutionPreset.max).obs;
  RxBool isInitialized = false.obs;
  Timer? timer;
  bool isFrontCam = false;
  File? videoFile;
  VideoPlayerController? videoPlayerController;
  final double maxSeconds = 30;

  late List<Map<String, dynamic>> sideButtons = [];

  @override
  void onInit() async {
    super.onInit();
    initializeCamera();

    sideButtons = [
      {
        'label': 'Flip',
        'icon': CupertinoIcons.arrow_2_circlepath,
        'action': () => onNewCameraSelected()
      },
      {'label': 'Speed', 'icon': CupertinoIcons.speedometer},
      {'label': 'Filters', 'icon': CupertinoIcons.color_filter},
      {'label': 'Beautify', 'icon': CupertinoIcons.bitcoin_circle_fill},
    ];
  }

  void initializeCamera() {
    cameraController.value.initialize().then((_) {
      isInitialized.value = true;
    });
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController controller = cameraController.value;
    return controller.stopVideoRecording();
  }

  void onPreviewVideo() {
    stopVideoRecording().then((file) {
      if (file != null) {
        videoFile = File(file.path);
        videoPlayerController = VideoPlayerController.file(
          videoFile!,
        );
        Get.offNamed('/player');
      }
    });
  }

  void onVideoRecordTap() async {
    final CameraController controller = cameraController.value;
    if (cameraController.value.value.isRecordingVideo) {
      controller.stopVideoRecording();
      percentage.value = 0;
      recordingStarted.value = null;
      timer?.cancel();
      onPreviewVideo();
    } else {
      await controller.startVideoRecording();
      final DateTime dateTime = DateTime.now();
      timer = Timer.periodic(const Duration(milliseconds: 1), (Timer t) {
        percentage.value =
            (DateTime.now().difference(dateTime).inSeconds / maxSeconds);
        if (percentage > 1) {
          t.cancel();
          onPreviewVideo();
          percentage.value = 0;
        }
      });

      recordingStarted.value = dateTime;
      percentage.value = 0;
    }
  }

  void onNewCameraSelected() async {
    isFrontCam = !isFrontCam;

    final previousCameraController = cameraController.value;
    final CameraController newCameraController = CameraController(
        !isFrontCam ? cameras.first : cameras.last, ResolutionPreset.ultraHigh);
    isInitialized.value = false;
    await previousCameraController.dispose();
    cameraController.value = newCameraController;
    initializeCamera();
  }

  void onCloseTap() {
    Get.back();
  }
}
