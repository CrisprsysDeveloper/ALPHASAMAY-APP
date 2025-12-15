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
  var checkInKey = '';

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
      checkInKey = emp.checkinPhotoKey.toString();
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

  buttonReject() async {
    if (await InternetConnection().hasInternetAccess) {
      showProgress();

      try {
        final url =
            'https://apis.crisprsys.net/api//TimeEventApprovals/RejectTimeEventProfile?'
            'ClientId=$clientId&UserName=$userName&EventID=$eventId&EventStatus=Rejected';

        printf('<---url-->$url');

        final dio = dio_.Dio();
        final response = await dio.get(url);

        printf('<---response-for-validation-->$response');
        //printf('Response runtimeType: ${response.data.runtimeType}');
        //printf('Raw response: ${response.data}');
        if (response.data is Map<String, dynamic>) {
          final messageText = response.data['MessageText'] ?? '';
          printf('msg-text--->$messageText');
          if (messageText.isNotEmpty) {
            Get.back();
            dropDownBannerError(messageText);
          }
        }
      } catch (e, stackTrace) {
        printf('Error occurred: $e');
        printf('StackTrace: $stackTrace');
        dropDownBannerError(AppConstants.somethingWentWrong);
      } finally {
        hideProgress(); // Always executed, whether success or error
      }
    }
  }

  buttonApprove() async {
    if (await InternetConnection().hasInternetAccess) {
      showProgress();

      try {
        final url =
            'https://apis.crisprsys.net/api//TimeEventApprovals/ApproveTimeEventProfile?'
            'ClientId=$clientId&UserName=$userName&EventID=$eventId&EventStatus=Approved&CheckInPhotoKey=$checkInKey';

        printf('<---url-->$url');

        final dio = dio_.Dio();
        final response = await dio.get(url);

        printf('<---response-for-validation-->$response');
        //printf('Response runtimeType: ${response.data.runtimeType}');
        //printf('Raw response: ${response.data}');
        if (response.data is Map<String, dynamic>) {
          final messageText = response.data['MessageText'] ?? '';
          printf('msg-text--->$messageText');
          if (messageText.isNotEmpty) {
            Get.back();
            dropDownBannerSuccess(messageText,duration: 800);
          }
        }
      } catch (e, stackTrace) {
        printf('Error occurred: $e');
        printf('StackTrace: $stackTrace');
        dropDownBannerError(AppConstants.somethingWentWrong);
      } finally {
        hideProgress(); // Always executed, whether success or error
      }
    }
  }
}
