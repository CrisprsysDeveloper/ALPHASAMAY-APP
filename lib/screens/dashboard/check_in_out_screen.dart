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

  final CheckInOutController controller = Get.find<CheckInOutController>();

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
                Obx(
                  () => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorConstants.appColor,
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        ClipOval(
                          child:
                              controller.image.value != null
                                  ? Image.file(
                                    controller.image.value!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.asset(
                                    'assets/icons/ic_user_profile.png',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt_outlined),
                            onPressed: () {
                              controller.showImageSourceDialog();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorConstants.appColor, // border color
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
                  "Employee Type",
                  style: interTextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                    size: 12.sp,
                  ),
                ),
                2.sbh,
                Obx(
                  () => Container(
                    color: Colors.grey.shade300,
                    child:
                        controller.isView.value
                            ? SizedBox(
                              width: Get.width,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  top: 12.h,
                                  bottom: 12.h,
                                ),
                                child: Text(
                                  controller.selectedPartnerType.value,
                                  style: interTextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    size: 14.sp,
                                  ),
                                ),
                              ),
                            )
                            : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: DropdownButtonFormField<String>(
                                value:
                                    controller.selectedPartnerType.value.isEmpty
                                        ? null
                                        : controller.selectedPartnerType.value,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                items:
                                    controller.partnerTypeDropdown
                                        .map<DropdownMenuItem<String>>((item) {
                                          return DropdownMenuItem(
                                            value: item['id'],
                                            child: Text(item['label'] ?? ''),
                                          );
                                        })
                                        .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedPartnerType.value =
                                        value;
                                    controller.filterListBySelectedEmployee();
                                  }
                                },
                              ),
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
                  "Partner Type",
                  style: interTextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                    size: 12.sp,
                  ),
                ),
                2.sbh,
                Obx(
                  () => Container(
                    color: Colors.grey.shade300,
                    child:
                        controller.isView.value
                            ? SizedBox(
                              width: Get.width,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  top: 12.h,
                                  bottom: 12.h,
                                ),
                                child: Text(
                                  controller.selectedEmpType.value,
                                  style: interTextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    size: 14.sp,
                                  ),
                                ),
                              ),
                            )
                            : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: DropdownButtonFormField<String>(
                                value:
                                    controller.selectedEmpType.value.isEmpty
                                        ? null
                                        : controller.selectedEmpType.value,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                items:
                                    controller.filteredPartnerTypeList
                                        .map(
                                          (item) => DropdownMenuItem<String>(
                                            value: item.id,
                                            child: Text(item.description),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  controller.selectedEmpType.value =
                                      value ?? '';
                                },
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        style: interTextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          size: 12.sp,
                        ),
                      ),
                      2.sbh,
                      GestureDetector(
                        onTap: () {
                          if (!controller.isView.value) {
                            controller.selectDate(context);
                          }
                        },
                        child: Obx(
                          () => Container(
                            width: Get.width,
                            color: Colors.grey.shade300,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            child: Text(
                              controller.defaultDate.value,
                              style: interTextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                20.sbw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Time",
                        style: interTextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          size: 12.sp,
                        ),
                      ),
                      2.sbh,
                      GestureDetector(
                        onTap: () {
                          if (!controller.isView.value) {
                            controller.selectTime(context);
                          }
                        },
                        child: Obx(
                          () => Container(
                            width: Get.width,
                            color: Colors.grey.shade300,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            child: Text(
                              controller.defaultTime.value,
                              style: interTextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            30.sbh,
            controller.isView.value
                ? SizedBox()
                : Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        horizontalMargin: 0,
                        icon: "",
                        text: 'Check in'.toUpperCase(),
                        onPressed: () {
                          controller.buttonCheckIn();
                        },
                      ),
                    ),
                    10.sbw,
                    Expanded(
                      child: CustomButton(
                        horizontalMargin: 0,
                        icon: "",
                        text: 'Check out'.toUpperCase(),
                        onPressed: () {
                          controller.buttonCheckOut();
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
