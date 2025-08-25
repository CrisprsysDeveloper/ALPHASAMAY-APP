import 'package:crysprsys/controllers/dashboard/dashboard_report_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/dashboard_report_model.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardReportScreen extends StatelessWidget {
  DashboardReportScreen({super.key});

  final DashboardReportController controller =
      Get.find<DashboardReportController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorConstants.appColor,
          title: Obx(() {
            return controller.searchQuery.isEmpty
                ? Text(
                  "Dashboard Report",
                  style: interTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )
                : TextField(
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onChanged: controller.search,
                );
          }),
          leading: InkWell(
            onTap: () {
              if (controller.searchQuery.isNotEmpty) {
                controller.search(""); // clear search
              } else {
                Get.back();
              }
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            Obx(() {
              return IconButton(
                icon: Icon(
                  controller.searchQuery.isEmpty ? Icons.search : Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (controller.searchQuery.isEmpty) {
                    controller.searchQuery.value = " "; // trigger search bar
                  } else {
                    controller.search(""); // clear and reset
                  }
                },
              );
            }),
          ],
        ),
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Obx(() {
              return controller.filteredEmployees.isNotEmpty
                  ? ListView.builder(
                    itemCount: controller.filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final item = controller.filteredEmployees[index];
                      return widgetDashboardReportItem(
                        item,
                        controller.reportFields,
                      );
                    },
                  )
                  : Center(child: Text(AppConstants.noDataFound));
            }),
          ),
        ),
      ),
    );
  }

  Widget widgetDashboardReportItem(
    Map<String, dynamic> data,
    List<String> fields,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 1.8,
          children:
              fields.map((field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      data[field] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget widgetDashboardReportItemOld(Employee data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: Colors.grey.shade50,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
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
                        'Name',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Position',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'LeaveStartDate',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.employeeNo,
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.black,
                          size: 13.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data.name,
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.black,
                          size: 13.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data.position,
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.black,
                          size: 13.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data.dateOfJoining,
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.black,
                          size: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'LeaveEndDate',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'LeaveStatus',
                        style: interTextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          size: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '',
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.black,
                          size: 13.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '',
                        style: interTextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.black,
                          size: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
