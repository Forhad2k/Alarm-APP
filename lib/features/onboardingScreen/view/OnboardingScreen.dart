import 'package:alarm/constants/App_color.dart';
import 'package:alarm/constants/onboarding_data.dart';
import 'package:alarm/features/OnboardingScreen/controller/OnboardingController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  final controller = Get.put(OnboardingController());


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xff212327),
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: (index) => controller.pageIndex.value = index,
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              final data = onboardingData[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      child: Image.asset(
                        data["image"]!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06,
                        vertical: height * 0.015,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["title"]!,
                            style: TextStyle(
                              fontSize: width * 0.08, // responsive font
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: height * 0.015),
                          Text(
                            data["subtitle"]!,
                            style: TextStyle(
                              fontSize: width * 0.035, // responsive font
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: height * 0.03,
            right: width * 0.04,
            child: TextButton(
              onPressed: controller.skipToEnd,
              child: Text(
                "Skip",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: width * 0.045,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Obx(
                    () => Container(
                  color: const Color(0xff212327),
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: height * 0.03,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SmoothPageIndicator(
                        controller: controller.pageController,
                        count: onboardingData.length,
                        effect: WormEffect(
                          dotHeight: height * 0.012,
                          dotWidth: height * 0.012,
                          activeDotColor: AppColors.purple,
                          dotColor: AppColors.grey,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.065,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.pageIndex.value ==
                                onboardingData.length - 1) {
                              Get.toNamed('/location');
                            } else {
                              controller.nextPage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.purple,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                controller.pageIndex.value ==
                                    onboardingData.length - 1
                                    ? "Get Started"
                                    : "Next",
                                style: TextStyle(
                                  fontSize: width * 0.045,
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
