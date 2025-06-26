import 'dart:convert';

import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:crysprsys/utils/extension_classes.dart';
import 'package:crysprsys/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:dio/dio.dart';

class OtpScreen extends StatefulWidget {
  final String clientID;
  final String email;

  const OtpScreen({super.key, required this.clientID, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.appColor,
        title: Text(
          "OTP",
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please Enter Verification Code",
              style: interTextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                size: 24.sp,
              ),
            ),
            20.sbh,
            PinCodeTextField(
              length: 6,
              appContext: context,
              onChanged: (event) {
                if (event.length == 6) {
                  printf('<---call-verify-otp--->');
                  // verifyOtp(event);
                  verifyOTPApi(
                    clientId: widget.clientID,
                    otp: event,
                    email: widget.email,
                  );
                }
              },
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(6),
                fieldHeight: 40,
                fieldWidth: 36,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                activeColor: Colors.grey,
                selectedColor: Colors.deepPurple,
                inactiveColor: Colors.grey,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  getOtpApi(
                    clientId: widget.clientID,
                    userName: 'CALL',
                    email: widget.email,
                  );
                },
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyOTPApi({
    required String clientId,
    required String otp,
    required String email,
  }) async {
    final dio = Dio();

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.otpVerificationApi;

    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();
        setState(() {});

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'ClientID': clientId,
            'UserName': 'CALL',
            'Email': email,
            'OTP': otp,
          },
        );

        printf('<----response---->$response');

        final Map<String, dynamic> outerJson = jsonDecode(response.data);

        // Step 2: Decode the nested JSON string in "ServiceStatus"
        final Map<String, dynamic> serviceStatus = jsonDecode(
          outerJson['ServiceStatus'],
        );

        final String messageCode = serviceStatus['MessageCode'];
        final String messageDescription = serviceStatus['MessageDescription'];

        printf('MessageCode: $messageCode');
        printf('MessageDescription: $messageDescription');

        if (messageCode == "200") {
          dropDownBannerSuccess(
            'Client code authentication completed successfully',
          );

          await GetStorage().write(
            AppConstants.prefClientID,
            clientId.toString(),
          );

          Get.toNamed(Routes.loginScreen);
        } else {
          dropDownBannerError(messageDescription);
        }

        hideProgress();
        setState(() {});
      } catch (e) {
        printf("Exception otp verify: $e");
        hideProgress();
        setState(() {});
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }

  Future<void> getOtpApi({
    required String clientId,
    required String userName,
    required String email,
  }) async {
    final dio = Dio();

    // Construct the full URL
    const String baseUrl = AppConstants.baseUrl; // Replace with your base URL
    const String endpoint = AppConstants.clientAuthenticationApi;
    if (await InternetConnection().hasInternetAccess) {
      try {
        showProgress();
        setState(() {});

        final response = await dio.get(
          '$baseUrl$endpoint',
          queryParameters: {
            'ClientID': clientId,
            'UserName': userName,
            'Email': email,
          },
        );

        printf('<----response---->$response');

        final Map<String, dynamic> outerJson = jsonDecode(response.data);

        // Step 2: Decode the nested JSON string in "ServiceStatus"
        final Map<String, dynamic> serviceStatus = jsonDecode(
          outerJson['ServiceStatus'],
        );

        final String messageCode = serviceStatus['MessageCode'];
        final String messageDescription = serviceStatus['MessageDescription'];

        printf('MessageCode: $messageCode');
        printf('MessageDescription: $messageDescription');

        if (messageCode == "200") {
          dropDownBannerSuccess('OTP sent successfully');
        } else {
          dropDownBannerError(messageDescription);
        }

        hideProgress();
        setState(() {});
      } catch (e) {
        printf("Exception: $e");
        hideProgress();
        setState(() {});
      }
    } else {
      Utility.showToastMessage(AppConstants.internetConnectionError);
    }
  }
}
