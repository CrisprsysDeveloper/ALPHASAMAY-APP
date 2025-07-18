import 'package:crysprsys/common/widgets/custom_button.dart';
import 'package:crysprsys/controllers/dashboard/face_registration_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaceRegistrationScreen extends StatelessWidget {
  FaceRegistrationScreen({super.key});

  final FaceRegistrationController controller =
      Get.find<FaceRegistrationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstants.appColor,
        title: Text(
          "Face Registration",
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
            // Obx(
            //   () => Container(
            //     height: 120,
            //     width: 120,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       border: Border.all(
            //         color: ColorConstants.appColor,
            //         width: 1, // border width
            //       ),
            //     ),
            //     child: Stack(
            //       children: [
            //         ClipOval(
            //           child:
            //               controller.image.value != null
            //                   ? Image.file(
            //                     controller.image.value!,
            //                     width: 120,
            //                     height: 120,
            //                     fit: BoxFit.cover,
            //                   )
            //                   : Image.asset(
            //                     'assets/icons/ic_user_profile.png',
            //                     width: 120,
            //                     height: 120,
            //                     fit: BoxFit.cover,
            //                   ),
            //         ),
            //         Align(
            //           alignment: Alignment.center,
            //           child: IconButton(
            //             icon: Icon(Icons.camera_alt_outlined),
            //             onPressed: () {
            //               controller.showImageSourceDialog();
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Obx(
              () => Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorConstants.appColor, width: 1),
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
                              : (controller.imageUrl.isNotEmpty
                                  ? Image.network(
                                    controller.imageUrl,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (
                                          context,
                                          error,
                                          stackTrace,
                                        ) => Image.asset(
                                          'assets/icons/ic_user_profile.png',
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                  )
                                  : Image.asset(
                                    'assets/icons/ic_user_profile.png',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )),
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

            20.sbh,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Business Object",
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: DropdownButtonFormField<String>(
                        value:
                            controller.selectedObject.value.isEmpty
                                ? null
                                : controller.selectedObject.value,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        items:
                            controller.businessObjectDropdownItems
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item['id'],
                                    child: Text(item['label'] ?? ''),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          printf('<---selected-business-object-->$value');
                          controller.selectedObject.value = value ?? '';
                          controller.filterAttendanceListBySelectedObject();
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
                  "Object Number",
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: DropdownButtonFormField<String>(
                        value:
                            controller.selectedObjectNumber.value.isEmpty
                                ? null
                                : controller.selectedObjectNumber.value,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        items:
                            controller.filteredAttendanceUserList
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item.id,
                                    child: Text(item.description),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          controller.selectedObjectNumber.value = value ?? '';
                          printf(
                            '<--selected-object-number--->${controller.selectedObjectNumber}',
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            30.sbh,
            CustomButton(
              horizontalMargin: 0,
              icon: "",
              text: 'Register'.toUpperCase(),
              onPressed: () async {
                if (controller.faceId.isNotEmpty) {
                  controller.updateRegisterFace();
                } else {
                  controller.registerFace();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
