import 'package:crysprsys/bindings/authentication_binding.dart';
import 'package:crysprsys/bindings/dashboard_binding.dart';
import 'package:crysprsys/bindings/face_registration_list_binding.dart';
import 'package:crysprsys/bindings/login_binding.dart';
import 'package:crysprsys/bindings/time_event_over_binding.dart';
import 'package:crysprsys/screens/authentication/authentication_screen.dart';
import 'package:crysprsys/screens/authentication/login_screen.dart';
import 'package:crysprsys/screens/dashboard/dashboard_screen.dart';
import 'package:crysprsys/screens/dashboard/face_registration_list.dart';
import 'package:crysprsys/screens/dashboard/time_event_over_screen.dart';
import 'package:crysprsys/screens/splash_screen.dart';
import 'package:get/get.dart';

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
  ];
}
