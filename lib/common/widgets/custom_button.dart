import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String? icon;
  final VoidCallback onPressed;
  final double? horizontalMargin;
  final Color? bgColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.horizontalMargin,
    this.textColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 20.w),
      height: 52.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? Colors.deepPurple, //ColorConstants.btnBgColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.h),
          ),
          // side: BorderSide(
          //   color: ColorConstants.btnBorderColor,
          // ), // Optional border
        ),
        onPressed: onPressed,
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon!.isNotEmpty) ...[
              Image.asset(icon.toString(), height: 20.h, width: 20.h),
              //Icon(icon, color: Colors.white, size: 20),
              SizedBox(width: 8),
            ],
            Text(
              text,
              style: interTextStyle(
                size: 16.sp,
                color: textColor ?? ColorConstants.textColorWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
