import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/helper/snackbar_toast.dart';
import 'package:crysprsys/model/dashboard/approval_list_model.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:crysprsys/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:dio/dio.dart' as dio_;

class TimeEventApprovalController extends GetxController {
  final TokenRepository authRepository;

  TimeEventApprovalController({required this.authRepository});

  RxString userProfile = ''.obs;
  RxString checkInProfile = ''.obs;

  final box = GetStorage();
  var clientId = '1';
  var userName = 'Call';
  int eventId = 0;

  @override
  void onInit() {
    super.onInit();
    printf('<------init--TimeEventApprovalController----->');
    loadSavedCredentials();
    try {
      Attendance emp = Get.arguments['emp'];

      userProfile.value = emp.regUserProfilePath.toString();
      checkInProfile.value = emp.checkinUserProfilePath.toString();
      eventId = emp.checkInId ?? 0;
      printf('userProfile :${userProfile.value}');
      printf('checkInProfile :${checkInProfile.value}');
      printf('eventId :${emp.checkInId.toString()}');
    } catch (e) {
      printf('exe-approval-->$e');
    }
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

  buttonApprove() async {
    if (await InternetConnection().hasInternetAccess) {
      showProgress();
      final url =
          'https://api.crisprsys.net/api/TimeEventApprovals/RejectTimeEventProfile?'
          'ClientId=$clientId&UserName=$userName&EventID=$eventId&EventStatus=Approved';

      printf('<---url-->$url');

      final dio = dio_.Dio();
      final response = await dio.get(url);
      printf('<---response-for-validation-->$response');

      printf('Response runtimeType: ${response.data.runtimeType}');
      printf('Raw response: ${response.data}');
    }
  }
}
