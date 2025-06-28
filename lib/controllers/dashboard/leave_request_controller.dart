import 'package:crysprsys/helper/common.dart';
import 'package:crysprsys/repositories/token_repository.dart';
import 'package:get/get.dart';

class LeaveRequestController extends GetxController {
  final TokenRepository authRepository;

  LeaveRequestController({required this.authRepository});


  @override
  void onInit() {
    super.onInit();
    printf('<------init--CreateTimeEventsController----->');
  }

}
