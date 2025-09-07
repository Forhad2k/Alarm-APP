import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var pageIndex = 0.obs;
  final pageController = PageController();

  void nextPage() {
    if (pageIndex.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      goToHome();
    }
  }

  void skipToEnd() {
    pageController.jumpToPage(2);
  }

  void goToHome() {
    Get.offAllNamed("/location");
  }
}
