import 'package:crysprsys/controllers/dashboard/face_registration_list_controller.dart';
import 'package:get/get.dart';


class FaceRegistrationListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceRegistrationListController>(() => FaceRegistrationListController(authRepository: Get.find()));
  }
}
