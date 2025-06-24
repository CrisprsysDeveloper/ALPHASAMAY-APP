import 'package:crysprsys/common/widgets/custom_button.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard/check_in_out_controller.dart';

class CheckInOutScreen extends StatelessWidget {
  CheckInOutScreen({super.key});

  final CheckInOutController controller =
      Get.find<CheckInOutController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstants.appColor,
        title: Text(
          "Check In/Out",
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
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            20.sbh,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                      Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt_outlined),
                          onPressed: () {
                            printf('<----click-to-upload-profile---->');
                          },
                        ),
                      ),
                    ],
                  ),
                ),

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
            20.sbh,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Partner Type",
                    style: interTextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        size: 12.sp
                    )),
                 2.sbh,
                Container(
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedYear,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      items:
                          ['Partner Type', 'Employee Type']
                              .map(
                                (e) => DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ],
            ),
            30.sbh,
            Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Employee Type",
                    style: interTextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        size: 12.sp
                    )),
                2.sbh,
          Container(
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedYear,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      items:
                          ['Partner Type', 'Employee Type']
                              .map(
                                (e) => DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ],
            ),
            30.sbh,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Date",
                        style: interTextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            size: 12.sp
                        )),
                    2.sbh,
                    Container(
                      width: 150,
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                        child:  Text("24/06/2025",
                          style: interTextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Time",
                        style: interTextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            size: 12.sp
                        )),
                    2.sbh,
                    Container(
                      width: 150,
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                        child:  Text("12:15:00",
                          style: interTextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),


            30.sbh,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 180,
                  child: CustomButton(
                    horizontalMargin: 0,
                    icon: "",
                    text: 'Check in'.toUpperCase(),
                    onPressed: () {},
                  ),
                ),
                Container(
                  width: 180,
                  child: CustomButton(
                    horizontalMargin: 0,
                    icon: "",
                    text: 'Check out'.toUpperCase(),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
