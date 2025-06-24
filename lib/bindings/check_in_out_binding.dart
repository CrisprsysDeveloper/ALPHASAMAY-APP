import 'package:crysprsys/controllers/dashboard/check_in_out_controller.dart';
import 'package:get/get.dart';


class CheckInOutBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckInOutController>(() => CheckInOutController(authRepository: Get.find()));
  }
}
