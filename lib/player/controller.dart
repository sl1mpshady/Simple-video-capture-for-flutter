import 'package:video/camera/controller.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:video_player/video_player.dart';

class PlayerController extends GetxController {
  RxBool isInitalized = false.obs;
  VideoPlayerController videoPlayerController =
      Get.find<CustomCameraController>().videoPlayerController!;

  void onCloseTap() {
    videoPlayerController.setVolume(0);
    videoPlayerController.pause();
    videoPlayerController.dispose();
    Get.offAllNamed('/');
  }

  @override
  void onInit() async {
    super.onInit();

    videoPlayerController.initialize().then((value) {
      isInitalized.value = true;
      videoPlayerController.play();
      videoPlayerController.setLooping(true);
    });
  }

  @override
  void onClose() {
    videoPlayerController.setVolume(0);
    videoPlayerController.pause();
    videoPlayerController.dispose();
  }
}
