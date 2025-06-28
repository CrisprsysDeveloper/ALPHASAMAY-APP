import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_justification_controller.dart';
import 'package:get/get.dart';

class TimeJustificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeJustificationController>(
      () => TimeJustificationController(authRepository: Get.find()),
    );
  }
}
