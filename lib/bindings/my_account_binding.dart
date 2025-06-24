import 'package:crysprsys/controllers/dashboard/my_account_controller.dart';
import 'package:get/get.dart';


class MyAccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAccountController>(() => MyAccountController(authRepository: Get.find()));
  }
}
