import 'package:crysprsys/app_binding.dart';
import 'package:crysprsys/route/app_pages.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:crysprsys/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize GetStorage

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Normal Portrait
    DeviceOrientation.portraitDown, // Upside-Down Portrait
  ]);

  await _requestPermissions();
  runApp(const MyApp());
}

// Future<void> _requestPermissions() async {
//   if (await Permission.camera.isDenied) {
//     await Permission.camera.request();
//   }
//
//   if (await Permission.photos.isDenied) {
//     await Permission.photos
//         .request(); // For Android 13+, maps to READ_MEDIA_IMAGES
//   }
//
//   // Optional: For Android below 13, you may also check storage
//   if (await Permission.storage.isDenied) {
//     await Permission.storage.request();
//   }
// }

Future<void> _requestPermissions() async {
  // Camera permission
  if (await Permission.camera.isDenied) {
    await Permission.camera.request();
  }

  // Photos permission (iOS + Android 13+)
  if (await Permission.photos.isDenied) {
    await Permission.photos
        .request(); // For Android 13+, maps to READ_MEDIA_IMAGES
  }

  // Storage (Android < 13)
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }

  // Location (fine location for latitude and longitude)
  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }

  // Optionally check for permanently denied permissions
  if (await Permission.location.isPermanentlyDenied) {
    // You can prompt user to open app settings
    openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StyledToast(
      locale: const Locale('en', 'US'), // Optional
      child: ScreenUtilInit(
        builder: (BuildContext context, Widget? child) {
          return GlobalLoaderOverlay(
            duration: Durations.medium4,
            reverseDuration: Durations.medium4,
            overlayColor: Colors.black.withOpacity(0.5),
            overlayWidgetBuilder:
                (_) => Center(
                  child: SpinKitCircle(color: ColorConstants.white, size: 50.h),
                ),
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: Routes.splash,
              initialBinding: AppBinding(),
              getPages: AppPages.routes,
              title: AppConstants.appName,
            ),
          );
        },
      ),
    );
  }
}

/*

ClientAuth
ClientId : 1
Email : amcssoft@gmail.com

Login
username : Call
password : Crisprsys@123

*/

// TODO ios
// iOS: Add in Info.plist:

// <key>NSPhotoLibraryUsageDescription</key>
// <string>We need access to your photo library to update your profile image.</string>

// for location

// <key>NSLocationWhenInUseUsageDescription</key>
// <string>This app needs access to your location.</string>
// <key>NSLocationAlwaysUsageDescription</key>
// <string>This app needs access to your location.</string>

//& "C:\Users\DELL\Downloads\development_tool\flutter_sdk\flutter_windows_3.29.2-stable\flutter\bin\flutter.bat" pub run flutter_launcher_icons:main

//& "C:\Users\DELL\Downloads\development_tool\flutter_sdk\flutter_windows_3.29.2-stable\flutter\bin\flutter.bat" build apk --debug

/*

Query
1.leave quota --> inside grade what value will be show








*/
