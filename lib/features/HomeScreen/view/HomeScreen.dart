import 'package:alarm/constants/App_color.dart';
import 'package:alarm/features/HomeScreen/controller/alarmController.dart';
import 'package:alarm/features/locationScreen/controller/locationController.dart';
import 'package:alarm/helpers/Alarm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final AlarmController alarmController = Get.put(AlarmController());
  final LocationController locationController = Get.put(LocationController());


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: AppColors.Bg_Color,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.12,),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/icons/location2.png",
                          height: height * 0.03,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: width * 0.01),
                        Expanded(
                          child: Text(
                            locationController.locationMessage.value,
                            style: TextStyle(
                              fontSize: width * 0.04,
                              color: Colors.white,
                            ),
                            maxLines: 1, // only one line
                            overflow: TextOverflow.ellipsis, // show "..." if too long
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.02),
                    SizedBox(
                      width: double.infinity,
                      height: height * 0.065,
                      child: ElevatedButton(
                        onPressed: () => showAddAlarmDialog(context, alarmController),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.light_grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Add Alarm",
                          style: TextStyle(fontSize: width * 0.045, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
            Text(
              "Alarms",
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),

            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: alarmController.alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarmController.alarms[index];
                    return Card(
                      color: AppColors.light_grey,
                      margin: EdgeInsets.symmetric(vertical: height * 0.008),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.015,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Time
                            Text(
                              alarm.time,
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              alarm.date, // formatted like "Fri, 25 Apr 2025"
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: width * 0.03,
                              ),
                              overflow: TextOverflow.ellipsis, // avoids overflow
                            ),
                          ],
                        ),
                        trailing: Obx(() {
                          return Switch(
                            value: alarm.isEnabled.value,
                            onChanged: (_) {
                              alarmController.toggleAlarm(index);
                            },
                            activeColor: Colors.purple,
                            thumbColor: MaterialStateProperty.all(AppColors.text),
                          );
                        }),
                      )

                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
