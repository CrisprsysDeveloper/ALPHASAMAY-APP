import 'package:crysprsys/controllers/dashboard/leave_quota_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../model/dashboard/leave_quota_model.dart';

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
                  Expanded(
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
                  Expanded(
                    child: Obx(
                      () => Container(
                        height: 40,
                        color: Colors.grey.shade300,
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
                        height: 40,
                        color: Colors.grey.shade300,
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
                          final emp = controller.employeesLeavesList[index];
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
              Expanded(
                child: buildTextColumn("Grade", leaveData.grade),
              ),
            ],
          ),
          15.sbh,
          Row(
            children: [
              Expanded(
                child: buildTextColumn("Leave Status", leaveData.leaveStatus),
              ),
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
                  controller.showDeleteEventDialog(
                    leaveData.leaveID.toString(),
                  );
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
