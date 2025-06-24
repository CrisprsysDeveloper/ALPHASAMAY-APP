import 'package:crysprsys/controllers/dashboard/check_in_out_approve_controller.dart';
import 'package:crysprsys/controllers/dashboard/check_in_out_controller.dart';
import 'package:get/get.dart';


class CheckInOutApproveBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckInOutApproveController>(() => CheckInOutApproveController(authRepository: Get.find()));
  }
}
