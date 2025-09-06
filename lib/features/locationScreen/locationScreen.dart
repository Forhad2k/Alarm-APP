import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'locationController.dart';

class LocationScreen extends StatelessWidget {
  final LocationController _controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Screen size
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Color(0xff212327),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.05),
              Text(
                "Welcome! Your Personalized Alarm",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.08, // responsive font
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                "Allow us to sync your sunset alarm based on your location.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: height * 0.05),
              Flexible(
                child: CircleAvatar(
                  backgroundImage:
                  AssetImage('assets/images/location-thumb.png'),
                  radius: width * 0.25, // responsive radius
                ),
              ),
              SizedBox(height: height * 0.07),
              SizedBox(
                width: double.infinity,
                height: height * 0.065, // responsive height
                child: ElevatedButton(
                  onPressed: () async {
                    await _controller.getLocation();
                    Get.toNamed('/home',
                        arguments: _controller.locationMessage.value);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4D4D4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: TextStyle(
                      fontSize: width * 0.045,
                      color: Colors.white,
                    ),
                  ),
                  child: const Text(
                    "Use Current Location",
                    style: TextStyle(color: Colors.white),
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
                    backgroundColor: Color(0xff4D4D4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: TextStyle(fontSize: width * 0.045),
                  ),
                  child: Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
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
