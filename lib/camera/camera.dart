import 'dart:math';

import 'package:camera/camera.dart';
import 'package:video/camera/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'utils.dart';

class Camera extends StatelessWidget {
  Camera({Key? key}) : super(key: key);
  final controller = Get.put(CustomCameraController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Obx(() => !controller.isInitialized.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(children: [
                  CameraPreview(controller.cameraController.value),
                  Positioned.fill(
                      child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
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
                                  onTap: controller.onVideoRecordTap,
                                  child: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Obx(() => CircularPercentIndicator(
                                            animateFromLastPercent: true,
                                            animation: true,
                                            radius: 45.0,
                                            lineWidth: 5.0,
                                            percent: min(
                                                controller.percentage.value, 1),
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
                                          ))),
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
                                      children: controller.sideButtons
                                          .map((sideBtn) => renderSidetool(
                                              label: sideBtn['label'],
                                              icon: sideBtn['icon'],
                                              action: sideBtn['action']))
                                          .toList())
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ])),
        ));
  }
}
