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
            20.sbh,
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
                      ['Business Object', 'Business object']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            30.sbh,
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
                      ['Business Object', 'Business object']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            30.sbh,
            CustomButton(
              horizontalMargin: 0,
              icon: "",
              text: 'Register'.toUpperCase(),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
