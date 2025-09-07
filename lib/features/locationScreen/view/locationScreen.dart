import 'package:alarm/constants/App_color.dart';
import 'package:alarm/features/locationScreen/controller/locationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationScreen extends StatelessWidget {
  final LocationController _controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Screen size
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: AppColors.Bg_Color,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.08),
              Text(
                "Welcome! Your Personalized Alarm",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: width * 0.08, // responsive font
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                "Allow us to sync your sunset alarm based on your location.",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: height * 0.08),
              Flexible(
                child: CircleAvatar(
                  backgroundImage:
                  AssetImage('assets/images/location-thumb.png'),
                  radius: width * 0.3, // responsive radius
                ),
              ),
              SizedBox(height: height * 0.05),
              SizedBox(
                width: double.infinity,
                height: height * 0.065, // responsive height
                child: ElevatedButton(
                  onPressed: () async {
                    await _controller.getLocation();
                    Get.toNamed('/home', arguments: _controller.locationMessage.value);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4D4D4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: TextStyle(
                      fontSize: width * 0.045,
                      color: AppColors.text,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // centers text + image
                    children: [
                      const Text(
                        "Use Current Location",
                        style: TextStyle(color: AppColors.text),
                      ),
                      SizedBox(width: width * 0.02), // spacing between text & image
                      Image.asset(
                        "assets/icons/location1.png", // replace with your image path
                        height: height * 0.03,       // responsive size
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: height * 0.015),
              SizedBox(
                width: double.infinity,
                height: height * 0.065,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed("/home");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.light_grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: TextStyle(fontSize: width * 0.045),
                  ),
                  child: Text(
                    "Home",
                    style: TextStyle(color: AppColors.text),
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
