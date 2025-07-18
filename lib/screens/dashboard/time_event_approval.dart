import 'package:crysprsys/common/widgets/custom_button.dart';
import 'package:crysprsys/controllers/dashboard/time_event_approval_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard/check_in_out_controller.dart';

class TimeEventApproval extends StatelessWidget {
  TimeEventApproval({super.key});

  final TimeEventApprovalController controller =
      Get.find<TimeEventApprovalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstants.appColor,
        title: Text(
          "Time Event Approvals",
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'User Profile',
                      style: interTextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ),
                10.sbw,
                Expanded(
                  child: Center(
                    child: Text(
                      'Checkin Profile',
                      style: interTextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            10.sbh,
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        'assets/icons/ic_user_profile.png',
                        // Replace with your actual asset path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                10.sbw,
                Expanded(
                  child: Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        'assets/icons/ic_user_profile.png',
                        // Replace with your actual asset path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            30.sbh,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    horizontalMargin: 0,
                    icon: "",
                    text: 'Reject',
                    onPressed: () {
                      // Accept logic here
                    },
                  ),
                ),
                10.sbw,
                Expanded(
                  child: CustomButton(
                    horizontalMargin: 0,
                    icon: "",
                    text: 'Approve',
                    onPressed: () {
                      // Reject logic here
                    },
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
