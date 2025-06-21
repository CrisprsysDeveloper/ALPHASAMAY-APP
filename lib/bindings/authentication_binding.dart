import 'package:crysprsys/controllers/authentication/authentication_controller.dart';
import 'package:crysprsys/controllers/authentication/login_controller.dart';
import 'package:get/get.dart';

class AuthenticationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticationController>(
      () => AuthenticationController(authRepository: Get.find()),
    );
  }
}
