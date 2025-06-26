import 'package:crysprsys/common/widgets/app_bar.dart';
import 'package:crysprsys/common/widgets/custom_button.dart';
import 'package:crysprsys/common/widgets/text_field_widget.dart';
import 'package:crysprsys/controllers/authentication/authentication_controller.dart';
import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen({super.key});

  final AuthenticationController controller =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(text: AppConstants.clientAuthentication),
          body: SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  20.sbh,
                  AppTextField(
                    textType: TextInputType.number,
                    controller: controller.textCompany,
                    isPassword: false,
                    textHint: AppConstants.companyId,
                  ),
                  20.sbh,
                  AppTextField(
                    textType: TextInputType.emailAddress,
                    controller: controller.textEmail,
                    isPassword: false,
                    textHint: AppConstants.email,
                  ),
                  20.sbh,
                  CustomButton(
                    horizontalMargin: 0,
                    icon: "",
                    text: AppConstants.submit.toUpperCase(),
                    onPressed: () {
                      controller.buttonSubmit();
                    },
                  ),
                  30.sbh,
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.loginScreen);
                    },
                    child: Text(
                      AppConstants.backToLogin.toUpperCase(),
                      style: interTextStyle(
                        color: ColorConstants.appColor,
                        size: 16.sp,
                      ),
                    ),
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
