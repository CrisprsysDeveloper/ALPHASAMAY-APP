import 'package:crysprsys/controllers/dashboard/leave_quota_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../model/dashboard/leave_quota_model.dart';
import '../../route/app_pages.dart';

class LeaveQuotaScreen extends StatefulWidget {
  const LeaveQuotaScreen({super.key});

  @override
  State<LeaveQuotaScreen> createState() => _LeaveQuotaScreenState();
}

class _LeaveQuotaScreenState extends State<LeaveQuotaScreen> {
  int selectedIndex = 0;

  final tabs = ["Online Data", "Offline Data"];
  final icons = [Icons.cloud, Icons.cloud_off];
  final LeaveQuotaController controller = Get.find<LeaveQuotaController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorConstants.appColor,
          title: Text(
            "Leave Quota",
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
                  SizedBox(
                    width: 76.w,
                    child: Text(
                      'Year',
                      style: interTextStyle(size: 12, color: Colors.grey),
                    ),
                  ),
                  18.sbw,
                  Expanded(
                    child: Text(
                      'Employee',
                      style: interTextStyle(size: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              5.sbh,
              Row(
                children: [
                  SizedBox(
                    width: 86.w,
                    child: Obx(
                      () => Container(
                        height: 40.h,
                        color: Colors.grey.shade200,
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
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
                                  child: Text(
                                    year.value,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            controller.selectedYear.value = value!;
                            controller.onYearOrMonthChanged(
                              controller.selectedYear.value,
                              controller.selectedEmp.value,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w), // reduced from 16.w
                  Expanded(
                    child: Obx(
                      () => Container(
                        height: 40.h,
                        color: Colors.grey.shade200,
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value:
                              controller.employeeList.value.isEmpty
                                  ? null
                                  : controller.selectedEmp.value,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          items:
                              controller.employeeList.map((month) {
                                return DropdownMenuItem<String>(
                                  value: month.value,
                                  child: Text(
                                    month.value,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            controller.selectedEmp.value = value!;
                            controller.onYearOrMonthChanged(
                              controller.selectedYear.value,
                              controller.selectedEmp.value,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              20.sbh,
              Expanded(
                child: Obx(() {
                  return controller.employeesLeavesList.isNotEmpty
                      ? ListView.builder(
                        itemCount: controller.employeesLeavesList.length,
                        itemBuilder: (context, index) {
                          return widgetLeaveQuota(
                            controller.employeesLeavesList[index],
                          );
                        },
                      )
                      : Center(child: Text(AppConstants.noDataFound));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetLeaveQuota(LeaveQuotaItem data) {
    final actualQuota = int.tryParse(data.actualQuota ?? '') ?? 0;
    final blockedQuota = int.tryParse(data.blockedQuota ?? '') ?? 0;

    int bl = actualQuota - blockedQuota;

    if (bl < 0) {
      bl = 0;
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        'Employee No',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Employee Name',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 46.w,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Grade',
                          style: interTextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            size: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        data.pernr.toString(),
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          size: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data.empName.toString(),
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          size: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40.w,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          '0',
                          style: interTextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        'Start Date',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'End Date',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80.w,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Leave Type',
                          style: interTextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            size: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        data.leaveStartDate.toString(),
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          size: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data.leaveEndDate.toString(),
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          size: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          data.leaveType.toString(),
                          style: interTextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        'Actual Quota',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Utilized Quota',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Balance Quota',
                          style: interTextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            size: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        data.actualQuota, // '0',
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          size: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data.blockedQuota,
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          size: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          bl.toString(),
                          style: interTextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget widgetTimeEvents(LeaveQuotaItem leaveData, {borderColor}) {
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
                child: buildTextColumn("Employee/UserName", leaveData.empName),
              ),
              Expanded(child: buildTextColumn("LeaveID No", leaveData.qid)),
            ],
          ),
          15.sbh,
          Row(
            children: [
              Expanded(
                child: buildTextColumn("Leave Type", leaveData.leaveType),
              ),
              Expanded(child: buildTextColumn("Cost Center", "ST Branch")),
            ],
          ),
          15.sbh,
          Row(
            children: [
              Expanded(
                child: buildTextColumn("Start Date", leaveData.leaveStartDate),
              ),
              Expanded(
                child: buildTextColumn("End Date", leaveData.leaveEndDate),
              ),
            ],
          ),
          15.sbh,
          Row(
            children: [
              Expanded(
                child: buildTextColumn("Actual Quota", leaveData.actualQuota),
              ),
              Expanded(
                child: buildTextColumn("Utilized Quota", leaveData.usedQuota),
              ),
            ],
          ),
          15.sbh,
          Row(
            children: [
              Expanded(
                child: buildTextColumn("Balance Quota", leaveData.balanceQuota),
              ),
              Expanded(child: buildTextColumn("Grade", leaveData.grade)),
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
          style: interTextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        3.sbh,
        Text(
          value,
          style: interTextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
