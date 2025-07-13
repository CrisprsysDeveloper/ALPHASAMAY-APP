import 'package:crysprsys/controllers/dashboard/check_in_out_approve_controller.dart';
import 'package:crysprsys/controllers/dashboard/check_in_out_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_event_approval_controller.dart';
import 'package:get/get.dart';


class TimeEventApprovalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeEventApprovalController>(() => TimeEventApprovalController(authRepository: Get.find()));
  }
}
