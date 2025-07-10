import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_justification_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/justification_model.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../route/app_pages.dart';
import '../../utils/app_constants.dart';

class TimeJustificationScreen extends StatefulWidget {
  const TimeJustificationScreen({super.key});

  @override
  State<TimeJustificationScreen> createState() =>
      _TimeJustificationScreenState();
}

class _TimeJustificationScreenState extends State<TimeJustificationScreen> {
  int selectedIndex = 0;

  final tabs = ["Online Data", "Offline Data"];
  final icons = [Icons.cloud, Icons.cloud_off];
  final TimeJustificationController controller =
  Get.find<TimeJustificationController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorConstants.appColor,
          title: Text(
            "Time Justification",
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
              // Custom Tab Bar
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFF5E3E9B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final isSelected = index == selectedIndex;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFF5E3E9B) : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                icons[index],
                                color: isSelected ? Colors.white : Color(0xFF5E3E9B),
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                tabs[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Color(0xFF5E3E9B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              16.sbh,

              // Year & Month Row
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
                    child: Obx(
                          () => Container(
                        height: 40,
                        color: Colors.grey.shade300,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: DropdownButtonFormField<String>(
                            value:
                            controller.selectedYear.value.isEmpty
                                ? null
                                : controller.selectedYear.value,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            items:
                            controller.yearList.map((year) {
                              return DropdownMenuItem<String>(
                                value: year.value,
                                child: Text(year.value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              controller.selectedYear.value = value!;
                              printf('<--selected-year-->${controller.selectedYear.value}',);
                              controller.onYearOrMonthChanged(
                                controller.selectedYear.value,
                                controller.selectedMonth.value,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  16.sbw,
                  Expanded(
                    child: Obx(
                          () => Container(
                        height: 40,
                        color: Colors.grey.shade300,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: DropdownButtonFormField<String>(
                            value:
                            controller.selectedMonth.value.isEmpty
                                ? null
                                : controller.selectedMonth.value,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            items:
                            controller.monthList.map((month) {
                              return DropdownMenuItem<String>(
                                value: month.value,
                                child: Text(month.value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              controller.selectedMonth.value = value!;
                              printf(
                                '<--selected-month-->${controller.selectedMonth.value}',
                              );
                              controller.onYearOrMonthChanged(
                                controller.selectedYear.value,
                                controller.selectedMonth.value,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              20.sbh,

              // List of Records (Filtered by selected tab)
              Expanded(
                child: Obx(() {
                  return controller.employeeList.isNotEmpty
                      ? ListView.builder(
                    itemCount: controller.employeeList.length,
                    itemBuilder: (context, index) {
                      final emp = controller.employeeList[index];
                      return widgetTimeEvents(
                        emp,
                        borderColor: Colors.green,
                      );
                    },
                  )
                      : Center(child: Text(AppConstants.noDataFound));
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.justificationAddScreen);
            },
          backgroundColor: ColorConstants.appColor,
          shape: const CircleBorder(),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget widgetTimeEvents(JustificationItem employee, {borderColor}) {
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
                child: buildTextColumn("Employee/UserName", employee.employeeName),
              ),
              Expanded(
                child: buildTextColumn("Justification No", employee.justid),
              ),
            ],
          ),
          15.sbh,
          Row(
            children: [
              Expanded(
                child: buildTextColumn("Violation Type", employee.partnerType),
              ),
              Expanded(
                child: buildTextColumn("Comment", employee.justifyComments),
              ),
            ],
          ),
          15.sbh,
          Row(
            children: [
              Expanded(child: buildTextColumn("Date", employee.date)),
              Expanded(child: buildTextColumn("Time-In", employee.date)),
            ],
          ),
          15.sbh,
          Row(
            children: [
              Expanded(child: buildTextColumn("Status",employee.status)),
              widgetContainer(
                icon: Icons.remove_red_eye,
                bgColors: Colors.white,
                borderColor: ColorConstants.appColor,
                iconColor: ColorConstants.appColor,
                onTap: () {
                  print('<---on-tap-view--->');
                },
              ),
              10.sbw,
              widgetContainer(
                icon: Icons.edit,
                bgColors: Colors.white,
                borderColor: ColorConstants.appColor,
                iconColor: ColorConstants.appColor,
                onTap: () {
                  print('<---on-tap-edit--->');
                },
              ),
              10.sbw,
              widgetContainer(
                icon: Icons.delete,
                bgColors: Colors.white,
                borderColor: ColorConstants.appColor,
                iconColor: ColorConstants.appColor,
                onTap: () {
                  print('<---on-tap-delete--->');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
          interTextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        3.sbh,
        Text(
          value,
          style:
          interTextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
