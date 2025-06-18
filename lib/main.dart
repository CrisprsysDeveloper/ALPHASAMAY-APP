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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize GetStorage

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Normal Portrait
    DeviceOrientation.portraitDown, // Upside-Down Portrait
  ]);

  runApp(const MyApp());
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
            overlayWidgetBuilder: (_) => Center(
              child: SpinKitCircle(
                color: ColorConstants.white,
                size: 50.h,
              ),
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

