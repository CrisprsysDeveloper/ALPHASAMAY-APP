import 'package:crysprsys/controllers/dashboard/dashboard_report_controller.dart';
import 'package:get/get.dart';

class DashboardReportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardReportController>(
      () => DashboardReportController(authRepository: Get.find()),
    );
  }
}
