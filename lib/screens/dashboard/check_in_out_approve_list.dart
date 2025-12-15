import 'package:crysprsys/controllers/dashboard/check_in_out_approve_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/approval_list_model.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckInOutApproveList extends StatelessWidget {
  CheckInOutApproveList({super.key});

  final CheckInOutApproveController controller =
      Get.find<CheckInOutApproveController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstants.appColor,
        title: Text(
          "Check In/Out Approve List",
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
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.approvalList.length,
          itemBuilder: (context, index) {
            final item = controller.approvalList[index];
            return PartnerCard(data: item);
            //   GestureDetector(
            //   onTap: () {
            //     printf("<---user-pic-->${item.checkinUserProfilePath}");
            //     printf("<---register-in-pic-->${item.regUserProfilePath}");
            //     Get.toNamed(
            //       Routes.timeEventApprovalScreen,
            //       arguments: {'emp': item},
            //     );
            //   },
            //   child: widgetApprovalItem(item),
            // );
          },
        );
      }),
    );
  }

  Widget widgetApprovalItem(Attendance data) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            5.sbh,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "User Profile",
                      style: interTextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        size: 12.sp,
                      ),
                    ),
                    2.sbh,
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.deepPurple, width: 1),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  data.regUserProfilePath != null &&
                                          data.regUserProfilePath!.isNotEmpty
                                      ? NetworkImage(
                                        data.regUserProfilePath.toString(),
                                      )
                                      : AssetImage(
                                            'assets/icons/ic_user_profile.png',
                                          )
                                          as ImageProvider,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Check In/Out Profile",
                      style: interTextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        size: 12.sp,
                      ),
                    ),
                    2.sbh,
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.deepPurple, // border color
                          width: 1, // border width
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  data.checkinUserProfilePath != null &&
                                          data
                                              .checkinUserProfilePath!
                                              .isNotEmpty
                                      ? NetworkImage(
                                        data.checkinUserProfilePath.toString(),
                                      )
                                      : AssetImage(
                                            'assets/icons/ic_user_profile.png',
                                          )
                                          as ImageProvider,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            8.sbh,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Partner Object",
                        style: interTextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          size: 12.sp,
                        ),
                      ),
                      2.sbh,
                      Text(
                        data.employeeID,
                        style: interTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          size: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Partner Type",
                        style: interTextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          size: 12.sp,
                        ),
                      ),
                      2.sbh,
                      Text(
                        "Employee",
                        style: interTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          size: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Partner Name",
                        style: interTextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          size: 12.sp,
                        ),
                      ),
                      2.sbh,
                      Text(
                        data.employeeName,
                        style: interTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          size: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            8.sbh,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Check Type",
                        style: interTextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          size: 12.sp,
                        ),
                      ),
                      2.sbh,
                      Text(
                        data.checkType,
                        style: interTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          size: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Check Date",
                        style: interTextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          size: 12.sp,
                        ),
                      ),
                      2.sbh,
                      Text(
                        data.checkInDate,
                        style: interTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          size: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Check Time",
                        style: interTextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          size: 12.sp,
                        ),
                      ),
                      2.sbh,
                      Text(
                        data.checktime,
                        style: interTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          size: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            5.sbh,
          ],
        ),
      ),
    );
  }
}

class PartnerCard extends StatelessWidget {
  final Attendance data;

  const PartnerCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 32,
                    backgroundImage:
                        data.regUserProfilePath != null &&
                                data.regUserProfilePath!.isNotEmpty
                            ? NetworkImage(data.regUserProfilePath.toString())
                            : AssetImage('assets/icons/ic_user_profile.png')
                                as ImageProvider,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'User Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    data.employeeName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                width: 1,
                color: Colors.grey[300],
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 32,
                      backgroundImage:
                          data.checkinUserProfilePath != null &&
                                  data.checkinUserProfilePath!.isNotEmpty
                              ? NetworkImage(
                                data.checkinUserProfilePath.toString(),
                              )
                              : AssetImage('assets/icons/ic_user_profile.png')
                                  as ImageProvider,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check In/Out Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Badge(
                          label: data.checkType,
                          color: Colors.green[100]!,
                          textColor: Colors.green[900]!,
                        ),
                        SizedBox(width: 8), // Spacing between badges
                        Badge(
                          label: '${data.checkInDate} • ${data.checktime}',
                          //'17/09/2025  •  21:49:00',
                          color: Colors.blue[100]!,
                          textColor: Colors.blue[900]!,
                        ),
                      ],
                    ),
                    SizedBox(height: 16), // Spacing between badges and buttons
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: <Widget>[
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         // Action for View button
                    //       },
                    //       child: Text('View'),
                    //     ),
                    //     SizedBox(width: 8), // Spacing between buttons
                    //     ElevatedButton(
                    //       onPressed: () {},
                    //       child: Text('Approve'),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              Routes.timeEventApprovalScreen,
                              arguments: {'emp': data},
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(
                                25,
                              ), // rounded corners
                            ),
                            child: Text(
                              'View',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8), // Spacing between buttons
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              Routes.timeEventApprovalScreen,
                              arguments: {'emp': data},
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              'Approve',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  Badge({required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
