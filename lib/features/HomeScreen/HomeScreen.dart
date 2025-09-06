import 'package:alarm/features/HomeScreen/alarmController.dart';
import 'package:alarm/features/locationScreen/locationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final AlarmController alarmController = Get.put(AlarmController());
  final LocationController locationController = Get.put(LocationController());

  void _showAddAlarmDialog(BuildContext context) async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null) return;

    selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime == null) return;

    final DateTime alarmDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    alarmController.addAlarm(alarmDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Color(0xff212327),
      appBar: AppBar(
        title: Text('Home', style: TextStyle(fontSize: width * 0.05)),
        backgroundColor: Color(0xff212327),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Obx(() {
              return Text(
                locationController.locationMessage.value.isEmpty
                    ? "Fetching your address..."
                    : locationController.locationMessage.value,
                style: TextStyle(fontSize: width * 0.04, color: Colors.white),
              );
            }),
            SizedBox(height: height * 0.015),
            if (locationController.locationMessage.value.isEmpty) // Only show button if the location is empty
              SizedBox(
                width: double.infinity,
                height: height * 0.065,
                child: ElevatedButton(
                  onPressed: () async {
                    // Change the state to indicate fetching
                    locationController.locationMessage.value = "Fetching your address...";

                    // Fetch the location asynchronously
                    await locationController.getLocation();

                    // You can add additional logic after the location is fetched, e.g., update the message
                    // Example: if the location fetch is successful, update the message to "Location fetched successfully"
                    if (locationController.locationMessage.value.isEmpty) {
                      locationController.locationMessage.value = "Location fetched successfully!";
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4D4D4D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Get My Address",
                    style: TextStyle(fontSize: width * 0.045, color: Colors.white),
                  ),
                ),
              ),
            SizedBox(height: height * 0.02),
            SizedBox(
              width: double.infinity,
              height: height * 0.065,
              child: ElevatedButton(
                onPressed: () => _showAddAlarmDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff4D4D4D),
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
            SizedBox(height: height * 0.02),
            Text(
              "Alarms",
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.01),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: alarmController.alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarmController.alarms[index];
                    return Card(
                      color: Color(0xff4D4D4D),
                      margin: EdgeInsets.symmetric(vertical: height * 0.008),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.04, vertical: height * 0.015),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              alarm.time,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              alarm.date,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: width * 0.035,
                              ),
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
                          );
                        }),
                      ),
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
