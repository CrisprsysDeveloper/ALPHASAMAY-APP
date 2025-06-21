import 'package:crysprsys/repositories/token_repository.dart';
import 'package:get/get.dart';
import 'data/api/dio_client.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(DioClient(), permanent: true);
    Get.put(TokenRepository(), permanent: true);
  }
}
