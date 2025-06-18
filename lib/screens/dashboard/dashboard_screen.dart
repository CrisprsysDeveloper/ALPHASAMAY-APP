import 'package:crysprsys/controllers/dashboard/dashboard_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/app_constants.dart';
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
          backgroundColor: Colors.deepPurpleAccent,
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
        body: Center(child: Text('Dashboard')),
      ),
    );
  }

  Widget widgetDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 60.h,
            width: Get.width,
            color: Colors.deepPurpleAccent,
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.deepPurpleAccent),
            title: Text("Home"),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.deepPurpleAccent),
            title: Text("My Account"),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.refresh, color: Colors.deepPurpleAccent),
            title: Text("Logout"),
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
