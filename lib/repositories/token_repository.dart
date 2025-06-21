import 'package:crysprsys/data/api/dio_client.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:get/get.dart';
//import 'package:dio/dio.dart' as dio; // ✅ Aliased import


class TokenRepository extends GetxService {
  DioClient dioClient = Get.find();

  Future<dynamic> login({required Map<String, dynamic> params}) async {
    return await dioClient.post(AppConstants.loginApi, params: params);
  }


}
