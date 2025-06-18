import 'package:crysprsys/controllers/authentication/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:crysprsys/common/widgets/app_bar.dart';
import 'package:crysprsys/common/widgets/custom_button.dart';
import 'package:crysprsys/common/widgets/text_field_widget.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(text: AppConstants.login),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  200.sbh,
                  20.sbh,
                  Text(
                    AppConstants.userName.toUpperCase(),
                    style: interTextStyle(size: 12.sp, color: Colors.grey),
                  ),
                  6.sbh,
                  AppTextField(
                    controller: controller.textUserName,
                    isPassword: false,
                    textHint: AppConstants.userName,
                  ),
                  20.sbh,
                  Text(
                    AppConstants.password.toUpperCase(),
                    style: interTextStyle(size: 12.sp, color: Colors.grey),
                  ),
                  6.sbh,
                  AppTextField(
                    controller: controller.textPassword,
                    isPassword: true,
                    textHint: AppConstants.password,
                  ),
                  10.sbh,
                  Row(
                    children: [
                      Obx(
                        () => Checkbox(
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: controller.isRememberMe.value,
                          onChanged: (bool? value) {
                            controller.isRememberMe.value = value ?? false;
                          },
                        ),
                      ),
                      const Text("Remember Me"),
                    ],
                  ),
                  20.sbh,
                  CustomButton(
                    horizontalMargin: 0,
                    icon: "",
                    text: AppConstants.login.toUpperCase(),
                    onPressed: () {},
                  ),
                  20.sbh,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
