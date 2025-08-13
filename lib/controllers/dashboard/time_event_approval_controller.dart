import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/model/dashboard/approval_list_model.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:get/get.dart';

class TimeEventApprovalController extends GetxController {
  final TokenRepository authRepository;

  TimeEventApprovalController({required this.authRepository});

  RxString userProfile = ''.obs;
  RxString checkInProfile = ''.obs;

  @override
  void onInit() {
    super.onInit();
    printf('<------init--TimeEventApprovalController----->');
    try {
      Attendance emp = Get.arguments['emp'];

      userProfile.value = emp.regUserProfilePath.toString();
      checkInProfile.value = emp.checkinUserProfilePath.toString();

      printf('userProfile :${userProfile.value}');
      printf('checkInProfile :${checkInProfile.value}');

    } catch (e) {
      printf('exe-approval-->$e');
    }
  }
}
