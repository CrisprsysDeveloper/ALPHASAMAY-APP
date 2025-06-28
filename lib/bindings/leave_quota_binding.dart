import 'package:get/get.dart';

import '../controllers/dashboard/leave_quota_controller.dart';

class LeaveQuotaBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveQuotaController>(
      () => LeaveQuotaController(authRepository: Get.find()),
    );
  }
}
