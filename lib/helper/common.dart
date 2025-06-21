import 'package:crysprsys/utils/color_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

printf(String msg) {
  if (kDebugMode) {
    print(msg);
  }
}

interTextStyle({
  double size = 16,
  Color color = ColorConstants.textColorWhite,
  double lineHeight = 1.2,
  double letterSpacing = 0,
  bool lineThrough = false,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    fontWeight: fontWeight ?? FontWeight.w400,
    fontFamily: 'Inter',
    fontSize: size,
    letterSpacing: letterSpacing,
    height: lineHeight,
    color: color,
    decoration: lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
  );
}

dot() {
  return Container(
    width: 4, // Size of the dot
    height: 4,
    decoration: BoxDecoration(
      color: ColorConstants.textColorLight, // Dot color
      shape: BoxShape.circle, // Makes it a circle
    ),
  );
}

// Custom Clipper for Bottom Curve
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

widgetContainer({
  bgColors,
  borderColor,
  iconColor,
  icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: bgColors,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: borderColor, // Change to your desired border color
          width: 1, // Optional: adjust thickness
        ),
      ),
      child: Center(child: Icon(icon, color: iconColor, size: 18)),
    ),
  );
}
