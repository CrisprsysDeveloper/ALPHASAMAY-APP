import 'package:crysprsys/controllers/dashboard/leave_overview_controller.dart';
import 'package:get/get.dart';


class LeaveOverviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveOverviewController>(
      () => LeaveOverviewController(authRepository: Get.find()),
    );
  }
}
