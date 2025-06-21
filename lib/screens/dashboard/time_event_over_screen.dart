import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TimeEventOverScreen extends StatelessWidget {
  TimeEventOverScreen({super.key});

  final TimeEventOverController controller =
      Get.find<TimeEventOverController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorConstants.appColor,
          title: Text(
            "Time Events",
            style: interTextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  2.sbw,
                  Expanded(
                    child: Text(
                      'Year',
                      style: interTextStyle(size: 12, color: Colors.grey),
                    ),
                  ),
                  18.sbw,
                  Expanded(
                    child: Text(
                      'Month',
                      style: interTextStyle(size: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              5.sbh,
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: DropdownButtonFormField<String>(
                          value: controller.selectedYear,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          items:
                              ['2024', '2025', '2026']
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                  16.sbw,
                  Expanded(
                    child: Container(
                      height: 40,
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: DropdownButtonFormField<String>(
                          value: controller.selectedMonth,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          items:
                              [
                                    'January',
                                    'February',
                                    'March',
                                    'April',
                                    'May',
                                    'June',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.records.length,
                  itemBuilder: (context, index) {
                    var record = controller.records[index];
                    bool isCheckIn = record['checkType'] == 'Check In';
                    Color borderColor =
                        isCheckIn ? Colors.green : Colors.orange;

                    return widgetTimeEvents(
                      record: record,
                      borderColor: borderColor,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {}, // Change icon if needed
          backgroundColor: ColorConstants.appColor,
          shape: const CircleBorder(),
          child: Icon(Icons.add, color: Colors.white), // Optional
        ),
      ),
    );
  }

  Widget widgetTimeEvents({borderColor, record}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Employee/UserName",
                      style: interTextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        size: 14,
                      ),
                    ),
                    3.sbh,
                    Text(
                      record['name'],
                      style: interTextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
              widgetContainer(
                icon: Icons.remove_red_eye,
                bgColors: Colors.white,
                borderColor: ColorConstants.appColor,
                iconColor: ColorConstants.appColor,
                onTap: () {
                  printf('<---on-tap-delete--->');
                },
              ),
              10.sbw,
              widgetContainer(
                icon: Icons.edit,
                bgColors: Colors.white,
                borderColor: ColorConstants.appColor,
                iconColor: ColorConstants.appColor,
                onTap: () {
                  printf('<---on-tap-delete--->');
                },
              ),
              10.sbw,
              widgetContainer(
                icon: Icons.delete,
                bgColors: Colors.white,
                borderColor: ColorConstants.appColor,
                iconColor: ColorConstants.appColor,
                onTap: () {
                  printf('<---on-tap-delete--->');
                },
              ),
            ],
          ),
          15.sbh,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Employee No./User",
                      style: interTextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        size: 14,
                      ),
                    ),
                    3.sbh,
                    Text(
                      record['userId'],
                      style: interTextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 15,
                          width: 15,
                          child: Icon(Icons.access_time, size: 15),
                        ),
                        2.sbw,
                        Text(
                          record['datetime'],
                          style: interTextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    4.sbw,
                    Text(
                      "Check Type: ${record['checkType']}",
                      style: interTextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
