import 'package:crysprsys/controllers/dashboard/create_time_events_controller.dart';
import 'package:crysprsys/controllers/dashboard/time_event_over_controller.dart';
import 'package:get/get.dart';

class TimeEventOverBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTimeEventsController>(
      () => CreateTimeEventsController(authRepository: Get.find()),
    );
  }
}
