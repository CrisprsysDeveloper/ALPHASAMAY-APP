import 'package:crysprsys/controllers/dashboard/face_registration_controller.dart';
import 'package:get/get.dart';


class FaceRegistrationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceRegistrationController>(() => FaceRegistrationController(authRepository: Get.find()));
  }
}
