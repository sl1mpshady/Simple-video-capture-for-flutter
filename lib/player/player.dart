import 'package:video/player/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class Player extends StatelessWidget {
  Player({Key? key}) : super(key: key);

  final controller = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Obx(() => !controller.isInitalized.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(children: [
                    AspectRatio(
                      aspectRatio:
                          controller.videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(controller.videoPlayerController),
                    ),
                    Positioned(
                      top: 50,
                      left: 10,
                      child: GestureDetector(
                        onTap: () => controller.onCloseTap(),
                        child: const SizedBox(
                          width: 50,
                          child: Icon(
                            CupertinoIcons.clear,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ]))));
  }
}
