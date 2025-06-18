import 'package:crysprsys/controllers/dashboard/dashboard_controller.dart';
import 'package:get/get.dart';


class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(authRepository: Get.find()));
  }
}
