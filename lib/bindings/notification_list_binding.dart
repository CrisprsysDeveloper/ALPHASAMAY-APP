import 'package:crysprsys/controllers/dashboard/notification_list_controller.dart';
import 'package:get/get.dart';

class NotificationListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationListController>(
      () => NotificationListController(authRepository: Get.find()),
    );
  }
}
