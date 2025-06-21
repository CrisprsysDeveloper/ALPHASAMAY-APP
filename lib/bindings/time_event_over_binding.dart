import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:get/get.dart';

class TimeEventOverBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeEventOverController>(
      () => TimeEventOverController(authRepository: Get.find()),
    );
  }
}
