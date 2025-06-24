import 'package:crysprsys/controllers/dashboard/check_in_out_approve_controller.dart';
import 'package:crysprsys/helper/common.dart';
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
        // actions: [
        //   Icon(Icons.notifications, color: Colors.white),
        //   SizedBox(width: 8),
        //   Icon(Icons.search),
        //   SizedBox(width: 10),
        // ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: controller.users.length,
        itemBuilder: (context, index) {
          final user = controller.users[index];
          return Container(
            child: Card(
              elevation: 1,
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              )
              ,
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
                                    size: 12.sp
                                )),
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
                                    child: const CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                        'assets/icons/ic_user_profile.png',
                                      ), // Replace with your image
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
                                    size: 12.sp
                                )),
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
                                    child: const CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                        'assets/icons/ic_user_profile.png',
                                      ), // Replace with your image
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "Partner Object",
                                style: interTextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    size: 12.sp
                                )),
                            2.sbh,
                            Text(
                                "465431589165",
                                style: interTextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    size: 12.sp
                                )),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "Partner Type",
                                style: interTextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    size: 12.sp
                                )),
                            2.sbh,
                            Text(
                                "Employee",
                                style: interTextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    size: 12.sp
                                )),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "Partner Name",
                                style: interTextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    size: 12.sp
                                )),
                            2.sbh,
                            Text(
                                "Employee Name",
                                style: interTextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    size: 12.sp
                                )),
                          ],
                        ),

                      ],
                    ),
                    8.sbh,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "Check Type",
                                style: interTextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    size: 12.sp
                                )),
                            2.sbh,
                            Text(
                                "Check In",
                                style: interTextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    size: 12.sp
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "Check Date",
                                style: interTextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    size: 12.sp
                                )),
                            2.sbh,
                            Text(
                                "24/06/2025",
                                style: interTextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    size: 12.sp
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "Check Time",
                                style: interTextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    size: 12.sp
                                )),
                            2.sbh,
                            Text(
                                "16:57:00",
                                style: interTextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    size: 12.sp
                                )),
                          ],
                        ),

                      ],
                    ),
                    5.sbh,
                  ],
                ),
              ),
            ),
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.checkInOutScreen);
        }, // Change icon if needed
        backgroundColor: ColorConstants.appColor,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white), // Optional
      ),
    );
  }
}
