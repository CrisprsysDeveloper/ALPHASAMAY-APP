import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/time_event_model.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/app_constants.dart';
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
              SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  return controller.attendanceList.isNotEmpty
                      ? ListView.builder(
                        itemCount: controller.attendanceList.length,
                        itemBuilder: (context, index) {
                          final emp = controller.attendanceList[index];
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
          onPressed: () async {
            final result = await Get.toNamed(
              Routes.checkInOutScreen,
              arguments: {'from': AppConstants.add, 'checkInId': ''},
            );
            printf('<--result--->$result');
            if (result) {
              controller.getList();
            }
          }, // Change icon if needed
          backgroundColor: ColorConstants.appColor,
          shape: const CircleBorder(),
          child: Icon(Icons.add, color: Colors.white), // Optional
        ),
      ),
    );
  }

  Widget widgetTimeEvents(AttendanceModel employee, {borderColor}) {
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
                      employee.employeeName.toString(),
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
                onTap: () {},
              ),
              10.sbw,
              widgetContainer(
                icon: Icons.edit,
                bgColors: Colors.white,
                borderColor: ColorConstants.appColor,
                iconColor: ColorConstants.appColor,
                onTap: () async {
                  final result = await Get.toNamed(
                    Routes.checkInOutScreen,
                    arguments: {
                      'from': AppConstants.edit,
                      'checkInId': employee.checkInId.toString(),
                    },
                  );
                  if (result) {
                    controller.getList();
                  }
                },
              ),
              10.sbw,
              widgetContainer(
                icon: Icons.delete,
                bgColors: Colors.white,
                borderColor: ColorConstants.appColor,
                iconColor: ColorConstants.appColor,
                onTap: () {
                  controller.showDeleteEventDialog(
                    employee.checkInId.toString(),
                  );
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
                      employee.employeeID.toString(),
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
                          child: Icon(
                            Icons.access_time,
                            size: 15,
                            color: Colors.grey,
                          ),
                        ),
                        2.sbw,
                        Text(
                          '${employee.checkInDate} ${employee.checktime}',
                          style: interTextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    4.sbw,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'CheckType:',
                          style: interTextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            size: 14,
                          ),
                        ),
                        5.sbw,
                        Text(
                          '${employee.checkType}',
                          style: interTextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ],
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
