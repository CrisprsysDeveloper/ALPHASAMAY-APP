import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationListController extends GetxController {
  final TokenRepository authRepository;

  NotificationListController({required this.authRepository});

  final box = GetStorage();

  var clientId = '1';
  var userName = 'Call';

  @override
  void onInit() {
    super.onInit();
    printf('<------init--NotificationListController----->');
    loadSavedCredentials();
  }

  void loadSavedCredentials() {
    final savedUsername = box.read(AppConstants.prefUsername);
    final companyId = box.read(AppConstants.prefClientID);

    if (savedUsername != null) {
      userName = savedUsername;
    }

    if (companyId != null) {
      clientId = companyId;
    }

    printf('<---userName-->$userName---clientId--->$clientId');
  }
}
