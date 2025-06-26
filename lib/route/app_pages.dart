import 'package:crysprsys/bindings/authentication_binding.dart';
import 'package:crysprsys/bindings/check_in_out_approve_binding.dart';
import 'package:crysprsys/bindings/check_in_out_binding.dart';
import 'package:crysprsys/bindings/dashboard_binding.dart';
import 'package:crysprsys/bindings/face_registration_binding.dart';
import 'package:crysprsys/bindings/face_registration_list_binding.dart';
import 'package:crysprsys/bindings/login_binding.dart';
import 'package:crysprsys/bindings/time_event_over_binding.dart';
import 'package:crysprsys/screens/authentication/authentication_screen.dart';
import 'package:crysprsys/screens/authentication/login_screen.dart';
import 'package:crysprsys/screens/authentication/otp_screen.dart';
import 'package:crysprsys/screens/dashboard/check_in_out_approve_list.dart';
import 'package:crysprsys/screens/dashboard/check_in_out_screen.dart';
import 'package:crysprsys/screens/dashboard/dashboard_screen.dart';
import 'package:crysprsys/screens/dashboard/face_registration_list.dart';
import 'package:crysprsys/screens/dashboard/face_registration_screen.dart';
import 'package:crysprsys/screens/dashboard/my_account.dart';
import 'package:crysprsys/screens/dashboard/time_event_over_screen.dart';
import 'package:crysprsys/screens/splash_screen.dart';
import 'package:get/get.dart';

import '../bindings/my_account_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => SplashScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.loginScreen,
      page: () => LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.authenticationScreen,
      page: () => AuthenticationScreen(),
      binding: AuthenticationBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.dashboardScreen,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.faceRegistrationListScreen,
      page: () => FaceRegistrationListScreen(),
      binding: FaceRegistrationListBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.timeEventOverScreen,
      page: () => TimeEventOverScreen(),
      binding: TimeEventOverBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.timeEventOverScreen,
      page: () => TimeEventOverScreen(),
      binding: TimeEventOverBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.faceRegistrationScreen,
      page: () => FaceRegistrationScreen(),
      binding: FaceRegistrationBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.myAccount,
      page: () => MyAccount(),
      binding: MyAccountBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.checkInOutScreen,
      page: () => CheckInOutScreen(),
      binding: CheckInOutBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.checkInOutApproveScreen,
      page: () => CheckInOutApproveList(),
      binding: CheckInOutApproveBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    // GetPage(
    //   name: Routes.otpScreen,
    //   page: () => OtpScreen(),
    //   transition: Transition.rightToLeftWithFade,
    // ),
  ];
}
