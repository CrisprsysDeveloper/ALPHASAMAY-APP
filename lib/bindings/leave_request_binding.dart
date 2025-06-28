import 'package:crysprsys/controllers/dashboard/leave_request_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_justification_controller.dart';
import 'package:get/get.dart';

class LeaveRequestBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveRequestController>(
      () => LeaveRequestController(authRepository: Get.find()),
    );
  }
}
