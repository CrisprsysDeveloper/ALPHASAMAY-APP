import 'package:crysprsys/controllers/authentication/login_controller.dart';
import 'package:get/get.dart';


class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(authRepository: Get.find()));
  }
}
