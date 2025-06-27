import 'package:crysprsys/controllers/dashboard/dashboard_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.appColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            AppConstants.workForceManagement,
            style: interTextStyle(
              color: Colors.white,
              size: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          // actions: [
          //   Icon(Icons.pie_chart_outline),
          //   const SizedBox(width: 10),
          //   Icon(Icons.notifications_none),
          //   const SizedBox(width: 10),
          //   Padding(
          //     padding: const EdgeInsets.only(right: 16.0),
          //     child: Center(child: Text("0")),
          //   ),
          // ],
        ),
        drawer: widgetDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                10.sbh,
                Row(
                  children: [
                    Expanded(
                      child: widgetDashboardItem(
                        title: '5',
                        desc: 'No.of Employees/Users',
                        onTap: () {},
                        bgColor: Color(0xFF354B5E),
                      ),
                    ),
                    Expanded(
                      child: widgetDashboardItem(
                        title: '1',
                        desc: 'Employees on Leave',
                        onTap: () {},
                        bgColor: Color(0xFF00B6C0),
                      ),
                    ),
                    Expanded(
                      child: widgetDashboardItem(
                        title: '0',
                        desc: 'Check-ins',
                        onTap: () {},
                        bgColor: Color(0xFF00B4D8),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: widgetDashboardItem(
                        title: '0',
                        desc: 'Early Going on yesterday',
                        onTap: () {},
                        bgColor: Color(0xFFF44A89),
                      ),
                    ),
                    Expanded(
                      child: widgetDashboardItem(
                        title: '0',
                        desc: 'Late comings today',
                        onTap: () {},
                        bgColor: Color(0xFFFFD034),
                      ),
                    ),
                    Expanded(
                      child: widgetDashboardItem(
                        title: '1',
                        desc: 'Violations under approval',
                        onTap: () {},
                        bgColor: Color(0xFF6A6A6A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 56,
            width: double.infinity,
            color: ColorConstants.appColor,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Menu',
              style: interTextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                size: 16,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home, color: ColorConstants.appColor),
                  title: Text("Home"),
                  onTap: () {
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: ColorConstants.appColor,
                  ),
                  title: Text("My Account"),
                  onTap: () {
                    Get.toNamed(Routes.myAccount);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group, color: ColorConstants.appColor),
                  title: Text("Workforce Management"),
                  onTap: () {
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.login, color: ColorConstants.appColor),
                  title: Text("Check-in/Out"),
                  onTap: () {
                    Get.toNamed(Routes.checkInOutScreen);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.approval, color: ColorConstants.appColor),
                  title: Text("Check-in/Out Approvals"),
                  onTap: () {
                    Get.toNamed(Routes.checkInOutApproveScreen);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.access_time,
                    color: ColorConstants.appColor,
                  ),
                  title: Text("Time Events"),
                  onTap: () {
                    Get.toNamed(Routes.timeEventOverScreen);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.schedule, color: ColorConstants.appColor),
                  title: Text("Time Justification"),
                  onTap: () {
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.face, color: ColorConstants.appColor),
                  title: Text("Face Registration"),
                  onTap: () {
                    Get.toNamed(Routes.faceRegistrationListScreen);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: ColorConstants.appColor,
                  ),
                  title: Text("Leave Quota"),
                  onTap: () {
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.send, color: ColorConstants.appColor),
                  title: Text("Leave Request"),
                  onTap: () {
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: ColorConstants.appColor,
                  ),
                  title: Text("Notification Dashboard"),
                  onTap: () {
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.bar_chart,
                    color: ColorConstants.appColor,
                  ),
                  title: Text("Measurements"),
                  onTap: () {
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.summarize,
                    color: ColorConstants.appColor,
                  ),
                  title: Text("Measurement Summary"),
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: ColorConstants.appColor),
            title: Text("Logout"),
            onTap: () {
              Get.back();
              controller.buttonLogout();
            },
          ),
        ],
      ),
    );
  }

  Widget widgetDashboardItem({
    bgColor,
    title,
    desc,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 1,
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  5.sbh,
                  Text(
                    title,
                    style: interTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      size: 12,
                    ),
                  ),
                  15.sbh,
                  Text(
                    textAlign: TextAlign.center,
                    desc,
                    style: interTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      size: 12,
                    ),
                  ),
                  5.sbh,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
