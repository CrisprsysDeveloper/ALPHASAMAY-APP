import 'package:crysprsys/controllers/dashboard/justification_add_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_justification_controller.dart';
import 'package:get/get.dart';

class JustificationAddBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JustificationAddController>(
      () => JustificationAddController(authRepository: Get.find()),
    );
  }
}
