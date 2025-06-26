import 'dart:convert';

import 'package:crysprsys/helper/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OTPService {
  final Dio _dio = Dio();

  Future<void> getOtp(
    BuildContext context,
    String companyId,
    String email,
  ) async {
    final String url =
        "https://your-domain.com/api/ClientAuthorization/GetCrisprsysMobAppOTP?ClientID=$companyId&UserName=CALL&Email=$email";

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final serviceStatus = jsonDecode(data['ServiceStatus']);

        if (serviceStatus['MessageDescription'] == "Success") {
          // Navigate to OTP Page
        } else {}
      } else {
        throw Exception('Failed to fetch OTP');
      }
    } catch (e) {
      printf('Error: $e');
    }
  }
}
