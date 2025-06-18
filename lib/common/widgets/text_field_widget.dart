import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AppTextField extends StatefulWidget {
  final String? textHint;
  final TextEditingController controller;
  final TextInputType? textType;
  final bool isPassword;
  final int? maxLimit;

  const AppTextField({
    super.key,
    required this.controller,
    this.textHint,
    this.textType,
    required this.isPassword,
    this.maxLimit,
  });

  @override
  TextFieldState createState() => TextFieldState();
}

class TextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.h,
      width: Get.width,
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: TextField(
          keyboardType: widget.textType ?? TextInputType.text,
          controller: widget.controller,
          obscureText: widget.isPassword,
          maxLength: widget.maxLimit,
          style: interTextStyle(size: 14.sp, color: Colors.black),
          decoration: InputDecoration(
            hintText: widget.textHint,
            hintStyle: interTextStyle(size: 14.sp, color: Colors.grey),
            // filled: true,
            // fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
