import 'package:crysprsys/controllers/authentication/login_controller.dart';
import 'package:crysprsys/model/authentication/login_model.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:flutter/material.dart';
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: ColorConstants.appColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              AppConstants.login,
              style: interTextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.help_outline, color: Colors.white),
                onSelected: (String value) {
                  printf('Selected: $value');
                  Get.toNamed(Routes.authenticationScreen);
                },
                itemBuilder: (BuildContext context) {
                  return ["1"].map((item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text('Change $item ClientID?'),
                    );
                  }).toList();
                },
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/icons/app_icon.png',
                        height: 250,
                        width: 250,
                      ),
                    ),
                    20.sbh,
                    Text(
                      AppConstants.userName.toUpperCase(),
                      style: interTextStyle(size: 12.sp, color: Colors.grey),
                    ),
                    6.sbh,
                    AppTextField(
                      textType: TextInputType.text,
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
                      textType: TextInputType.emailAddress,
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
                      onPressed: () {
                        controller.buttonLogin();
                      },
                    ),
                    20.sbh,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
