import 'dart:convert';

import 'package:crysprsys/controllers/dashboard/dashboard_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../model/dashboard/dashboard_response.dart';
import 'package:fl_chart/fl_chart.dart';

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
          actions: [
            IconButton(
              icon: Icon(Icons.pie_chart_outline),
              onPressed: () {
                Get.toNamed(Routes.timeEventOverScreen);
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: () {
                Get.toNamed(Routes.notificationListScreen);
              },
            ),
          ],
        ),
        drawer: widgetDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                10.sbh,
                // Dynamic dashboard items based on API response
                GetBuilder<DashboardController>(
                  builder: (controller) {
                    if (controller.isLoadingDashboard.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.appColor,
                        ),
                      );
                    }
                    if (controller.dashboardData == null) {
                      return Center(
                        child: Text(
                          'No dashboard data available',
                          style: interTextStyle(
                            color: Colors.grey,
                            size: 14.sp,
                          ),
                        ),
                      );
                    }

                    try {
                      final dashboardResponse = DashboardResponse.fromJson(
                        controller.dashboardData!,
                      );
                      return _buildDynamicDashboard(dashboardResponse);
                    } catch (e) {
                      return Center(
                        child: Text(
                          'Error loading dashboard data',
                          style: interTextStyle(color: Colors.red, size: 14.sp),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicDashboard(DashboardResponse dashboardResponse) {
    List<Widget> widgets = [];
    List<Widget> currentRow = [];

    for (int i = 0; i < dashboardResponse.listOfDashboardQueries.length; i++) {
      final tile = dashboardResponse.listOfDashboardQueries[i];

      if (tile.typeOfReport.toLowerCase() == 'count') {
        currentRow.add(
          Expanded(
            child: widgetDashboardItem(
              title: _extractValueFromQueryResult(tile.queryResult),
              desc: tile.tileName,
              onTap: () {
                // Handle tap action based on navigationTargetBusObject
                _handleTileNavigation(tile);
              },
              bgColor: _parseColor(tile.tileBgColor),
            ),
          ),
        );
      } else if (tile.typeOfReport.toLowerCase() == 'chart') {
        // If we have items in current row, add them first
        if (currentRow.isNotEmpty) {
          widgets.add(Row(children: List.from(currentRow)));
          currentRow.clear();
        }

        // Add chart widget
        widgets.add(
          widgetChart(
            graphId: tile.graphId,
            tileName: tile.tileName,
            queryResult: tile.queryResult, // already a List<dynamic>
            bgColor: _parseColor(tile.tileBgColor),
          ),
        );
      }

      // Add row when we have 3 items or reached the end
      if (currentRow.length == 3 ||
          i == dashboardResponse.listOfDashboardQueries.length - 1) {
        if (currentRow.isNotEmpty) {
          widgets.add(Row(children: List.from(currentRow)));
          currentRow.clear();
        }
      }
    }

    return Column(children: widgets);
  }

  String _extractValueFromQueryResult(List<dynamic> queryResult) {
    try {
      if (queryResult.isNotEmpty && queryResult[0] is Map<String, dynamic>) {
        final firstResult = queryResult[0] as Map<String, dynamic>;
        return firstResult['Value']?.toString() ?? '0';
      }
    } catch (e) {
      print('Error extracting value from query result: $e');
    }
    return '0';
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.isEmpty) return Color(0xFF354B5E); // Default color

      // Remove # if present
      String cleanColor = colorString.replaceAll('#', '');

      // Add alpha if not present
      if (cleanColor.length == 6) {
        cleanColor = 'FF$cleanColor';
      }

      return Color(int.parse(cleanColor, radix: 16));
    } catch (e) {
      print('Error parsing color: $colorString, Error: $e');
      return Color(0xFF354B5E); // Default color
    }
  }

  void _handleTileNavigation(DashboardTile tile) {
    // Handle navigation based on navigationTargetBusObject
    if (tile.navigationTargetBusObject.isNotEmpty) {
      // Add your navigation logic here
      print('Navigate to: ${tile.navigationTargetBusObject}');
      // Example: Get.toNamed(tile.navigationTargetBusObject);
    }
  }

  Widget widgetChart({
    required String graphId,
    required String tileName,
    required List<dynamic> queryResult,
    required Color bgColor,
  }) {
    return Card(
      elevation: 0,

      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: bgColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tileName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  graphId == 'Bar-chart'
                      ? BarChartWidget(queryResult: queryResult)
                      : PieChartWidget(queryResult: queryResult),
            ),
          ],
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
                  leading: Icon(Icons.login, color: ColorConstants.appColor),
                  title: Text("Check-in/Out"),
                  onTap: () {
                    Get.toNamed(
                      Routes.checkInOutScreen,
                      arguments: {'from': AppConstants.add, 'checkInId': ''},
                    );
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
                  leading: Icon(Icons.schedule, color: ColorConstants.appColor),
                  title: Text("Time Justification"),
                  onTap: () {
                    Get.toNamed(Routes.timeJustificationScreen);
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
                  title: Text("Leave Overview"),
                  onTap: () {
                    Get.toNamed(Routes.leaveOverviewScreen);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: ColorConstants.appColor,
                  ),
                  title: Text("Leave Quota"),
                  onTap: () {
                    Get.toNamed(Routes.leaveQuotaScreen);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.send, color: ColorConstants.appColor),
                  title: Text("Leave Request"),
                  onTap: () {
                    Get.toNamed(Routes.leaveRequestScreen);
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

class BarChartWidget extends StatelessWidget {
  final List<dynamic> queryResult;

  const BarChartWidget({super.key, required this.queryResult});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < queryResult.length; i++) {
      final item = queryResult[i];
      final count = (item['Count'] ?? 0).toDouble();

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count,
              color: Colors.blue,
              width: 30,
              borderRadius: BorderRadius.circular(1),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 280,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          gridData: FlGridData(show: true),
          borderData: FlBorderData(
            show: true,
            border: const Border(left: BorderSide(), bottom: BorderSide()),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index < queryResult.length) {
                    final label = queryResult[index]['Name'] ?? '';
                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final List<dynamic> queryResult;

  const PieChartWidget({super.key, required this.queryResult});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];

    for (int i = 0; i < queryResult.length; i++) {
      final item = queryResult[i];
      final count = (item['Count'] ?? 0).toDouble();
      final color = Colors.primaries[i % Colors.primaries.length];

      sections.add(
        PieChartSectionData(
          value: count,
          title: item['Name'] ?? '',
          color: color,
          radius: 60,
          titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      );
    }

    return PieChart(
      PieChartData(sections: sections, centerSpaceRadius: 30, sectionsSpace: 4),
    );
  }
}
