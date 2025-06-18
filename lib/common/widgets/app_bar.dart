import 'package:crysprsys/helper/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const CommonAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Colors.deepPurple,
      width: Get.width,
      child: Center(
        child: Text(
          text,
          style: interTextStyle(
            color: Colors.white,
            size: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(66.h);
}
